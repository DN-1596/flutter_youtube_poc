import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_states/index.dart';
import 'package:flutter_youtube_poc/src/player_utilities.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NFPlayerBloc extends Bloc<NFPlayerEvent, NFPlayerState> {
  ValueNotifier<Video> pipVideo = ValueNotifier(null);
  List<Video> playlist;
  final List<dynamic> playlistJson;
  final int initialVideoIndex;
  YoutubePlayerController playerController;
  YoutubePlayerController pipController;

  /// tracks time played per video in seconds
  Map<String, int> playTracker = new Map();

  static final List<NFPlayerEvent> _events = new List<NFPlayerEvent>();

  NFPlayerBloc({@required this.playlistJson, this.initialVideoIndex})
      : super(LoadingState()) {
    this.add(InitiatePlayer());
  }

  @override
  Stream<NFPlayerState> mapEventToState(NFPlayerEvent event) async* {
    _events.add(event);

    if (event is InitiatePlayer) {
      yield* initiatePlayer();
    }
    if (event is GetVideoList) {
      yield* getVideoList(event.initialScrollIndex);
    }
    if (event is PlayVideo) {
      loadVideo(event.index);
      yield MainVideoPlayerState(event.index);
    }
    if (event is GetFullScreenVideoPlayer) {
      loadVideo(event.index);
      yield FullScreenVideoPlayerState(event.index);
    }
  }

  /// initiate player time trackers for the current session to 0 seconds, in the future these times can be obtained from the JSON as well
  Stream<NFPlayerState> initiatePlayer() async* {
    this.playlist = PlayerUtils.getPlaylist(playlistJson);

    playlist?.forEach((element) {
      playTracker[element.id] = 0;
    });

    int _initialVideoIndex = initialVideoIndex ?? -1;
    if (_initialVideoIndex > -1 && _initialVideoIndex < playlist.length) {
      yield* loadVideo(_initialVideoIndex);
    } else {
      yield VideoListState(
        autoPlayIndex: 0,
      );
    }
  }

  Stream<NFPlayerState> getVideoList([int initialScrollIndex = 0]) async* {
    if (playerController?.value?.isPlaying ?? false) playerController.pause();
    yield VideoListState(
      initialScrollIndex: initialScrollIndex,
    );
  }

  /// MAIN PLAYER METHOD CALLS --

  loadVideo(int index) {
    if (playerController == null) {
      initiatePlayerController(index);
    } else {
      initiatePlayerController(index, playTracker[playlist[index].id]);
    }
    cancelPIP();
  }

  initiatePlayerController([int index = 0, int startAt = 0]) {
    playerController = YoutubePlayerController(
      initialVideoId: playlist[index].id,
      flags: YoutubePlayerFlags(mute: false, autoPlay: true, startAt: startAt),
    );
    playerController.addListener(playerControllerListener);
  }

  playerControllerListener() {
    playTracker[playerController.metadata.videoId] =
        playerController.value.position.inSeconds;
  }

  /// PIP METHOD CALLS --

  loadPIP(int index) {
    if (pipController == null) {
      initiatePIPController(index);
    } else {
      initiatePIPController(index, playTracker[playlist[index].id]);
    }
    pipVideo.value = playlist[index];
  }

  initiatePIPController(int index, [int startAt = 0]) {
    pipController = YoutubePlayerController(
      initialVideoId: playlist[index].id,
      flags: YoutubePlayerFlags(mute: false, autoPlay: true, startAt: startAt),
    );
    pipController.addListener(pipControllerListener);
  }

  pipControllerListener() {
    playTracker[pipController.metadata.videoId] =
        pipController.value.position.inSeconds;
  }

  cancelPIP() {
    pipVideo.value = null;
  }

  /// FULL SCREEN METHOD CALLS ---

  dispatchPreviousState() {
    // Removes the current event from the stack
    _events.removeLast();
    // Dispatched the previous event
    this.add(_events.removeLast());
  }

  /// CUE METHOD CALLS ---

  getNextVideoForPlayer(int currIndex) {
    int totalVideo = playlist.length;
    int nextIndex = currIndex + 1;

    if (nextIndex < totalVideo) {
      this.add(PlayVideo(nextIndex));
    } else {
      playerController.pause();
    }
  }

  getNextVideoForFullScreenPlayer(int currIndex) {
    int totalVideo = playlist.length;
    int nextIndex = currIndex + 1;

    if (nextIndex < totalVideo) {
      this.add(GetFullScreenVideoPlayer(nextIndex));
    } else {
      playerController.pause();
    }
  }
}
