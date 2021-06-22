import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';
import 'package:flutter_youtube_poc/src/player_bloc/index.dart';
import 'package:flutter_youtube_poc/src/services/constants.dart';

class VideoFeed extends StatefulWidget {
  final BoxConstraints constraints;

  VideoFeed(this.constraints);

  @override
  _VideoFeedState createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> with WidgetsBindingObserver {
  double maxHeight;
  double maxWidth;
  @override
  void initState() {
    maxHeight = widget.constraints.maxHeight;
    maxWidth = widget.constraints.maxWidth;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final physicalSize = SchedulerBinding.instance.window.physicalSize;
    final controller = BlocProvider.of<NFPlayerBloc>(context).playerController;
    if (physicalSize.width > physicalSize.height) {
      controller?.updateValue(controller?.value?.copyWith(isFullScreen: true));
      SystemChrome.setEnabledSystemUIOverlays([]);
    } else {
      controller?.updateValue(controller?.value?.copyWith(isFullScreen: false));
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final controller =
            BlocProvider.of<NFPlayerBloc>(context).playerController;
        if (controller?.value?.isFullScreen ?? false) {
          controller.toggleFullScreenMode();
          BlocProvider.of<NFPlayerBloc>(context).vfState.value =
              VideoFeedState.description;
          return false;
        }
        return true;
      },
      child: ValueListenableBuilder<int>(
          valueListenable: BlocProvider.of<NFPlayerBloc>(context).vfIndex,
          builder: (context, _videoIndex, _) {
            return ValueListenableBuilder<VideoFeedState>(
                valueListenable: BlocProvider.of<NFPlayerBloc>(context).vfState,
                builder: (context, _vfState, _) {
                  double _height;
                  double _width = maxWidth;
                  Widget child;
                  double bottom = 0, left = 0;

                  if (_vfState == null || _videoIndex == null) {
                    _height = 0;
                    _width = maxWidth;
                  } else {
                    switch (_vfState) {
                      case VideoFeedState.pip:
                        _height = _width * (9 / 16);
                        _width = maxWidth * (0.80);
                        child = BlocProvider.of<NFPlayerBloc>(context)
                            .nfYoutubePlayer;
                        left = (maxWidth - _width) / 2;
                        bottom = 10;
                        break;
                      case VideoFeedState.description:
                        _height = maxHeight;
                        _width = maxWidth;
                        child = _descriptionState(_videoIndex);
                        break;
                      case VideoFeedState.fullScreen:
                        _height = maxWidth;
                        _width = maxHeight;
                        child = BlocProvider.of<NFPlayerBloc>(context)
                            .nfYoutubePlayer;
                        break;
                    }
                  }

                  return AnimatedPositioned(
                    bottom: bottom,
                    left: left,
                    height: _height,
                    duration: kAnimationDuration,
                    child: AnimatedContainer(
                      decoration: BoxDecoration(color: Colors.white),
                      height: _height,
                      width: _width,
                      duration: kAnimationDuration,
                      child: child,
                    ),
                  );
                });
          }),
    );
  }

  /// Description State

  Widget _descriptionState(int index) {
    Video video = BlocProvider.of<NFPlayerBloc>(context).playlist[index];

    return ListView(
      shrinkWrap: true,
      children: [
        BlocProvider.of<NFPlayerBloc>(context).nfYoutubePlayer,
      ],
    );
  }
}
