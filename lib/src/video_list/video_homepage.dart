// import 'package:flutter/material.dart';
// import 'package:flutter_youtube_poc/services/constants.dart';
// import 'package:flutter_youtube_poc/src/video_list/player/pip_player.dart';
// import 'package:flutter_youtube_poc/src/video_list/video_list.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   ValueNotifier<PIPVideo> pipVideo = ValueNotifier(null);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Product Videos",
//           style: Theme.of(context).appBarTheme.textTheme.headline6,
//         ),
//       ),
//       body: VideoList(
//         videoIds,
//         pipVideo: pipVideo,
//       ),
//       floatingActionButton: ValueListenableBuilder<PIPVideo>(
//           valueListenable: pipVideo,
//           builder: (context, value, child) {
//             return value == null
//                 ? SizedBox.fromSize(
//                     size: Size.zero,
//                   )
//                 : PIPPlayer(pipVideo);
//           }),
//     );
//   }
// }
