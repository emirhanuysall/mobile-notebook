import 'package:firebase_crud/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/images.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  // final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage(
                  KImages.devCallLogo,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    userField,
                    // passwordField,
                    customButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get userField {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 200.0),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan boş olamaz.';
              }
              return null;
            },
            style: const TextStyle(color: KColors.primaryColor),
            controller: _userIdController,
            enabled: true,
            decoration: const InputDecoration(
              labelText: "Kullanıcı ID",
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: KColors.primaryColor),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: KColors.primaryColor, width: 1.5)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: KColors.primaryColor, width: 1.5)),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: KColors.primaryColor, width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: KColors.primaryColor, width: 1.5)),
              errorText: null,
              errorStyle:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // Widget get passwordField {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 10.0),
  //     child: TextFormField(
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Bu alan boş olamaz.';
  //         }
  //         return null;
  //       },
  //       style: const TextStyle(color: KColors.primaryColor),
  //       controller: _passwordController,
  //       enabled: true,
  //       decoration: const InputDecoration(
  //         labelText: "Şifre",
  //         labelStyle: TextStyle(
  //             fontWeight: FontWeight.bold, color: KColors.primaryColor),
  //         enabledBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: KColors.primaryColor, width: 1.5)),
  //         focusedBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: KColors.primaryColor, width: 1.5)),
  //         focusedErrorBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: KColors.primaryColor, width: 1.5)),
  //         errorBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: KColors.primaryColor, width: 1.5)),
  //         errorText: null,
  //         errorStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //   );
  // }

  Widget customButton(context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 100,
        left: 100,
        bottom: 130.0,
      ),
      child: CustomButton(
        text: "GİRİŞ YAP",
        onPressed: () async {
          if (_userIdController.text.isNotEmpty) {
            DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(_userIdController.text)
                .get();

            if (userSnapshot.exists) {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed(
                "/posts",
                arguments: _userIdController.text,
              );
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Kullanıcı bulunamadı.',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Lütfen geçerli bir Kullanıcı ID girin, bu alan boş olamaz.',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }
}
