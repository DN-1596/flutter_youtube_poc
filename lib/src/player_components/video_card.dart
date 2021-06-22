import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_components/title_tile.dart';

class VideoCard extends StatefulWidget {
  final int videoIndex;

  VideoCard(this.videoIndex);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Video video;

  @override
  void initState() {
    video = BlocProvider.of<NFPlayerBloc>(context).playlist[widget.videoIndex];

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
        child: nonPlayable(context, video: video),
      ),
    );
  }

  Widget nonPlayable(BuildContext context, {Video video}) {
    return GestureDetector(
      onTap: (video != null)
          ? () {
              BlocProvider.of<NFPlayerBloc>(context)
                  .loadVideo(widget.videoIndex);
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [thumbNail(context, video), titleTile(context, video: video)],
      ),
    );
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
}
