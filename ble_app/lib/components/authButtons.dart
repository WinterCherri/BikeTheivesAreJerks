import 'package:flutter/material.dart';

class AuthButtons extends StatelessWidget {
  final Function()? onTap;
  final String displayText;

  const AuthButtons({
    super.key,
    required this.displayText, 
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(color:Colors.black, borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      )
    );
  }
}