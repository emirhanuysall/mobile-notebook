import 'package:firebase_crud/screens/action_screen.dart';
import 'package:firebase_crud/services/firebase_service.dart';
import 'package:firebase_crud/services/models/post_model.dart';
import 'package:firebase_crud/utils/colors.dart';
import 'package:firebase_crud/widgets/appbar_widget.dart';
import 'package:firebase_crud/widgets/post_item.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: MyAppBar(
        logoutCallback: () async {
          bool confirmLogout = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Emin misiniz?"),
                content: const Text("Çıkış yapacaksınız. Emin misiniz?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("İptal"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Çıkış yap"),
                  ),
                ],
              );
            },
          );

          if (confirmLogout == true) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/action",
            arguments: (userId, ActionType.insert, null, null, null)),
        backgroundColor: KColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: KColors.secondaryColor,
          size: 30,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: StreamBuilder<Posts>(
            stream: FirebaseService().getUserPostsAsStream(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.posts.isEmpty) {
                return const Center(
                  child: Text("Bu kullanıcının henüz bir notu yok.",
                      style:
                          TextStyle(fontSize: 18, color: KColors.primaryColor)),
                );
              }

              final Posts posts = snapshot.data!;

              return Column(
                children: List.generate(posts.posts.length, (index) {
                  final Post post = posts.posts[index];
                  return PostItem(
                    id: post.id,
                    userId: userId,
                    title: post.title,
                    description: post.description,
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
