import 'package:flutter/material.dart';

import '../../../../../core/utils/colors/app_colors.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: AppColors.yellow,
            size: 30,
          ),
        ),
        backgroundColor: AppColors.black,
        title: Text(
          "Forget Password",
          style: TextStyle(
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
