import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/services/models/post_model.dart';

class FirebaseService {
  final usersCol = FirebaseFirestore.instance.collection("users");

  Future<Posts> getUserPosts(String userId) async {
    final userDoc =
        await usersCol.doc(userId).get().then((value) => value.data());
    final postsModel = Posts.fromJson(userDoc);
    return postsModel;
  }

  Stream<Posts> getUserPostsAsStream(String userId) {
    final userSnapshot = usersCol
        .doc(userId)
        .snapshots()
        .map((event) => Posts.fromJson(event.data()!));

    return userSnapshot;
  }

  Future<void> insertPost(
      {required String userId,
      required String title,
      required String description,
      required Map<String, String?> post}) async {
    await usersCol.doc(userId).update({
      "posts": FieldValue.arrayUnion([
        {
          "title": title,
          "description": description,
          "id": Random().nextInt(500).toString()
        }
      ])
    });
  }

  Future<void> updatePost(
      {required String userId,
      required String id,
      required String title,
      required String description,
      required Map post}) async {
    await removePost(userId: userId, post: post);

    await usersCol.doc(userId).update({
      "posts": FieldValue.arrayUnion([
        {"title": title, "description": description, "id": id}
      ])
    });
  }

  Future<void> removePost({required String userId, required Map post}) async {
    await usersCol.doc(userId).update({
      "posts": FieldValue.arrayRemove([post])
    });
  }
}
