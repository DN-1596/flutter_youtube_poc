import 'dart:developer';

import 'package:flutter_youtube_poc/src/model/video_model.dart';

class PlayerUtils {
  static List<Video> getPlaylist(List<dynamic> playlistJson) {
    List<Video> playlist = new List();

    playlistJson?.forEach((element) {
      try {
        playlist.add(Video.fromMap(element));
      } catch (e) {
        log("ERROR!! in converting video from map $e");
      }
    });
    return playlist;
  }
}
