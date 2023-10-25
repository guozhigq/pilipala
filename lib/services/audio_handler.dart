import 'package:audio_service/audio_service.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:get/get.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

Future<VideoPlayerServiceHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => VideoPlayerServiceHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.guozhigq.pilipala.audio',
      androidNotificationChannelName: 'Audio Service Pilipala',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      fastForwardInterval: Duration(seconds: 10),
      rewindInterval: Duration(seconds: 10),
      androidNotificationChannelDescription: 'Media notification channel',
    ),
  );
}

class VideoPlayerServiceHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static final List<MediaItem> _item = [];

  @override
  Future<void> play() async {
    PlPlayerController.getInstance().play();
  }

  @override
  Future<void> pause() async {
    PlPlayerController.getInstance().pause();
  }

  @override
  Future<void> seek(Duration position) async {
    playbackState.add(playbackState.value.copyWith(
      updatePosition: position,
    ));
    await PlPlayerController.getInstance().seekTo(position);
  }

  Future<void> setMediaItem(MediaItem newMediaItem) async {
    mediaItem.add(newMediaItem);
    addQueueItem(newMediaItem);
  }

  Future<void> setPlaybackState(PlayerStatus status, bool isBuffering) async {
    final AudioProcessingState processingState;
    final playing = status == PlayerStatus.playing;
    if (status == PlayerStatus.completed) {
      processingState = AudioProcessingState.completed;
    } else if (isBuffering) {
      processingState = AudioProcessingState.buffering;
    } else {
      processingState = AudioProcessingState.ready;
    }

    playbackState.add(playbackState.value.copyWith(
      processingState:
          isBuffering ? AudioProcessingState.buffering : processingState,
      controls: [
        MediaControl.rewind.copyWith(androidIcon: 'drawable/ic_stat_replay_10'),
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward
            .copyWith(androidIcon: 'drawable/ic_stat_forward_10'),
      ],
      playing: playing,
      systemActions: const {
        MediaAction.seek,
      },
    ));
  }

  onStatusChange(PlayerStatus status, bool isBuffering) {
    if (_item.isEmpty) return;
    setPlaybackState(status, isBuffering);
  }

  onVideoIntroChange(VideoDetailData data) {
    Map argMap = Get.arguments;
    final heroTag = argMap['heroTag'];

    final mediaItem = MediaItem(
      id: heroTag,
      title: data.title ?? "",
      artist: data.owner?.name ?? "",
      duration: Duration(seconds: data.duration ?? 0),
      artUri: Uri.parse(data.pic ?? ""),
    );
    setMediaItem(mediaItem);
    _item.add(mediaItem);
  }

  onVideoIntroDispose() {
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
    stop();
    _item.removeLast();
    if (_item.isNotEmpty) {
      setMediaItem(_item.last);
    }
    if (_item.isEmpty) {
      playbackState
          .add(playbackState.value.copyWith(updatePosition: Duration.zero));
    }
  }

  onPositionChange(Duration position) {
    playbackState.add(playbackState.value.copyWith(
      updatePosition: position,
    ));
  }
}
