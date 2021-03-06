import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gather_app/models/user.dart';

class SearchRepository {
  final Firestore _firestore;

  SearchRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<User> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('selectedList')
        .document(currentUserId)
        .setData({
      'name': name,
      'photoUrl': photoUrl,
    });

    // await _firestore
    //     .collection('users')
    //     .document(currentUserId)
    //     .collection('lastUser')
    //     .document(selectedUserId)
    //     .setData(selectedUserId);

    return getUser(currentUserId);
  }

  passUser(currentUserId, selectedUserId) async {
    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    // await _firestore
    //     .collection('users')
    //     .document(currentUserId)
    //     .collection('lastUser')
    //     .document(selectedUserId)
    //     .setData(selectedUserId);

    return getUser(currentUserId);
  }

  Future getUserInterests(userId) async {
    User currentUser = User();

    await _firestore.collection('users').document(userId).get().then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.plataform = user['plataform'];
    });
    return currentUser;
  }

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];
    await _firestore
        .collection('users')
        .document(userId)
        .collection('chosenList')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          chosenList.add(doc.documentID);
        }
      }
    });
    return chosenList;
  }

  Future<List> getSelectedList(userId) async {
    List<String> selectedList = [];

    await _firestore
        .collection('users')
        .document(userId)
        .collection('selectedList')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          selectedList.add(doc.documentID);
        }
      }
    });
    return selectedList;
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> chosenList = await getChosenList(userId);
    List<String> selectedList = await getSelectedList(userId);
    User currentUser = await getUserInterests(userId);

    await _firestore.collection('users').getDocuments().then(
      (users) {
        for (var user in users.documents) {
          if ((!chosenList.contains(user.documentID)) &&
              (!selectedList.contains(user.documentID)) &&
              (user.documentID != userId) &&
              (currentUser.plataform == user['plataform']) &&
              (user['plataform'] == currentUser.plataform)) {
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
            break;
          }
        }
      },
    );

    return _user;
  }
}
