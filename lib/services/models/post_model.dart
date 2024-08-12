class Posts {
  final List<Post> posts;
  Posts({required this.posts});

  factory Posts.fromJson(Map<String, dynamic>? json) {
    List<Post> posts = [];

    if (json != null) {
      for (var i in json['posts']) {
        posts.add(Post.fromJson(i));
      }
    }

    return Posts(posts: posts);
  }
}

class Post {
  final String id, title, description;
  Post({required this.id, required this.title, required this.description});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'], title: json['title'], description: json['description']);
  }
}
