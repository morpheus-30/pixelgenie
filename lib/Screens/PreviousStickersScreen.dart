import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixelgenie/Providers/StickerPackListProvderClass.dart';
import 'package:pixelgenie/Screens/GettingStartedScreen.dart';
import 'package:pixelgenie/firebaseFunctions.dart';
import 'package:pixelgenie/constants.dart';
import 'package:pixelgenie/whatsapFunctions.dart';
import 'package:provider/provider.dart';

class PreviousStickerScreen extends StatefulWidget {
  const PreviousStickerScreen({super.key});
  @override
  State<PreviousStickerScreen> createState() => _PreviousStickerScreenState();
}

class _PreviousStickerScreenState extends State<PreviousStickerScreen> {
  Future<List<String>> getPreviousStickersFromServer() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> stickers = [];
    try {
      ListResult result = await storage
          .ref('/stickers/${FirebaseAuth.instance.currentUser!.uid}')
          .list();
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        stickers.add(url);
      }
      print(stickers);
      return stickers;
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<StickerPackListProvderClass>().stickerPackList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
              child: Text(
            "🧞",
            style: TextStyle(fontSize: 30),
          )),
        ),
        title: Text(
          "Previous Stickers",
          style: GoogleFonts.pixelifySans(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getPreviousStickersFromServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: kGradientBackgroundDecoration,
              child: Center(
                  child: Image.asset(
                'assets/images/loading.gif',
                height: 200,
                width: 200,
              )),
            );
          } else {
            if (snapshot.hasError) {
              return Container(
                decoration: kGradientBackgroundDecoration,
                child: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            } else {
              List<String> stickers = snapshot.data as List<String>;
              return Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 30,
                      left: 10,
                      right: 10,
                      bottom: 10),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: kGradientBackgroundDecoration,
                  child: stickers.isEmpty
                      ? Center(
                          child: Text(
                            "No Stickers Found",
                            style: GoogleFonts.pixelifySans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        )
                      : Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 100,
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: stickers
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          String temp =
                                              e.split("%2F")[2].split("?")[0];
                                          print(e);
                                          if (context
                                              .read<StickerPackListProvderClass>()
                                              .isPresent(temp)) {
                                            context
                                                .read<
                                                    StickerPackListProvderClass>()
                                                .removeSticker(temp);
                                          } else {
                                            context
                                                .read<
                                                    StickerPackListProvderClass>()
                                                .addSticker([temp, '😄', '😀']);
                                          }
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(e),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          foregroundDecoration: BoxDecoration(
                                            color: context
                                                    .watch<
                                                        StickerPackListProvderClass>()
                                                    .isPresent(e
                                                        .split("%2F")[2]
                                                        .split("?")[0])
                                                ? Colors.black.withOpacity(0.5)
                                                : null,
                                          ),
                                          child: context
                                                  .watch<
                                                      StickerPackListProvderClass>()
                                                  .isPresent(e
                                                      .split("%2F")[2]
                                                      .split("?")[0])
                                              ? Icon(
                                                  FontAwesomeIcons.check,
                                                  color: Colors.white,
                                                  size: 30,
                                                  weight: 10,
                                                )
                                              : null,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        context
                                    .watch<StickerPackListProvderClass>()
                                    .stickerPackList
                                    .length >
                                0
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: SendToWpButton(),
                              )
                            : Container(),
                      ],
                    ),
                  ));
            }
          }
        },
      ),
    );
  }
}

class SendToWpButton extends StatefulWidget {
  @override
  State<SendToWpButton> createState() => _SendToWpButtonState();
}

class _SendToWpButtonState extends State<SendToWpButton> {
  String sendToWpButtonText = "Send to Whatsapp";

  @override
  Widget build(BuildContext context) {
    return StarsButton(
      buttonText: sendToWpButtonText,
      onPressed: sendToWpButtonText == "Sending..."
          ? () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF1A1A1A),
                      title: Text(
                        "Please Wait",
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      content: Text(
                        "Please wait for the current sticker to send",
                        style: GoogleFonts.pixelifySans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  });
            }
          : () async {
              setState(() {
                sendToWpButtonText = "Sending...";
              });
              List<List<String>> stickers =
                  context.read<StickerPackListProvderClass>().stickerPackList;
              await updateUserCurrentStickers(stickers);
              await installFromRemote(stickers);
              context
                  .read<StickerPackListProvderClass>()
                  .clearStickerPackList();
              setState(() {
                sendToWpButtonText = "Send to Whatsapp";
              });
            },
    );
  }
}
