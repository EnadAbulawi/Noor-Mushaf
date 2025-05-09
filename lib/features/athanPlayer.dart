import 'package:audioplayers/audioplayers.dart';

class AthanPlayer {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static Future<void> playAthan() async {
    await _audioPlayer.play(AssetSource('audio/nufaisAthan.mp3'));
  }

  static Future<void> stopAthan() async {
    await _audioPlayer.stop();
  }
}
