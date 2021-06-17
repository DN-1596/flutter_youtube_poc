import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_poc/src/model/video_model.dart';

Widget titleTile(BuildContext context, {Video video, VoidCallback callback}) {
  String title = "";
  String channelTitle = "";

  if (video != null) {
    title = video.title;
    channelTitle = video.channelTitle;
  }

  return ListTile(
    onTap: callback,
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).hintColor,
      child: (video != null)
          ? Icon(
              Icons.person_rounded,
              color: Theme.of(context).primaryColor,
            )
          : CupertinoActivityIndicator(),
    ),
    title: text(title, Theme.of(context).textTheme.headline3),
    subtitle: text(channelTitle, Theme.of(context).textTheme.headline4),
  );
}

Widget text(String text, TextStyle textStyle) {
  return Text(
    text ?? "",
    softWrap: true,
    style: textStyle,
  );
}
