import 'package:firebase_database/firebase_database.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
class Cloud {
  static Future add({
    String serverPath,
    dynamic value,
    String serverTime,
  }) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('$serverPath')
          .set(value);
    } catch (e) {
      print(e);
    }
  }

  static Future updateStafToken({String serverPath, dynamic value}) async {
    await FirebaseDatabase.instance
        .reference()
        .child('$serverPath')
        .once()
        .then((snapshot) async {
      if (snapshot.value != null) {
        await FirebaseDatabase.instance
            .reference()
            .child('$serverPath')
            .update(value);
      }
    });
  }

  static Future update(
      {bool checkSnap = true, String serverPath, dynamic value}) async {
    try {
      if (checkSnap) {
        await FirebaseDatabase.instance
            .reference()
            .child('$serverPath')
            .once()
            .then((snapshot) async {
          if (snapshot.value != null) {
            await FirebaseDatabase.instance
                .reference()
                .child('$serverPath')
                .update({
              "lastmessage": value["lastmessage"],
              "unseen": ServerValue.increment(1),
              "time": value["time"],
            });
          } else {
            await FirebaseDatabase.instance
                .reference()
                .child('$serverPath')
                .set(value);
          }
        });
      } else {
        await FirebaseDatabase.instance
            .reference()
            .child('$serverPath')
            .update(value);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> delete({String serverPath}) async {
    try {
      await FirebaseDatabase.instance.reference().child('$serverPath').remove();
    } catch (e) {
      print(e);
    }
  }
}
