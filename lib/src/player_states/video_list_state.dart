import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/player_components/index.dart';
import 'package:flutter_youtube_poc/src/player_states/index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class VideoListState extends StatefulWidget implements NFPlayerState {
  final UniqueKey key = UniqueKey();
  final int autoPlayIndex;
  final int initialScrollIndex;

  VideoListState({this.autoPlayIndex = -1, this.initialScrollIndex = 0});

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

  @override
  void initState() {
    videoList = BlocProvider.of<NFPlayerBloc>(context).playlist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
        itemPositionsListener: itemPositionsListener,
        itemScrollController: itemScrollController,
        itemCount: videoList.length,
        initialScrollIndex: widget.initialScrollIndex,
        itemBuilder: (context, index) {
          return VideoCard(
            index,
            playable: (index == widget.autoPlayIndex),
          );
        });
  }
}
