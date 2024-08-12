import 'package:firebase_crud/screens/action_screen.dart';
import 'package:firebase_crud/utils/colors.dart';
import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String id;
  final String userId;
  final String title;
  final String description;
  const PostItem(
      {super.key,
      required this.id,
      required this.userId,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed("/action",
            arguments: (userId, ActionType.update, id, title, description)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: KColors.primaryColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    color: KColors.secondaryColor,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                    fontSize: 15, color: KColors.secondaryColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
