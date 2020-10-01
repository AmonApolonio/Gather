import 'package:flutter/material.dart';

import '../constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.controller,
    this.label,
    this.isPopulated,
    this.icon,
    this.iconSize,
  });

  final TextEditingController controller;
  final bool isPopulated;
  final IconData icon;
  final String label;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height * 0.02),
      child: TextField(
        style: TextStyle(
          color: isPopulated ? mainColor : Colors.white,
          fontFamily: 'Clobber',
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Container(
            height: 30,
            width: 50,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(
                icon,
                size: iconSize,
                color: isPopulated ? mainColor : Colors.white,
              ),
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: isPopulated ? mainColor : Colors.white,
            fontFamily: 'Clobber',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: isPopulated ? mainColor : Colors.white,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: isPopulated ? mainColor : Colors.white,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
