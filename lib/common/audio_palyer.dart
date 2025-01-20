import 'package:audioplayers/audioplayers.dart';
import 'package:huaroad/module/find_device/find_device_handler.dart';
import 'package:huaroad/plugin/native_flutter_plugin.dart';

class HRAudioPlayer {
  static HRAudioPlayer? _instance;
  final _player = AudioPlayer();
  final _bgmPlayer = AudioPlayer();

  HRAudioPlayer._internal() {
    _instance = this;
    _player.audioCache = AudioCache(prefix: "lib/assets/audio/");
    _player.setPlayerMode(PlayerMode.lowLatency);
    _player.setReleaseMode(ReleaseMode.stop);
    _player.setPlaybackRate(5.0);
    _player.setVolume(1.0);

    _bgmPlayer.audioCache = AudioCache(prefix: "lib/assets/audio/");
    _bgmPlayer.setPlayerMode(PlayerMode.lowLatency);
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _bgmPlayer.setVolume(0.5);
  }

  factory HRAudioPlayer() => _instance ?? HRAudioPlayer._internal();

  bool get isBGMPlaying => _bgmPlayer.state == PlayerState.playing;

  void stop() async => await _player.stop();

  void dispose() async => await _player.dispose();

  void playCannotClick() async {}

  void playClick() async {}

  void playPieceMove() async {
    final allow = await canPlayGameAudio();
    if (!allow) return;

    await _player.stop();
    await _player.setPlaybackRate(3.0);
    await _player.play(AssetSource("piece_move.wav"));
  }

  void playSuccess() async {
    final allow = await canPlayGameAudio();
    if (!allow) return;

    stopGameBGM();
    await _player.stop();
    await _player.setPlaybackRate(1.0);
    await _player.play(AssetSource("success.wav"));
  }

  void playFail() async {
    final allow = await canPlayGameAudio();
    if (!allow) return;

    stopGameBGM();
    await _player.stop();
    await _player.setPlaybackRate(1.0);
    await _player.play(AssetSource("fail.wav"));
  }

  void playGameBGM() async {
    final allow = await canPlayGameBGM();
    if (!allow) return;

    stopGameBGM();
    await _bgmPlayer.play(AssetSource("bgm.wav"));
  }

  void stopGameBGM() async {
    await _bgmPlayer.stop();
  }

  void pauseGameBGM() async {
    await _bgmPlayer.pause();
  }

  void resumeGameBGM() async {
    await _bgmPlayer.resume();
  }

  Future<bool> canPlayGameBGM() async {
    final options = await NativeFlutterPlugin.instance.getGameAudioOptions();
    return (options["musicBg"] == 1 && !FindDeviceHandler().deviceConnected.value);
  }

  Future<bool> canPlayGameAudio() async {
    final options = await NativeFlutterPlugin.instance.getGameAudioOptions();
    return (options["musicGame"] == 1 && !FindDeviceHandler().deviceConnected.value);
  }
}
