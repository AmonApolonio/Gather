import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  UserRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance;

  Future<void> signInWithEmail(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<bool> isFirstTime(String userId) async {
    bool exist;
    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
      exist = user.exists;
    });

    return exist;
  }

  Future<void> signUpWithEmail(String email, String password) async {
    print(_firebaseAuth);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  //profile setup
  Future<void> profileSetup(
    File photo,
    String userId,
    String name,
    String plataform,
    DateTime age,
    GeoPoint location,
  ) async {
    StorageUploadTask storageUploadTask;
    storageUploadTask = FirebaseStorage.instance
        .ref()
        .child("userPhotos")
        .child(userId)
        .child(userId)
        .putFile(photo);

    return await storageUploadTask.onComplete.then(
      (ref) async {
        await ref.ref.getDownloadURL().then(
          (url) async {
            await _firestore.collection('users').document(userId).setData({
              'uid': userId,
              'photoUrl': url,
              'name': name,
              'location': location,
              'gameplayStyle': '',
              'age': age,
              'bio': '',
              'plataform': plataform,
              'gender': '',
              'games': [],
            });
          },
        );
      },
    );
  }

  Future<void> profileUptade(
    String uid,
    name,
    bio,
    gameplayStyle,
    plataform,
    gender,
    DateTime age,
    GeoPoint location,
    File photo,
    List<dynamic> games,
  ) async {
    if (photo != null) {
      StorageUploadTask storageUploadTask;
      storageUploadTask = FirebaseStorage.instance
          .ref()
          .child("userPhotos")
          .child(uid)
          .child(uid)
          .putFile(photo);

      return await storageUploadTask.onComplete.then(
        (ref) async {
          await ref.ref.getDownloadURL().then(
            (url) async {
              await _firestore.collection('users').document(uid).updateData({
                'uid': uid,
                'photoUrl': url,
                'name': name,
                'location': location,
                'gameplayStyle': gameplayStyle,
                'age': age,
                'bio': bio,
                'plataform': plataform,
                'gender': gender,
                'games': games,
              });
            },
          );
        },
      );
    } else {
      await _firestore.collection('users').document(uid).updateData({
        'uid': uid,
        'name': name,
        'location': location,
        'gameplayStyle': gameplayStyle,
        'age': age,
        'bio': bio,
        'plataform': plataform,
        'gender': gender,
        'games': games,
      });
    }
  }
}
