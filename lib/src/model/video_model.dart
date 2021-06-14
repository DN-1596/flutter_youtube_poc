class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;
  final String description;
  final String likeCount;
  final String viewCount;
  // dislike, share count

  Video(
      {this.id,
      this.title,
      this.thumbnailUrl,
      this.channelTitle,
      this.description,
      this.likeCount,
      this.viewCount});

  factory Video.fromMap(Map<String, dynamic> data) {
    return Video(
      id: data["id"],
      title: data["snippet"]['title'],
      thumbnailUrl: data["snippet"]['thumbnails']['high']['url'],
      channelTitle: data["snippet"]['channelTitle'],
      description: data["snippet"]["description"],
      likeCount: data["statistics"]["likeCount"],
      viewCount: data["statistics"]["viewCount"],
    );
  }
}
