import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_components/index.dart';
import 'package:flutter_youtube_poc/src/player_components/nf_youtube_player.dart';
import 'package:flutter_youtube_poc/src/player_states/index.dart';
import 'package:flutter_youtube_poc/src/player_utilities.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum VideoFeedState { pip, fullScreen, description }

class NFPlayerBloc extends Bloc<NFPlayerEvent, NFPlayerState> {
  /// The actual [YoutubePlayer].
  NFYoutubePlayer nfYoutubePlayer;

  /// VideoFeed , current index from the playlist
  ValueNotifier<int> vfIndex = ValueNotifier(null);

  /// VideoFeedState
  ValueNotifier<VideoFeedState> vfState = ValueNotifier(null);

  List<Video> playlist;
  final List<dynamic> playlistJson;
  final int initialVideoIndex;
  final bool isInitialPIP;
  final bool isInitialFullScreen;
  YoutubePlayerController playerController;

  /// tracks time played per video in seconds
  Map<String, int> playTracker = new Map();

  NFPlayerBloc(
      {@required this.playlistJson,
      this.initialVideoIndex,
      this.isInitialFullScreen = false,
      this.isInitialPIP = false})
      : super(LoadingState()) {
    this.add(InitiatePlayer());
  }

  @override
  Stream<NFPlayerState> mapEventToState(NFPlayerEvent event) async* {
    if (event is InitiatePlayer) {
      yield* initiatePlayer();
    }
    if (event is GetVideoList) {
      yield* getVideoList(event.initialScrollIndex);
    }
  }

  /// initiate player time trackers for the current session to 0 seconds,
  /// in the future these times can be obtained from the JSON as well
  Stream<NFPlayerState> initiatePlayer() async* {
    this.playlist = PlayerUtils.getPlaylist(playlistJson);
    nfYoutubePlayer = NFYoutubePlayer();

    playlist?.forEach((element) {
      playTracker[element.id] = 0;
    });

    int _initialVideoIndex = initialVideoIndex ?? -1;
    if (_initialVideoIndex > -1 && _initialVideoIndex < playlist.length) {
      loadVideo(_initialVideoIndex,
          isFullScreen: isInitialFullScreen, isPIP: isInitialPIP);
    }
    yield VideoListState(
      autoPlayIndex: 0,
    );
  }

  /// Controls video list state --

  Stream<NFPlayerState> getVideoList([int initialScrollIndex = 0]) async* {
    yield VideoListState(
      initialScrollIndex: initialScrollIndex,
    );
  }

  /// MAIN PLAYER METHOD CALLS --

  /// Call this method to Load a video in video feed
  loadVideo(int index, {isFullScreen = false, isPIP = false}) {
    initiatePlayerController(
        playlist[index].id, playTracker[playlist[index].id]);

    if (isFullScreen) {
      playerController.toggleFullScreenMode();
      vfState.value = VideoFeedState.fullScreen;
    } else if (isPIP) {
      vfState.value = VideoFeedState.pip;
    } else {
      vfState.value = VideoFeedState.description;
    }
    vfIndex.value = index;
  }

  initiatePlayerController([String videoId = "", int startAt = 0]) {
    if (playerController == null) {
      playerController = YoutubePlayerController(
        initialVideoId: videoId,
        flags:
            YoutubePlayerFlags(mute: false, autoPlay: true, startAt: startAt),
      );
      playerController.addListener(playerControllerListener);
    } else {
      playerController.load(videoId);
    }
  }

  playerControllerListener() {
    playTracker[playerController.metadata.videoId] =
        playerController.value.position.inSeconds;
  }

  cancelVideo() {
    playerController.pause();
    playerController.removeListener(playerControllerListener);
    playerController = null;
    vfIndex.value = null;
  }

  /// CUE METHOD CALLS ---

  getNextVideoForPlayer() {
    int currIndex = vfIndex.value;
    int totalVideo = playlist.length;
    int nextIndex = currIndex + 1;
    VideoFeedState currState = vfState.value;

    if (nextIndex < totalVideo) {
      loadVideo(nextIndex,
          isFullScreen: currState == VideoFeedState.fullScreen,
          isPIP: currState == VideoFeedState.pip);
    } else {
      playerController.pause();
    }
  }
}
