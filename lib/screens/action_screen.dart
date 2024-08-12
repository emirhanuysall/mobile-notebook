import 'package:flutter/material.dart';
import 'package:firebase_crud/services/firebase_service.dart';
import 'package:firebase_crud/utils/colors.dart';
import 'package:firebase_crud/widgets/appbar_widget.dart';
import 'package:firebase_crud/widgets/custom_button.dart';

enum ActionType { insert, update }

class ActionScreen extends StatelessWidget {
  ActionScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  Widget titleWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: KColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget inputWidget({
    TextEditingController? controller,
    FocusNode? focusNode,
    bool multiLine = false,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: KColors.primaryColor, width: 1.5),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş olamaz.';
          }
          return null;
        },
        style: const TextStyle(color: KColors.primaryColor),
        controller: controller,
        focusNode: focusNode,
        maxLines: multiLine ? 7 : 1,
        decoration: InputDecoration(
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: KColors.primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: KColors.primaryColor, width: 1.5),
          ),
          errorText: null,
          errorStyle:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _getPostData(String title, String description) {
    _titleController.text = title;
    _descriptionController.text = description;
  }

  @override
  Widget build(BuildContext context) {
    final (userId, actionType, id, title, description) = ModalRoute.of(context)!
        .settings
        .arguments as (String, ActionType, String?, String?, String?);

    if (actionType == ActionType.update) {
      _getPostData(title!, description!);
    }

    return Scaffold(
      appBar: const MyAppBar(),
      body: GestureDetector(
        onTap: () {
          _titleFocusNode.unfocus();
          _descriptionFocusNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  titleWidget("Başlık"),
                  inputWidget(
                      controller: _titleController, focusNode: _titleFocusNode),
                  titleWidget("Açıklama"),
                  inputWidget(
                      controller: _descriptionController,
                      focusNode: _descriptionFocusNode,
                      multiLine: true),
                  CustomButton(
                    text: actionType == ActionType.insert
                        ? "MESAJ EKLE"
                        : "GÜNCELLE",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (actionType == ActionType.insert) {
                          FirebaseService().insertPost(
                            userId: userId,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            post: {
                              "title": title,
                              "description": description,
                              "id": id
                            },
                          ).then((value) => Navigator.of(context).pop());
                        } else {
                          FirebaseService().updatePost(
                            userId: userId,
                            id: id!,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            post: {
                              "title": title,
                              "description": description,
                              "id": id
                            },
                          ).then((value) => Navigator.of(context).pop());
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Alanlar boş olamaz, lütfen alanları doldurunuz.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    throttleDuration: const Duration(seconds: 4),
                  ),
                  if (actionType == ActionType.update) ...[
                    const SizedBox(height: 15),
                    CustomButton(
                      text: "SİL",
                      onPressed: () async {
                        bool confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Emin misiniz?"),
                              content: const Text(
                                  "Silmek istediğinize emin misiniz?"),
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
                                  child: const Text("Sil"),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          FirebaseService().removePost(
                            userId: userId,
                            post: {
                              "title": title,
                              "description": description,
                              "id": id
                            },
                          ).then((value) => Navigator.of(context).pop());
                        }
                      },
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
