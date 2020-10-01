import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gather_app/ui/widgets/custom_text_field.dart';
import 'package:gather_app/ui/widgets/plataform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gather_app/bloc/authentication/authentication_bloc.dart';
import 'package:gather_app/bloc/authentication/authentication_event.dart';
import 'package:gather_app/bloc/profile/bloc.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';

class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController nameController = TextEditingController();

  String plataform;
  DateTime age;
  File photo;
  GeoPoint location;

  ProfileBloc _profileBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isFilled =>
      nameController.text.isNotEmpty &&
      plataform != null &&
      photo != null &&
      age != null;

  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    location = GeoPoint(position.latitude, position.longitude);
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Submitted(
        name: nameController.text,
        age: age,
        location: location,
        plataform: plataform,
        photo: photo,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFailure) {
          print('Failed');
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: secondBackgroundColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profile Creation Unsuccesful",
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
              ),
            );
        }
        if (state.isSubmitting) {
          print('Submitting');
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                duration: Duration(seconds: 10),
                backgroundColor: secondBackgroundColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Creating...",
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
        if (state.isSuccess) {
          print('Success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width * 0.55,
              height: size.width * 0.55,
              child: photo == null
                  ? GestureDetector(
                      onTap: () async {
                        File getPic =
                            await FilePicker.getFile(type: FileType.image);
                        if (getPic != null) {
                          setState(() {
                            photo = getPic;
                          });
                        }
                      },
                      child: Image.asset('assets/icons/profile_photo.png'),
                    )
                  : CircleAvatar(
                      radius: size.width * 0.3,
                      backgroundColor: secondBackgroundColor,
                      child: GestureDetector(
                        onTap: () async {
                          File getPic =
                              await FilePicker.getFile(type: FileType.image);
                          if (getPic != null) {
                            setState(
                              () {
                                photo = getPic;
                              },
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: size.width * 0.3,
                          backgroundColor: secondBackgroundColor,
                          backgroundImage: FileImage(photo),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              controller: nameController,
              label: "Name",
              isPopulated: nameController.text.isNotEmpty,
              icon: GatherCustomIcons.user,
              iconSize: 27,
            ),
            GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime(DateTime.now().year),
                    onConfirm: (date) {
                      setState(() {
                        age = date;
                      });
                      print(age);
                    },
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: "Date of Birth",
                    isPopulated: age != null,
                    icon: GatherCustomIcons.calendar,
                    iconSize: 23,
                  ),
                )),
            SizedBox(
              height: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                  child: Text(
                    "Plataform",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Clobber',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    plataformWidget(
                      icon: Icon(
                        GatherCustomIcons.playstation,
                        color: Colors.white,
                        size: 32,
                      ),
                      text: "PlayStation",
                      size: size,
                      selected: plataform,
                      onTap: () {
                        setState(
                          () {
                            plataform = "PlayStation";
                          },
                        );
                      },
                    ),
                    plataformWidget(
                      icon: Icon(GatherCustomIcons.xbox,
                          color: Colors.white, size: 32),
                      text: "Xbox",
                      size: size,
                      selected: plataform,
                      onTap: () {
                        setState(
                          () {
                            plataform = "Xbox";
                          },
                        );
                      },
                    ),
                    plataformWidget(
                      icon: Icon(GatherCustomIcons.computer,
                          color: Colors.white, size: 32),
                      text: "Computer",
                      size: size,
                      selected: plataform,
                      onTap: () {
                        setState(
                          () {
                            plataform = "Computer";
                          },
                        );
                      },
                    ),
                    plataformWidget(
                      icon: Icon(GatherCustomIcons.mobile,
                          color: Colors.white, size: 32),
                      text: "Mobile",
                      size: size,
                      selected: plataform,
                      onTap: () {
                        setState(
                          () {
                            plataform = "Mobile";
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
              child: GestureDetector(
                onTap: () {
                  if (isButtonEnabled(state)) {
                    _onSubmitted();
                  } else {}
                },
                child: Container(
                  width: size.width * 0.5,
                  height: 65,
                  decoration: BoxDecoration(
                    color: isButtonEnabled(state)
                        ? mainColor
                        : secondBackgroundColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Clobber',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}

//?? WIDGET PODE SER REUTILIZADO (GAMEPLAYSTYLE)
/**
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Gameplay Style",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Clobber',
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    gameplayStyleWidget(
                      iconWhite: "assets/icons/casual_icon_white.png",
                      iconOrange: "assets/icons/casual_icon_orange.png",
                      text: "Casual",
                      size: size,
                      selected: gameplayStyle,
                      onTap: () {
                        setState(() {
                          gameplayStyle = "Casual";
                        });
                      },
                    ),
                    gameplayStyleWidget(
                      iconWhite: "assets/icons/competitive_icon_white.png",
                      iconOrange: "assets/icons/competitive_icon_orange.png",
                      text: "Competitive",
                      size: size,
                      selected: gameplayStyle,
                      onTap: () {
                        setState(() {
                          gameplayStyle = "Competitive";
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
             */
