import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_event.dart';
import 'package:gather_app/bloc/signup/bloc.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/widgets/facebook_login.dart';
import 'package:gather_app/ui/widgets/login_field.dart';
import 'package:gather_app/ui/widgets/social_login.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpBloc _signUpBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(SignUpState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);

    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onFormSubmitted() {
    _signUpBloc.add(
      SignUpWithCredentialsPressed(
          email: emailController.text, password: passwordController.text),
    );
  }

  void _onLoginWithGoogle() {
    _signUpBloc.add(
      SignUpWithGoogle(),
    );
  }

  void _onLoginWithFacebook(result) {
    _signUpBloc.add(
      SignUpWithFacebook(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        //*
        //* ON FAILURE STATE
        //*
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: secondBackgroundColor,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sign Up Failed",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Clobber',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.error,
                    color: mainColor,
                  ),
                ],
              ),
            ));

          //*
          //* ON SUBMITTING STATE
          //*
        }
        if (state.isSubmitting) {
          print("isSubmitting");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: secondBackgroundColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Signing up...",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                  ],
                ),
              ),
            );
        }
        //*
        //* ON SUCCESS STATE
        //*
        if (state.isSuccess) {
          print("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          //*
          //* SIGN UP FORM
          //*
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //*
              //* EMAIL FIELD
              //*
              LoginField(
                controller: emailController,
                isValid: state.isEmailValid,
                isPopulated: emailController.text.isNotEmpty,
                isObscure: false,
                icon: GatherCustomIcons.user,
                label: "Email",
              ),
              //*
              //* PASSWORD FIELD
              //*
              LoginField(
                controller: passwordController,
                isValid: state.isPasswordValid,
                isPopulated: passwordController.text.isNotEmpty,
                isObscure: true,
                icon: GatherCustomIcons.password,
                label: "Password",
              ),
              //*
              //* SIGN UP BUTTON
              //*
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                child: GestureDetector(
                  onTap: isSignUpButtonEnabled(state) ? _onFormSubmitted : null,
                  child: Container(
                    width: size.width * 0.5,
                    height: size.width * 0.18,
                    decoration: BoxDecoration(
                      color: isSignUpButtonEnabled(state)
                          ? mainColor
                          : secondBackgroundColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Clobber',
                          fontSize: size.width * 0.047,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //*
              //* LOGIN VIA SOCIAL NETWORKS BUTTONS
              //*
              SocialLogin(
                size: size,
                onLoginWithFacebook: () async {
                  String clientId = "1046324492454358";
                  String rediredUrl =
                      "https://www.facebook.com/connect/login_success.html";

                  print("Loging in with Facebook");

                  String result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomWebView(
                        selectedUrl:
                            'https://www.facebook.com/dialog/oauth?client_id=$clientId&redirect_uri=$rediredUrl&response_type=token&scope=email,public_profile,',
                      ),
                      maintainState: true,
                    ),
                  );

                  print("RESPOSTA: $result");

                  _onLoginWithFacebook(result);
                },
                onLoginWithGoogle: () {
                  print("Loging in with Google...");
                  _onLoginWithGoogle();
                },
              ),
              //*
              //* GO TO LOGIN SCREEN BUTTON
              //*
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.07),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login here',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onEmailChanged() {
    _signUpBloc.add(
      EmailChanged(email: emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc.add(
      PasswordChanged(password: passwordController.text),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
