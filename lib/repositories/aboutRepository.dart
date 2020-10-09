import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_app/models/user.dart';

class AboutRepository {
  final Firestore _firestore;

  AboutRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<User> getUser(userId) async {
    User _user = User();

    await _firestore.collection('users').document(userId).get().then(
      (user) {
        _user.uid = user.documentID;
        _user.name = user['name'];
        _user.bio = user['bio'];
        _user.gender = user['gender'];
        _user.gameplayStyle = user['gameplayStyle'];
        _user.plataform = user['plataform'];
        _user.photo = user['photoUrl'];
        _user.age = user['age'];
        _user.location = user['location'];
        _user.games = user['games'];
      },
    );

    return _user;
  }
}
