import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path_provider/path_provider.dart';

class Track {
  const Track({
    required this.title,
    required this.author,
    required this.album,
    required this.duration,
    this.picture,
    this.localPath,
    this.url,
  }) : assert(
          url != null || localPath != null,
          'At least the url or local path must not be null',
        );

  final String title;
  final String author;
  final String album;
  final Duration duration;
  final String? url;
  final String? localPath;
  final Picture? picture;

  String get formattedDuration {
    final totalSeconds = duration.inSeconds;
    int minutes = (totalSeconds / 60).round();
    int seconds = (totalSeconds % 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<UriAudioSource> get source async {
    Uri? uri;
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
          '${tempDir.path}/album_art_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(picture!.data);
      uri = Uri.file(tempFile.path);
    } catch (e) {
      print('failed to get album cover');
    }
    final media = MediaItem(
      id: '$title.$author',
      album: "My Awesome Album",
      title: title,
      artist: author,
      artUri: uri,
    );
    if (localPath != null) return AudioSource.file(localPath!, tag: media);
    return AudioSource.uri(
      Uri.parse(url!),
      tag: media,
    );
  }

  @override
  String toString() {
    return {
      'title': title,
      'author': author,
      'album': album,
      'duration': formattedDuration,
      'url': url,
      'localPath': localPath,
      'picture': picture,
    }.toString();
  }
}
