import 'package:flutter/material.dart';
import 'package:movies_app/ui/utils/colors/app_colors.dart';

import '../utils/build_context_extensions.dart';

class CustomBtn extends StatefulWidget {
  final Color inColor;
  final Color borderColor;
  final String title;
  final Color titleColor;
  final bool withLoading;
  final void Function()? onTap;
  const CustomBtn( {super.key, required this.inColor, required this.title, required this.titleColor,  this.withLoading = true,required this.onTap, required this.borderColor});

  @override
  State<CustomBtn> createState() => _CustomBtnState();
}

class _CustomBtnState extends State<CustomBtn> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: _isLoading? null : ()async{
        if (!widget.withLoading) {
          widget.onTap!();
          return;
        }

        setState(() {
          _isLoading = true;
        });
        await Future.delayed(Duration(seconds: 2));

        widget.onTap!();

        if(mounted){ setState(() {
          _isLoading = false;
        });}
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width:_isLoading? context.width * .6: context.width * .9,
        padding: EdgeInsets.symmetric( vertical: 17),
        decoration: BoxDecoration(
          border: BoxBorder.all(color: widget.borderColor),
          color: widget.inColor,
          borderRadius: BorderRadius.circular(15),

        ),
        // color: AppColors.yellow,
        child:_isLoading? Center(child: CircularProgressIndicator( color: Colors.white,)):
        Center(child: Text(widget.title , style: TextStyle(color: widget.titleColor, fontSize: 18 ,fontWeight: FontWeight.bold ) , textAlign: TextAlign.center,)),

      ),
    );
  }
}


