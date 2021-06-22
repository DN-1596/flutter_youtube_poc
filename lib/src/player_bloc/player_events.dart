import 'package:equatable/equatable.dart';

abstract class NFPlayerEvent extends Equatable {}

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
