import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_stickers_exporter/exceptions.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';

Future installFromAssets(List<List<String>> stickers) async {
  List<List<String>> stickerSet = [];

  for (var s in stickers) {
    var stickerObject = <String>[];
    stickerObject.add(WhatsappStickerImage.fromAsset(s[0]).path);
    stickerObject.addAll(s.sublist(1, s.length));
    stickerSet.add(stickerObject);
  }

  var trayImage =
      WhatsappStickerImage.fromAsset("assets/images/manan.png").path;

  var exporter = WhatsappStickersExporter();
  try {
    await exporter.addStickerPack(
        "pixel_genie", //identifier
        "pixel_genie", //name
        "Nakshhhhh", //publisher
        trayImage, //trayImage
        "https://naksh.live", //publisherWebsite
        "https://naksh.live", //privacyPolicyWebsite
        "https://naksh.live", //licenseAgreementWebsite
        false, //animatedStickerPack
        stickerSet);
  } catch (e) {
    print((e as WhatsappStickersException).cause);
  }
}

Future installFromRemote(List<List<String>> stickers) async {
  var appDir = await getApplicationDocumentsDirectory();
  var ssDir = Directory('${appDir.path}/stickers');
  await ssDir.create(recursive: true);

  final dio = Dio();
  final downloads = <Future>[];
  //https://storage.googleapis.com/pixelgenie-78323.appspot.com/stickers/HeJwdaGLKZdb2Dxv9EzEAZsLzi12/20240715172809.png
  for (var a in stickers) {
    // print(a[0]);
    // print("https://storage.googleapis.com/pixelgenie-78323.appspot.com/stickers/${FirebaseAuth.instance.currentUser!.uid}/${a[0]}");
    downloads.add(
      dio.download(
        'https://storage.googleapis.com/travelmeet-e8a80.firebasestorage.app/stickers/${FirebaseAuth.instance.currentUser!.uid}/${a[0]}',
        '${ssDir.path}/${a[0]}',
      ),
    );
  }

  await Future.wait(downloads);

  List<List<String>> stickerSet = [];

  for (var s in stickers) {
    var stickerObject = <String>[];
    stickerObject
        .add(WhatsappStickerImage.fromFile('${ssDir.path}/${s[0]}').path);
    stickerObject.addAll(s.sublist(1, s.length));
    stickerSet.add(stickerObject);
  }

  List<String> s = ["assets/images/pixelGenie.webp", '😄', '😀'];
  var ifLessThan2StickerObject = <String>[];
  ifLessThan2StickerObject.add(WhatsappStickerImage.fromAsset(s[0]).path);
  ifLessThan2StickerObject.addAll(s.sublist(1, s.length));

  if (stickerSet.length < 2) {
    stickerSet.add(ifLessThan2StickerObject);
    stickerSet.add(ifLessThan2StickerObject);
  } else if (stickerSet.length < 3) {
    stickerSet.add(ifLessThan2StickerObject);
  }
  print(stickerSet);

  var trayImage = WhatsappStickerImage.fromAsset("assets/images/tray.png").path;

  var exporter = WhatsappStickersExporter();
  try {
    await exporter.addStickerPack(
        "Pixel Genie", //identifier
        "Pixel Genie", //name
        "Sourav&Naksh", //publisher
        trayImage, //trayImage
        "", //publisherWebsite
        "", //privacyPolicyWebsite
        "", //licenseAgreementWebsite
        false, //animatedStickerPack
        stickerSet);
  } catch (e) {
    print((e as WhatsappStickersException).cause);
  }
}
