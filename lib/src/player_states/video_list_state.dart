import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_components/index.dart';
import 'package:flutter_youtube_poc/src/player_components/title_tile.dart';
import 'package:flutter_youtube_poc/src/player_states/index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListState extends StatefulWidget implements NFPlayerState {
  final UniqueKey key = UniqueKey();
  final int autoPlayIndex;
  final int initialScrollIndex;

  VideoListState({this.autoPlayIndex, this.initialScrollIndex = 0});

  @override
  _VideoListStateState createState() => _VideoListStateState();

  @override
  List<Object> get props => [key];

  @override
  bool get stringify => false;
}

class _VideoListStateState extends State<VideoListState> {
  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  List<Video> videoList;

  int _autoPlayIndex;

  YoutubePlayerController controller;
  bool isMute = true;
  Video video;

  @override
  void initState() {
    _autoPlayIndex = widget.autoPlayIndex ?? 0;

    videoList = BlocProvider.of<NFPlayerBloc>(context).playlist;
    video = BlocProvider.of<NFPlayerBloc>(context).playlist[_autoPlayIndex];
    controller = YoutubePlayerController(
      initialVideoId: video.id,
      flags: YoutubePlayerFlags(autoPlay: true, mute: isMute, loop: true),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        key: ObjectKey(controller ?? "KEY"),
        onExitFullScreen: () {
          BlocProvider.of<NFPlayerBloc>(context).isFullScreen.value = false;
        },
        onEnterFullScreen: () {
          BlocProvider.of<NFPlayerBloc>(context).isFullScreen.value = true;
        },
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
                      .loadPIP(_autoPlayIndex);
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
            FullScreenButton(
              controller: controller,
            ),
          ],
        ),
        builder: (context, player) => ScrollablePositionedList.builder(
            itemPositionsListener: itemPositionsListener,
            itemScrollController: itemScrollController,
            itemCount: videoList.length,
            initialScrollIndex: widget.initialScrollIndex,
            itemBuilder: (context, index) {
              if (index == _autoPlayIndex) {
                return playableTile(context, player);
              }

              return VideoCard(
                index,
              );
            }));
  }

  Widget playableTile(BuildContext context, Widget player) {
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
                              .add(PlayVideo(_autoPlayIndex));
                        }
                      : null,
                )
              ],
            )));
  }
}
