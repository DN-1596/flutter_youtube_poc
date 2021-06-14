import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_poc/src/player_homepage.dart';
import 'package:flutter_youtube_poc/src/services/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.lightGreen,
    ),
  );
  runApp(YoutubePlayerDemoApp());
}

/// Creates [YoutubePlayerDemoApp] widget.
class YoutubePlayerDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Player POC',
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Colors.green,
        hintColor: Colors.green.shade100,
        textTheme: TextTheme(
          headline3: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline4: TextStyle(
            color: Colors.green.shade300,
            fontSize: 12.0,
          ),
          bodyText1: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 12.0,
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.green,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
            bodyText1: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.lightGreen,
        ),
      ),
      home: NFBuildPlayer(playlistJson: kPlaylistJson),
    );
  }
}
