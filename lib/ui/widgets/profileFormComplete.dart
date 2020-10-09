import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gather_app/models/user.dart';
import 'package:gather_app/ui/widgets/custom_text_field.dart';
import 'package:gather_app/ui/widgets/gameplay_style.dart';
import 'package:gather_app/ui/widgets/games_card.dart';
import 'package:gather_app/ui/widgets/plataform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gather_app/bloc/profile/bloc.dart';
import 'package:gather_app/repositories/userRepository.dart';
import 'package:gather_app/ui/constants.dart';
import 'package:gather_app/icons/gather_custom_icons_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormComplete extends StatefulWidget {
  final UserRepository _userRepository;
  //* USER DATA ON CLOUD
  final User user;

  ProfileFormComplete({@required UserRepository userRepository, User user})
      : assert(userRepository != null && user != null),
        _userRepository = userRepository,
        user = user;

  @override
  _ProfileFormCompleteState createState() => _ProfileFormCompleteState();
}

class _ProfileFormCompleteState extends State<ProfileFormComplete> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  //* USER DATA LOCALLY
  //? ESSENTIAL USER DATA
  String plataform;
  DateTime age;
  File photo;
  GeoPoint location;

  //? NOT ESSENTIAL USER DATA
  String bio;
  String gameplayStyle;
  String gender;
  List<dynamic> games;

  bool nameIsFilled;
  bool bioIsFilled;

  ProfileBloc _profileBloc;
  UserRepository get _userRepository => widget._userRepository;

  //* BOOL STORING IF ESSENTIAL FIELDS ARE FILLED
  bool get isFilled =>
      nameController.text.isNotEmpty &&
      plataform != null &&
      //photo != null &&
      age != null;

  //*
  bool isButtonEnabled(ProfileState state) {
    return isFilled && !state.isSubmitting;
  }

  //* FUCTION TO GET THE USER LOCATION
  //?  idk if i keep this, uptade the user location is processing expense, can be useful tho
  _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    location = GeoPoint(position.latitude, position.longitude);
  }

  //* FUNCTION TO SAVE THE LOCAL DATA ON THE CLOUD
  _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Uptaded(
        uid: widget.user.uid,
        name: nameController.text,
        bio: bioController.text,
        gameplayStyle: gameplayStyle,
        plataform: plataform,
        gender: gender,
        age: age,
        location: location,
        photo: photo,
        games: games,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.text = widget.user.name;
    age = widget.user.age.toDate();
    bioController.text = widget.user.bio;
    gameplayStyle = widget.user.gameplayStyle;
    plataform = widget.user.plataform;
    gender = widget.user.gender;
    games = widget.user.games;

    nameIsFilled = nameController.text.isNotEmpty;
    bioIsFilled = bioController.text.isNotEmpty;
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);

    nameController.addListener(_onNameChanged);
    bioController.addListener(_onBioChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        //*
        //* SNACKBAR SHOWED IN THE EVENT OF FAILURE
        //*
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
                      "Profile Uptade Unsuccesful",
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

        //*
        //* SNACKBAR SHOWED IN THE EVENT OF SUBMITTING
        //*
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
                      "Saving...",
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
        //* SNACKBAR SHOWED IN THE EVENT OF SUCCESS
        //*
        if (state.isSuccess) {
          print('Success');
          Navigator.pop(context, true);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              //*
              //* PROFILE PICTURE
              //*
              Container(
                width: size.width * 0.55,
                height: size.width * 0.55,
                child: photo == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: GestureDetector(
                          onTap: () async {
                            PickedFile result = await _picker.getImage(
                              source: ImageSource.gallery,
                              maxHeight: 700,
                              maxWidth: 700,
                            );

                            File getPic = File(result.path);

                            File croppedPic = await ImageCropper.cropImage(
                              sourcePath: getPic.path,
                              aspectRatio:
                                  CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                            );
                            if (croppedPic != null) {
                              setState(() {
                                photo = croppedPic;
                              });
                            }
                          },
                          child: widget.user.photo != null
                              ? Image.network(
                                  widget.user.photo,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation(mainColor),
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset('assets/icons/profile_photo.png'),
                        ),
                      )
                    : CircleAvatar(
                        radius: size.width * 0.3,
                        backgroundColor: secondBackgroundColor,
                        child: GestureDetector(
                          onTap: () async {
                            PickedFile result = await _picker.getImage(
                              source: ImageSource.gallery,
                              maxHeight: 700,
                              maxWidth: 700,
                            );

                            File getPic = File(result.path);
                            File croppedPic = await ImageCropper.cropImage(
                              sourcePath: getPic.path,
                              aspectRatio:
                                  CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                            );
                            if (croppedPic != null) {
                              setState(
                                () {
                                  photo = croppedPic;
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
              //*
              //* USER NAME FIELD
              //*
              CustomTextField(
                controller: nameController,
                label: "Name",
                isPopulated: nameIsFilled,
                icon: GatherCustomIcons.user,
                iconSize: 27,
              ),
              //*
              //* USER AGE FIELD
              //*
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
                    },
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    label: age != null
                        ? " " +
                            age.day.toString() +
                            "/" +
                            age.month.toString() +
                            "/" +
                            age.year.toString()
                        : "Date of Birth",
                    isPopulated: age != null,
                    icon: GatherCustomIcons.calendar,
                    iconSize: 23,
                  ),
                ),
              ),
              //*
              //* USER BIO FIELD
              //*
              CustomTextField(
                controller: bioController,
                label: "Bio",
                isPopulated: bioIsFilled,
                icon: GatherCustomIcons.user,
                iconSize: 27,
              ),
              SizedBox(
                height: 10,
              ),
              //*
              //* USER GAMEPLAY STYLE FIELD
              //*
              Container(
                alignment: Alignment.topLeft,
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
                    icon: GatherCustomIcons.casual,
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
                    icon: GatherCustomIcons.competitive,
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
              SizedBox(
                height: 10,
              ),
              //*
              //* USER PLATFORM FIELD
              //*
              Container(
                alignment: Alignment.topLeft,
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
                    icon: Icon(
                      GatherCustomIcons.xbox,
                      color: Colors.white,
                      size: 32,
                    ),
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
                    icon: Icon(
                      GatherCustomIcons.computer,
                      color: Colors.white,
                      size: 32,
                    ),
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
                    icon: Icon(
                      GatherCustomIcons.mobile,
                      color: Colors.white,
                      size: 32,
                    ),
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
              ),
              SizedBox(
                height: 20,
              ),
              //*
              //* USER GENDER FIELD
              //*
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                child: Text(
                  "Gender",
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
                      GatherCustomIcons.male,
                      color: Colors.white,
                      size: 32,
                    ),
                    text: "Male",
                    size: size,
                    selected: gender,
                    onTap: () {
                      setState(
                        () {
                          gender = "Male";
                        },
                      );
                    },
                  ),
                  plataformWidget(
                    icon: Icon(
                      GatherCustomIcons.female,
                      color: Colors.white,
                      size: 32,
                    ),
                    text: "Female",
                    size: size,
                    selected: gender,
                    onTap: () {
                      setState(
                        () {
                          gender = "Female";
                        },
                      );
                    },
                  ),
                  plataformWidget(
                    icon: Icon(
                      GatherCustomIcons.helicopter,
                      color: Colors.white,
                      size: 32,
                    ),
                    text: "Helicopter",
                    size: size,
                    selected: gender,
                    onTap: () {
                      setState(
                        () {
                          gender = "Helicopter";
                        },
                      );
                    },
                  ),
                  plataformWidget(
                    icon: Icon(
                      GatherCustomIcons.others,
                      color: Colors.white,
                      size: 32,
                    ),
                    text: "Others",
                    size: size,
                    selected: gender,
                    onTap: () {
                      setState(
                        () {
                          gender = "Others";
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              //*
              //* USER GAMES
              //*
              Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "GAMES",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Clobber',
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GamesCard(
                  games: games,
                  isEditing: true,
                  onGamesChanged: (gamesUptade) {
                    setState(() {
                      games = gamesUptade;
                    });
                  },
                ),
              ),
              //*
              //* SAVE BUTTON
              //*
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
        },
      ),
    );
  }

  void _onNameChanged() {
    if (nameController.text != "") {
      setState(() {
        nameIsFilled = true;
      });
    } else {
      setState(() {
        nameIsFilled = false;
      });
    }
  }

  void _onBioChanged() {
    if (bioController.text != "") {
      setState(() {
        bioIsFilled = true;
      });
    } else {
      setState(() {
        bioIsFilled = false;
      });
    }
  }
}
