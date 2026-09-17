import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String prefixIcon;
  final String? suffixIcon;
  final String? hint;
  final bool isPassword;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    required this.prefixIcon,
    this.suffixIcon,
     this.hint,  this.isPassword = false,  this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _passwordValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordValue = widget.isPassword;
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _passwordValue,
      style: TextStyle(color: AppColors.white , fontWeight: FontWeight.w500),
      decoration: InputDecoration(

        hintText: widget.hint,
        hintStyle: TextStyle(color: AppColors.white , fontSize: 16 , fontWeight: FontWeight.w400 ),
        filled: true,
        fillColor: AppColors.gray,
        prefixIconColor: AppColors.white,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 10 ),
          child: ImageIcon(AssetImage(widget.prefixIcon)),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () {
            setState(() {
              _passwordValue = !_passwordValue;
            });
          },
          icon: Icon(
            _passwordValue ? Icons.visibility_off : Icons.visibility,
            color: AppColors.white,
          ),
        )
            : null,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: BorderSide(color:Colors.transparent) ),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16) ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: BorderSide(color: AppColors.white) ),
      ),
    );
  }
}
