import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static Future<List<String>> getFirebaseImageLinkAsList() async {
    List<String> links = [];
    try {
      final dataRef = FirebaseDatabase.instance.ref();
      final snapshot = await dataRef.child("Admin").get();
      for (var element in snapshot.children) {
        links.add(element.value.toString());
      }
    } catch (e) {
      rethrow;
    }

    return links;
  }
}
