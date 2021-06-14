import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_poc/src/player_states/player_states.dart';

class LoadingState extends StatelessWidget implements NFPlayerState {
  final UniqueKey key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 30,
        ),
      ),
    );
  }

  @override
  List<Object> get props => [key];

  @override
  bool get stringify => false;
}
