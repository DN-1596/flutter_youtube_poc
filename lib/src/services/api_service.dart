import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

const String API_KEY = "AIzaSyBAZdNugRRE19OJQIAC1nSjxPMI5bE8voQ";
const String _baseUrl = 'www.googleapis.com';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  static Future<dynamic> fetchVideosFromId(String videoId) async {
    Map<String, String> parameters = {
      'part': 'snippet,statistics',
      'id': videoId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/videos',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      try {
        return response.body;
      } catch (e) {
        log("ERROR!! in video conversion - $e");
      }
    }

    return null;
  }
}
