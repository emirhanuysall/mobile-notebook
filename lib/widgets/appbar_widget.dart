import 'package:flutter/material.dart';
import '../utils/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? logoutCallback;

  const MyAppBar({
    Key? key,
    this.logoutCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("devCall Notepad"),
      titleTextStyle: const TextStyle(
        color: KColors.secondaryColor,
        fontSize: 25,
      ),
      backgroundColor: KColors.primaryColor,
      elevation: 0,
      actions: <Widget>[
        if (logoutCallback != null)
          IconButton(
            icon: const Icon(Icons.logout, color: KColors.secondaryColor),
            onPressed: logoutCallback,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
