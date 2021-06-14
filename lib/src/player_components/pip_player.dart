import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/player_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PIPPlayer extends StatefulWidget {
  @override
  _PIPPlayerState createState() => _PIPPlayerState();
}

class _PIPPlayerState extends State<PIPPlayer> {
  YoutubePlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Video>(
        valueListenable: BlocProvider.of<NFPlayerBloc>(context).pipVideo,
        builder: (context, video, child) {
          if (video == null) return SizedBox();

          controller = BlocProvider.of<NFPlayerBloc>(context).pipController;

          return YoutubePlayerBuilder(
              key: ObjectKey(controller),
              player: YoutubePlayer(
                controller: controller,
                aspectRatio: 16 / 9,
                actionsPadding: const EdgeInsets.all(8.0),
                progressColors: ProgressBarColors(
                    bufferedColor: Theme.of(context).hintColor,
                    playedColor: Theme.of(context).primaryColor,
                    handleColor: Colors.white),
                showVideoProgressIndicator: true,
                topActions: [],
                bottomActions: [],
                onEnded: (m) {
                  controller.seekTo(Duration());
                  controller.pause();
                },
              ),
              builder: (context, player) => Container(
                    color: Colors.white,
                    height: 85,
                    child: Row(
                      children: [
                        Flexible(flex: 35, fit: FlexFit.tight, child: player),
                        Flexible(
                          flex: 55,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text(video.title,
                                    Theme.of(context).textTheme.bodyText1),
                                text(video.channelTitle,
                                    Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                          fit: FlexFit.tight,
                          child: IconButton(
                              icon: Icon(Icons.cancel_outlined),
                              onPressed: () {
                                controller.pause();
                                BlocProvider.of<NFPlayerBloc>(context)
                                    .cancelPIP();
                              }),
                        ),
                      ],
                    ),
                  ));
        });
  }

  Widget text(String text, TextStyle textStyle) {
    return Text(
      text ?? "",
      softWrap: true,
      style: textStyle,
    );
  }
}
