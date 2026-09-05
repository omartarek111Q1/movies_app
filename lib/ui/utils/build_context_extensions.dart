import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext{

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  // ThemeCubit get selectTheme => BlocProvider.of<ThemeCubit>(this);


}