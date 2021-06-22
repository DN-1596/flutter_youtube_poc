import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/services/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NFYoutubePlayer extends StatefulWidget {
  @override
  _NFYoutubePlayerState createState() => _NFYoutubePlayerState();
}

class _NFYoutubePlayerState extends State<NFYoutubePlayer> {
  @override
  Widget build(BuildContext context) {
    YoutubePlayerController controller =
        BlocProvider.of<NFPlayerBloc>(context).playerController;
    return YoutubePlayer(
      playerKey: kPlayerKey,
      aspectRatio: 16 / 9,
      controller: controller,
      actionsPadding: const EdgeInsets.all(4.0),
      showVideoProgressIndicator: true,
      onEnded: (m) {
        controller.seekTo(Duration());
        BlocProvider.of<NFPlayerBloc>(context).getNextVideoForPlayer();
      },
      topActions: _topActions(
          context, BlocProvider.of<NFPlayerBloc>(context).vfState.value),
      bottomActions: _bottomAction(
          context, BlocProvider.of<NFPlayerBloc>(context).vfState.value),
    );
  }

  List<Widget> _topActions(
      BuildContext context, VideoFeedState videoFeedState) {
    switch (videoFeedState) {
      case VideoFeedState.pip:
        return <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                BlocProvider.of<NFPlayerBloc>(context).cancelVideo();
              },
            ),
          ),
        ];
      case VideoFeedState.description:
        return <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                BlocProvider.of<NFPlayerBloc>(context).vfState.value =
                    VideoFeedState.pip;
              },
            ),
          ),
        ];
      case VideoFeedState.fullScreen:
        return [];
    }
  }

  List<Widget> _bottomAction(
      BuildContext context, VideoFeedState videoFeedState) {
    switch (videoFeedState) {
      case VideoFeedState.pip:
        return [];
      case VideoFeedState.description:
      case VideoFeedState.fullScreen:
        return <Widget>[
          CurrentPosition(),
          ProgressBar(
            colors: ProgressBarColors(
              backgroundColor: Theme.of(context).backgroundColor,
              playedColor: Theme.of(context).primaryColor,
              bufferedColor: Theme.of(context).hintColor,
            ),
            isExpanded: true,
          ),
          RemainingDuration(),
          IconButton(
            icon: Icon(
              BlocProvider.of<NFPlayerBloc>(context).vfState.value ==
                      VideoFeedState.fullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<NFPlayerBloc>(context)
                  .playerController
                  ?.toggleFullScreenMode();
              if (BlocProvider.of<NFPlayerBloc>(context).vfState.value ==
                  VideoFeedState.fullScreen) {
                BlocProvider.of<NFPlayerBloc>(context).vfState.value =
                    VideoFeedState.description;
              } else {
                BlocProvider.of<NFPlayerBloc>(context).vfState.value =
                    VideoFeedState.fullScreen;
              }
            },
          )
        ];
    }
  }
}
