import 'package:flutter/material.dart';
import '../constants.dart';

class LoginField extends StatelessWidget {
  LoginField({
    @required this.controller,
    @required this.isValid,
    @required this.isPopulated,
    @required this.isObscure,
    @required this.iconWhite,
    @required this.iconOrange,
    @required this.label,
  });

  final TextEditingController controller;
  final bool isValid;
  final bool isPopulated;
  final bool isObscure;
  final String iconWhite;
  final String iconOrange;
  final String label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //! retirar

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: TextFormField(
        style: TextStyle(
          color: isPopulated ? mainColor : Colors.white,
          fontFamily: 'Clobber',
          fontSize: 18,
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
            height: 30,
            width: 50,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Image(
                image: AssetImage(isPopulated ? iconOrange : iconWhite),
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
