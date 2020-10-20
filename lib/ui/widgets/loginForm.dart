import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gather_app/bloc/authentication/bloc.dart';
import 'package:gather_app/bloc/login/bloc.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/ui/pages/signUp.dart';
import 'package:gather_app/ui/widgets/facebook_login.dart';
import 'package:gather_app/ui/widgets/login_field.dart';
import 'package:gather_app/ui/widgets/social_login.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    emailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
    super.initState();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
          email: emailController.text, password: passwordController.text),
    );
  }

  void _onLoginWithGoogle() {
    _loginBloc.add(
      LoginWithGoogle(),
    );
  }

  void _onLoginWithFacebook(result) {
    _loginBloc.add(
      LoginWithFacebook(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        //*
        //* ON FAILURE STATE
        //*
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: secondBackgroundColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Login Failed",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.error,
                      color: mainColor,
                    ),
                  ],
                ),
              ),
            );
        }
        //*
        //* ON SUBMITTING STATE
        //*
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
                      "Logging In...",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: size.width * 0.04,
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
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          //*
          //* LOGIN FORM
          //*
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                //* LOGIN BUTTON
                //*
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.008),
                  child: GestureDetector(
                    onTap:
                        isLoginButtonEnabled(state) ? _onFormSubmitted : null,
                    child: Container(
                      width: size.width * 0.5,
                      height: size.width * 0.18,
                      decoration: BoxDecoration(
                        color: isLoginButtonEnabled(state)
                            ? mainColor
                            : secondBackgroundColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "LOG IN",
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
                //* GO TO SIGNUP SCREEN BUTTON
                //*
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.04),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUp(userRepository: _userRepository);
                          },
                        ),
                      );
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
                          TextSpan(text: 'Don’t have an account? '),
                          TextSpan(
                            text: 'Sign up',
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
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
