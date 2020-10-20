import 'package:flutter/material.dart';
import '../constants.dart';

class LoginField extends StatelessWidget {
  LoginField({
    @required this.controller,
    @required this.isValid,
    @required this.isPopulated,
    @required this.isObscure,
    @required this.icon,
    @required this.label,
  });

  final TextEditingController controller;
  final bool isValid;
  final bool isPopulated;
  final bool isObscure;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //! retirar

    return Padding(
      padding: EdgeInsets.only(
        bottom: size.height * 0.02,
        left: size.height * 0.035,
        right: size.height * 0.035,
      ),
      child: TextFormField(
        style: TextStyle(
          color: isPopulated ? mainColor : Colors.white,
          fontFamily: 'Clobber',
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.w400,
        ),
        controller: controller,
        obscureText: isObscure,
        autovalidate: false,
        validator: (_) {
          return !isValid ? "Invalid Email" : null;
        },
        decoration: InputDecoration(
          prefixIcon: Container(
            height: size.width * 0.08,
            width: size.width * 0.14,
            margin: EdgeInsets.all(size.width * 0.014),
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.008),
              child: Icon(
                icon,
                color: isPopulated ? mainColor : Colors.white,
                size: size.width * 0.075,
              ),
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
            color: isPopulated ? mainColor : Colors.white,
            fontFamily: 'Clobber',
            fontSize: size.width * 0.045,
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
