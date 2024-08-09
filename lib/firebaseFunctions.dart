import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;
    print(user!.displayName);

    if (await ifUserExists()) {
      print("User exists");
    } else {
      print("User does not exist");
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': user.displayName,
        'email': user.email,
        'currentStickers': [],
        'last_sticker_timestamp':""
      });
    }

    // Use the user object for further operations or navigate to a new screen.
  } catch (e) {
    print(e.toString());
  }
}

Future<void> signOutGoogle() async {
  try {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e.toString());
  }
}

Future<String> getToken() async {
  final User? user = FirebaseAuth.instance.currentUser;
  return await user!.getIdToken() ?? "";
}

Future updateUserCurrentStickers(List<List<String>> stickers) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("currentStickers").get().then((QuerySnapshot querySnapshot) {
        for(DocumentSnapshot documentSnapshot in querySnapshot.docs){
          documentSnapshot.reference.delete();
        }
      });
      
  for (int i = 0; i < stickers.length; i++) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("currentStickers")
        .doc(stickers[i][0])
        .set({
      'name': stickers[i][0],
      'emoji1': stickers[i][1],
      'emoji2': stickers[i][2],
    });
  }
}

Future<bool> ifUserExists() async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  });
  return false;
}

Future getLastStickerTimestamp() async {
  String lastStickerTimestamp = "";
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    lastStickerTimestamp = documentSnapshot['last_sticker_timestamp'];
  });
  return DateTime.parse(lastStickerTimestamp);
}

Future<List<List<String>>> getUserCurrentStickers() async {
  List<List<String>> currentStickers = [];
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("currentStickers")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      currentStickers.add([
        doc['name'],
        doc['emoji1'],
        doc['emoji2'],
      ]);
    });
  });
  return currentStickers;
}

Future updateLastStickerTimestamp() async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
    'last_sticker_timestamp': DateTime.now().toString(),
  });
}
