import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String bio;
  String gender;
  String gameplayStyle;
  String plataform;
  String photo;
  Timestamp age;
  GeoPoint location;
  List<dynamic> games;

  User(
      {this.uid,
      this.name,
      this.bio,
      this.gender,
      this.gameplayStyle,
      this.plataform,
      this.photo,
      this.age,
      this.location,
      this.games});
}

/*
class User {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;

  User(
      {this.uid,
      this.age,
      this.gender,
      this.interestedIn,
      this.location,
      this.name,
      this.photo});
}

 */
