import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_states/index.dart';
import 'package:flutter_youtube_poc/src/services/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideoPlayerState extends StatefulWidget
    implements NFPlayerState {
  final int videoIndex;

  FullScreenVideoPlayerState(this.videoIndex)
      : super(key: ObjectKey(videoIndex));

  @override
  _FullScreenVideoPlayerStateState createState() =>
      _FullScreenVideoPlayerStateState();

  @override
  List<Object> get props => [videoIndex];

  @override
  bool get stringify => false;
}

class _FullScreenVideoPlayerStateState
    extends State<FullScreenVideoPlayerState> {
  YoutubePlayerController controller;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    controller = BlocProvider.of<NFPlayerBloc>(context).playerController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      key: kGlobalObjectKey,
      player: YoutubePlayer(
        controller: controller,
        aspectRatio: 16 / 9,
        actionsPadding: const EdgeInsets.only(left: 16.0),
        onEnded: (m) {
          controller.seekTo(Duration());
          BlocProvider.of<NFPlayerBloc>(context)
              .getNextVideoForFullScreenPlayer(widget.videoIndex);
        },
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            colors: ProgressBarColors(
                backgroundColor: Theme.of(context).backgroundColor,
                playedColor: Theme.of(context).primaryColor,
                bufferedColor: Theme.of(context).hintColor,
                handleColor: Theme.of(context).primaryColor),
            isExpanded: true,
          ),
          RemainingDuration(),
          IconButton(
              icon: Icon(Icons.fullscreen_exit_outlined),
              onPressed: () {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);

                BlocProvider.of<NFPlayerBloc>(context).dispatchPreviousState();
              }),
        ],
      ),
      builder: (context, player) => Center(child: player),
    );
  }

  Widget text(String text, TextStyle textStyle) {
    return Text(
      text ?? "",
      softWrap: true,
      style: textStyle,
    );
  }
}
