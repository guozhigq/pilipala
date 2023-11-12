import 'audio_handler.dart';
import 'audio_session.dart';

late VideoPlayerServiceHandler videoPlayerServiceHandler;
late AudioSessionHandler audioSessionHandler;

Future<void> setupServiceLocator() async {
  final audio = await initAudioService();
  videoPlayerServiceHandler = audio;
  audioSessionHandler = AudioSessionHandler();
}
