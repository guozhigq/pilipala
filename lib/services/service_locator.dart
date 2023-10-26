import 'audio_handler.dart';

late VideoPlayerServiceHandler videoPlayerServiceHandler;

Future<void> setupServiceLocator() async {
  final audio = await initAudioService();
  videoPlayerServiceHandler = audio;
}
