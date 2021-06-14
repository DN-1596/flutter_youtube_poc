import 'package:equatable/equatable.dart';

abstract class NFPlayerEvent extends Equatable {}

class PlayVideo implements NFPlayerEvent {
  final int index;

  PlayVideo(this.index);

  @override
  List<Object> get props => [index];

  @override
  bool get stringify => false;
}

class InitiatePlayer implements NFPlayerEvent {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => false;
}

class GetVideoList implements NFPlayerEvent {
  final int initialScrollIndex;

  GetVideoList({this.initialScrollIndex = 0});

  @override
  List<Object> get props => [initialScrollIndex];

  @override
  bool get stringify => false;
}

class GetFullScreenVideoPlayer implements NFPlayerEvent {
  final int index;

  GetFullScreenVideoPlayer(this.index);

  @override
  List<Object> get props => [index];

  @override
  bool get stringify => false;
}
