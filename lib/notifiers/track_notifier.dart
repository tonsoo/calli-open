import 'dart:async';
import 'dart:io';

import 'package:calliopen/helpers/audio_manager.dart';
import 'package:calliopen/helpers/directories.dart';
import 'package:calliopen/models/track.dart';
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';

class TrackNotifier extends ChangeNotifier {
  TrackNotifier(this._audio) {
    _audio.manager.positionStream.listen((d) => currentTrackDuration = d);
    _audio.manager.playingStream.listen((s) => playing = s);
    _audio.manager.playerStateStream.listen((s) {
      completedTrack = s.processingState == ProcessingState.completed;
      if (completedTrack) {
        _playNextTrack();
      }
    });

    final dir = Directory(FolderPicker.rootPath);
    dir.list(recursive: true).listen((file) {
      if (file is! File) return;
      addLocalTrack(file);
    });

    loadFromDirectories();
  }

  final AudioManager _audio;

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;
  set currentTrack(Track? track) {
    _currentTrack = track;
    notifyListeners();
  }

  bool _completedTrack = false;
  bool get completedTrack => _completedTrack;
  set completedTrack(bool value) {
    if (_completedTrack == value) return;
    _completedTrack = value;
    notifyListeners();
  }

  Duration _currentTrackDuration = Duration.zero;
  Duration get currentTrackDuration => _currentTrackDuration;
  set currentTrackDuration(Duration duration) {
    if (_currentTrackDuration.inSeconds == duration.inSeconds) return;
    _currentTrackDuration = duration;
    notifyListeners();
  }

  bool _playing = false;
  bool get playing => _playing;
  set playing(bool state) {
    if (state == _playing) return;
    _playing = state;
    notifyListeners();
  }

  double get currentTrackProgress => currentTrack?.duration == null ||
          (currentTrack?.duration.inSeconds ?? 0) <= 0
      ? 0
      : _currentTrackDuration.inSeconds / currentTrack!.duration.inSeconds;

  List<Track> _tracks = [];
  List<Track> get tracks => _tracks;

  int _getCurrentTrackIndex() {
    if (_currentTrack == null || _tracks.isEmpty) return -1;
    return _tracks.indexWhere((t) => t.localPath == _currentTrack!.localPath);
  }

  Future<void> _playNextTrack() async {
    if (_tracks.isEmpty) return;

    final int currentIndex = _getCurrentTrackIndex();
    if (currentIndex == -1) {
      await _audio.pause();
      currentTrack = null;
      completedTrack = false;
      return;
    }

    int nextIndex = currentIndex + 1;
    if (nextIndex >= _tracks.length) {
      await _audio.pause();
      currentTrack = null;
      completedTrack = false;
      return;
    }

    await play(_tracks[nextIndex]);
  }

  Future<void> addLocalTrack(File file) async {
    if (lookupMimeType(file.path)?.startsWith('audio/') != true) {
      return;
    }

    final path = file.path;

    try {
      final metadata = await MetadataGod.readMetadata(file: path);
      final track = Track(
        title: metadata.title ?? path.split(Platform.pathSeparator).last,
        author: metadata.artist ?? '',
        album: metadata.album ?? '',
        duration: metadata.duration ?? Duration.zero,
        localPath: path,
        picture: metadata.picture,
      );
      if (_tracks.where((f) => f.localPath == path).isNotEmpty) return;

      _tracks.add(track);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to add track $e');
      }
    }
  }

  Future<void> loadFromDirectories({
    List<String> directories = const [
      '/storage/emulated/0/Music/',
      '/storage/emulated/0/Download/'
    ],
  }) async {
    if (!await canPickDirectory()) return;
    for (var f in directories) {
      _loadAllLocalTracks(Directory(f));
    }
  }

  Future<void> _loadAllLocalTracks(Directory dir) async {
    try {
      final files = dir.listSync();
      files.whereType<Directory>().forEach(_loadAllLocalTracks);

      final audios = files.whereType<File>().toList();
      for (final f in audios) {
        await addLocalTrack(f);
      }

      notifyListeners();
    } catch (e) {
      print('failed at $dir cause $e');
    }
  }

  Future<void> loadLocalTracks(BuildContext context) async {
    _tracks = [];
    final dir = await pickDirectory(context: context);
    if (dir == null) {
      notifyListeners();
      return;
    }

    final audios = dir.listSync().whereType<File>().toList();
    for (final f in audios) {
      await addLocalTrack(f);
    }

    notifyListeners();
  }

  Future<void> play(Track track) async {
    currentTrack = track;
    completedTrack = false;
    _audio.play(await track.source);
    currentTrack = track;
    // TODO: next track?
  }

  Future<void> pause() async {
    await _audio.pause();
  }

  Future<void> toggle() async {
    if (playing) {
      await _audio.pause();
    } else if (completedTrack && currentTrack != null) {
      play(currentTrack!);
    } else {
      _audio.resume();
    }
  }

  Future<void> restart() async {
    _audio.restart();
  }

  Future<void> playNext() async {
    final int currentIndex = _getCurrentTrackIndex();
    if (currentIndex != -1 && currentIndex < _tracks.length - 1) {
      await play(_tracks[currentIndex + 1]);
    } else if (_tracks.isNotEmpty) {
      await play(_tracks.first);
    }
  }

  Future<void> playPrevious() async {
    final int currentIndex = _getCurrentTrackIndex();
    if (currentIndex > 0) {
      await play(_tracks[currentIndex - 1]);
    } else if (_tracks.isNotEmpty) {
      await play(_tracks.last);
    }
  }
}
