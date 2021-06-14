import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoCard extends StatefulWidget {
  final int videoIndex;
  final bool playable;

  VideoCard(this.videoIndex, {this.playable = false});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  YoutubePlayerController controller;
  bool isMute = true;
  Video video;

  @override
  void initState() {
    video = BlocProvider.of<NFPlayerBloc>(context).playlist[widget.videoIndex];
    controller = (widget.playable)
        ? YoutubePlayerController(
            initialVideoId: video.id,
            flags: YoutubePlayerFlags(autoPlay: true, mute: isMute, loop: true),
          )
        : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(3.0, 3.0),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ]),
        child: (widget.playable)
            ? playable(context, video: video)
            : nonPlayable(context, video: video),
      ),
    );
  }

  Widget nonPlayable(BuildContext context, {Video video}) {
    return GestureDetector(
      onTap: (video != null)
          ? () {
              BlocProvider.of<NFPlayerBloc>(context)
                  .add(PlayVideo(widget.videoIndex));
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [thumbNail(context, video), titleTile(context, video: video)],
      ),
    );
  }

  Widget playable(BuildContext context, {Video video}) {
    return YoutubePlayerBuilder(
        key: ObjectKey(controller),
        player: YoutubePlayer(
          aspectRatio: 16 / 9,
          controller: controller,
          actionsPadding: const EdgeInsets.all(8.0),
          topActions: <Widget>[
            Flexible(flex: 90, fit: FlexFit.tight, child: SizedBox()),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: IconButton(
                icon: const Icon(
                  Icons.picture_in_picture_alt,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  controller.pause();
                  BlocProvider.of<NFPlayerBloc>(context)
                      .loadPIP(widget.videoIndex);
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
            IconButton(
                icon: (isMute)
                    ? Icon(Icons.volume_off_sharp)
                    : Icon(Icons.volume_up_sharp),
                onPressed: () async {
                  (isMute && controller.value.isPlaying)
                      ? controller.unMute()
                      : controller.mute();

                  setState(() {
                    isMute = !isMute;
                  });
                }),
            IconButton(
                icon: Icon(Icons.fullscreen),
                onPressed: () async {
                  BlocProvider.of<NFPlayerBloc>(context)
                      .add(GetFullScreenVideoPlayer(widget.videoIndex));
                })
          ],
        ),
        builder: (context, player) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  player,
                  titleTile(
                    context,
                    video: video,
                    callback: (video != null)
                        ? () {
                            controller.pause();
                            BlocProvider.of<NFPlayerBloc>(context)
                                .add(PlayVideo(widget.videoIndex));
                          }
                        : null,
                  )
                ],
              ),
            ));
  }

  Widget thumbNail(BuildContext context, Video video) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: video == null
            ? null
            : BoxDecoration(
                color: Colors.grey,
                image: video.thumbnailUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(
                          video.thumbnailUrl ?? "",
                        ),
                        onError: (e, stacktrace) {
                          log("ERROR LOADING IMAGE!! $e");
                        },
                        fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget text(String text, TextStyle textStyle) {
    return Text(
      text ?? "",
      softWrap: true,
      style: textStyle,
    );
  }

  Widget titleTile(BuildContext context, {Video video, VoidCallback callback}) {
    String title = "";
    String channelTitle = "";

    if (video != null) {
      title = video.title;
      channelTitle = video.channelTitle;
    }

    return ListTile(
      onTap: callback,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).hintColor,
        child: (video != null)
            ? Icon(
                Icons.person_rounded,
                color: Theme.of(context).primaryColor,
              )
            : CupertinoActivityIndicator(),
      ),
      title: text(title, Theme.of(context).textTheme.headline3),
      subtitle: text(channelTitle, Theme.of(context).textTheme.headline4),
    );
  }
}
