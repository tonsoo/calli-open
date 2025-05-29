import 'package:audioplayers/audioplayers.dart';
import 'package:metadata_god/metadata_god.dart';

class Track {
  const Track({
    required this.title,
    required this.author,
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

  Source get source {
    if (localPath != null) return DeviceFileSource(localPath!);
    return UrlSource(url!);
  }

  @override
  String toString() {
    return {
      'title': title,
      'author': author,
      'duration': formattedDuration,
      'url': url,
      'localPath': localPath,
      'picture': picture,
    }.toString();
  }
}
