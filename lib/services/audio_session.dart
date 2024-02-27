import 'package:audio_session/audio_session.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

class AudioSessionHandler {
  late AudioSession session;
  bool _playInterrupted = false;

  setActive(bool active) {
    session.setActive(active);
  }

  AudioSessionHandler() {
    initSession();
  }

  Future<void> initSession() async {
    session = await AudioSession.instance;
    session.configure(const AudioSessionConfiguration.music());

    session.interruptionEventStream.listen((event) {
      final player = PlPlayerController.getInstance();
      if (event.begin) {
        if (player.playerStatus != PlayerStatus.playing) return;
        switch (event.type) {
          case AudioInterruptionType.duck:
            player.setVolume(player.volume.value * 0.5);
            break;
          case AudioInterruptionType.pause:
            player.pause(isInterrupt: true);
            _playInterrupted = true;
            break;
          case AudioInterruptionType.unknown:
            player.pause(isInterrupt: true);
            _playInterrupted = true;
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            player.setVolume(player.volume.value * 2);
            break;
          case AudioInterruptionType.pause:
            if (_playInterrupted) player.play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _playInterrupted = false;
      }
    });

    // 耳机拔出暂停
    session.becomingNoisyEventStream.listen((_) {
      final player = PlPlayerController.getInstance();
      if (player.playerStatus == PlayerStatus.playing) {
        player.pause();
      }
    });
  }
}
