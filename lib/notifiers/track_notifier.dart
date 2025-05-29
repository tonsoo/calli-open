import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:calliopen/helpers/audio_manager.dart';
import 'package:calliopen/helpers/directories.dart';
import 'package:calliopen/models/track.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';

class TrackNotifier extends ChangeNotifier {
  TrackNotifier(this._audio) {
    _auxiliarPlayer = AudioPlayer();

    _audio.manager.onPositionChanged.listen((d) => currentTrackDuration = d);
    _audio.manager.onPlayerStateChanged.listen((s) => playerState = s);
  }

  final AudioManager _audio;
  late AudioPlayer _auxiliarPlayer;

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;
  set currentTrack(Track? track) {
    _currentTrack = track;
    notifyListeners();
  }

  Duration _currentTrackDuration = Duration.zero;
  Duration get currentTrackDuration => _currentTrackDuration;
  set currentTrackDuration(Duration duration) {
    if (_currentTrackDuration.inSeconds == duration.inSeconds) return;
    _currentTrackDuration = duration;
    notifyListeners();
  }

  PlayerState _playerState = PlayerState.stopped;
  PlayerState get playerState => _playerState;
  set playerState(PlayerState state) {
    if (state == _playerState) return;
    _playerState = state;
    notifyListeners();
  }

  bool get isPlaying => _playerState == PlayerState.playing;

  double get currentTrackProgress => currentTrack?.duration == null ||
          (currentTrack?.duration.inSeconds ?? 0) <= 0
      ? 0
      : _currentTrackDuration.inSeconds / currentTrack!.duration.inSeconds;

  List<Track> _tracks = [];
  List<Track> get tracks => _tracks;

  Future<void> loadTracks(BuildContext context) async {
    _tracks = [];
    final dir = await pickDirectory(context: context);
    if (dir == null) {
      notifyListeners();
      return;
    }

    final audios = dir
        .listSync()
        .whereType<File>()
        .where((f) => lookupMimeType(f.path)?.startsWith('audio/') == true)
        .toList();
    for (final f in audios) {
      try {
        final metadata = await MetadataGod.readMetadata(file: f.path);
        _tracks.add(Track(
          title: metadata.title ?? f.path.split(Platform.pathSeparator).last,
          author: metadata.artist ?? '',
          duration: metadata.duration ?? Duration.zero,
          localPath: f.path,
          picture: metadata.picture,
        ));
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Failed to add track $e');
        }
      }
    }

    notifyListeners();
  }

  Future<void> play(Track track) async {
    _currentTrack = track;
    await _audio.play(track.source);
    _currentTrack = track;
    // TODO: next track?
  }

  Future<void> pause() async {
    await _audio.pause();
  }

  Future<void> toggle() async {
    if (isPlaying) {
      await _audio.pause();
    } else {
      await _audio.resume();
    }
  }
}
