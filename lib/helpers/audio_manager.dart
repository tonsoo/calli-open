import 'package:audioplayers/audioplayers.dart';
import 'package:calliopen/models/track.dart';

class AudioManager {
  AudioManager() {
    _manager = AudioPlayer();
  }

  late AudioPlayer _manager;
  AudioPlayer get manager => _manager;

  Future<void> playTrack(Track track) async {
    final source = track.source;
    await play(source);
  }

  Future<void> playAsset(String asset) async {
    await play(AssetSource(asset));
  }

  Future<void> playUrl(String url) async {
    await play(UrlSource(url));
  }

  Future<void> play(Source source) async {
    await manager.play(source);
  }

  Future<void> pause() async {
    await manager.pause();
  }

  Future<void> resume() async {
    await manager.resume();
  }
}
