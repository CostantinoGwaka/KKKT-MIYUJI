import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
class Cloud {
  static Future add({
    String? serverPath,
    dynamic value,
    String? serverTime,
  }) async {
    try {
      await FirebaseDatabase.instance.ref().child(serverPath!).set(value);
    } catch (e) {
      print(e);
    }
  }

  static Future updateStafToken({String? serverPath, dynamic value}) async {
    // await FirebaseDatabase.instance
    //     .reference()
    //     .child(serverPath)
    //     .once()
    //     .then((snapshot) async {
    //   if (snapshot.value != null) {
    //     await FirebaseDatabase.instance
    //         .reference()
    //         .child(serverPath)
    //         .update(value);
    //   }
    // });
  }

  static Future update({bool checkSnap = true, String? serverPath, dynamic value}) async {
    try {
      if (checkSnap) {
        final snapshot = await FirebaseDatabase.instance.ref().child(serverPath!).once();

        if (snapshot.snapshot.value != null) {
          await FirebaseDatabase.instance.ref().child(serverPath).update({
            "lastmessage": value["lastmessage"],
            "unseen": ServerValue.increment(1),
            "time": value["time"],
          });
        } else {
          await FirebaseDatabase.instance.ref().child(serverPath).set(value);
        }
      } else {
        await FirebaseDatabase.instance.ref().child(serverPath!).update(value);
      }
    } catch (e) {
      // print(e);
    }
  }

  static Future<void> delete({String? serverPath}) async {
    try {
      await FirebaseDatabase.instance.ref().child(serverPath!).remove();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
