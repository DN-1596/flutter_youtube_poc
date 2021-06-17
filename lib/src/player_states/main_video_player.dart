import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_bloc/player_bloc.dart';
import 'package:flutter_youtube_poc/src/player_states/index.dart';
import 'package:flutter_youtube_poc/src/services/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MainVideoPlayerState extends StatefulWidget implements NFPlayerState {
  final int videoIndex;

  MainVideoPlayerState(this.videoIndex) : super(key: ObjectKey(videoIndex));

  @override
  _MainVideoPlayerStateState createState() => _MainVideoPlayerStateState();

  @override
  List<Object> get props => [videoIndex];

  @override
  bool get stringify => false;
}

class _MainVideoPlayerStateState extends State<MainVideoPlayerState> {
  YoutubePlayerController controller;
  Video video;

  @override
  void initState() {
    controller = BlocProvider.of<NFPlayerBloc>(context).playerController;
    video = BlocProvider.of<NFPlayerBloc>(context).playlist[widget.videoIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        key: kGlobalObjectKey,
        onExitFullScreen: () {
          BlocProvider.of<NFPlayerBloc>(context).isFullScreen.value = false;
          this.setState(() {});
        },
        onEnterFullScreen: () {
          BlocProvider.of<NFPlayerBloc>(context).isFullScreen.value = true;
          this.setState(() {});
        },
        player: YoutubePlayer(
          aspectRatio: 16 / 9,
          controller: controller,
          actionsPadding: const EdgeInsets.all(8.0),
          onEnded: (m) {
            controller.seekTo(Duration());
            BlocProvider.of<NFPlayerBloc>(context)
                .getNextVideoForPlayer(widget.videoIndex);
          },
          topActions: (controller.value.isFullScreen)
              ? null
              : <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        BlocProvider.of<NFPlayerBloc>(context)
                            .loadPIP(widget.videoIndex);
                        BlocProvider.of<NFPlayerBloc>(context).add(GetVideoList(
                            initialScrollIndex: widget.videoIndex));
                      },
                    ),
                  ),
                ],
          bottomActions: [
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
            FullScreenButton(
              controller: controller,
            ),
/*            IconButton(
                icon: Icon(Icons.fullscreen),
                onPressed: () async {
                  BlocProvider.of<NFPlayerBloc>(context)
                      .add(GetFullScreenVideoPlayer(widget.videoIndex));
                })*/
          ],
        ),
        builder: (context, player) => ListView(
              shrinkWrap: true,
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: text(
                        video.title, Theme.of(context).textTheme.headline3),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            statistics(
                                Icon(Icons.thumb_up_rounded), video.likeCount),
                            statistics(
                                Icon(Icons.remove_red_eye), video.viewCount),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).hintColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).hintColor,
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: text(video.channelTitle,
                                    Theme.of(context).textTheme.headline3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      _space,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24.0),
                        child: _text('Description \n\n', video.description),
                      ),
                      _space,
                    ],
                  ),
                ),
              ],
            ));
  }

  Widget statistics(Icon icon, String info) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: icon,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: text(info, Theme.of(context).textTheme.headline4),
        )
      ],
    );
  }

  Widget text(String text, TextStyle textStyle) {
    return Text(
      text ?? "",
      softWrap: true,
      style: textStyle,
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title',
        style: Theme.of(context).textTheme.headline4,
        children: [
          TextSpan(text: value, style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
