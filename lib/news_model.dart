class Post {
  final String? id, name, author, title, description, url, image, publishedAt;

  Post(
      {this.id,
      this.name,
      this.author,
      this.title,
      this.description,
      this.url,
      this.image,
      this.publishedAt});

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
        id: json['source']['id'] ?? '',
        name: json['source']['name'] ?? '',
        author: json['author'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        url: json['url'] ?? '',
        image: json['urlToImage'] ?? '',
        publishedAt: (json['publishedAt'] ?? '')
            .toString()
            .replaceAll("T", " ")
            .replaceAll("Z", ""));
  }
}
