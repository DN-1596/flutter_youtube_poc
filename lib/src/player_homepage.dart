import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/player_bloc/player_bloc.dart';
import 'package:flutter_youtube_poc/src/player_components/index.dart';
import 'package:flutter_youtube_poc/src/player_states/player_states.dart';
import 'package:flutter_youtube_poc/src/services/constants.dart';

class NFBuildPlayer extends StatefulWidget {
  final List<dynamic> playlistJson;
  final int initialVideoIndex;

  NFBuildPlayer({@required this.playlistJson, this.initialVideoIndex});

  @override
  _NFBuildPlayerState createState() => _NFBuildPlayerState();
}

class _NFBuildPlayerState extends State<NFBuildPlayer> {
  @override
  void initState() {
    kPlayerKey = GlobalKey(debugLabel: "Player Key");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => NFPlayerBloc(
          playlistJson: widget.playlistJson,
          initialVideoIndex: 0,
          isInitialPIP: true),
      child: Builder(builder: (context) {
        return SafeArea(child: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                BlocBuilder<NFPlayerBloc, NFPlayerState>(
                    builder: (context, state) => state as Widget),
                VideoFeed(constraints),
              ],
            );
          }),
        ));
      }),
    );
  }
}
