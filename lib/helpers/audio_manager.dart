import 'package:just_audio/just_audio.dart';

class AudioManager {
  AudioManager() {
    _manager = AudioPlayer();
  }

  late AudioPlayer _manager;
  AudioPlayer get manager => _manager;

  UriAudioSource? _source;

  Future<void> setSource({UriAudioSource? source}) async {
    source ??= _source;
    if (source == null) return;
    await manager.setLoopMode(LoopMode.all);
    await manager.setAudioSources(
      [source, source],
      initialIndex: 0,
      initialPosition: Duration.zero,
    );
    _source = source;
  }

  Future<void> play(UriAudioSource source) async {
    await setSource(source: source);
    await restart();
    resume();
  }

  Future<void> pause() async {
    await manager.pause();
  }

  Future<void> resume() async {
    await setSource();
    manager.play();
  }

  Future<void> restart() async {
    manager.seek(Duration.zero);
    await resume();
  }
}
