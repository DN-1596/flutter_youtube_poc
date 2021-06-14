import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/player_bloc/player_bloc.dart';
import 'package:flutter_youtube_poc/src/player_components/index.dart';
import 'package:flutter_youtube_poc/src/player_states/player_states.dart';

class NFBuildPlayer extends StatelessWidget {
  final List<dynamic> playlistJson;
  final int initialVideoIndex;

  NFBuildPlayer({@required this.playlistJson, this.initialVideoIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NFPlayerBloc(
          playlistJson: playlistJson, initialVideoIndex: initialVideoIndex),
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            body: BlocBuilder<NFPlayerBloc, NFPlayerState>(
                builder: (context, state) => state as Widget),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: PIPPlayer(),
          ),
        );
      }),
    );
  }
}
