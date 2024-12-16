import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pixelgenie/Screens/GettingStartedScreen.dart';
import 'package:pixelgenie/ad_helper.dart';
import 'package:pixelgenie/firebaseFunctions.dart';
import 'package:pixelgenie/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pixelgenie/whatsapFunctions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String prompt = "";
  bool isLoading = false;
  String sendToWpButtonText = "Send to Whatsapp";
  String imageLink = "";
  TextEditingController messageController = TextEditingController();
  // RewardedAd? _rewardAdd;
  // Duration? timeToWait;
  // Duration? timer ;

  void startTimer() async {
    Timer.periodic(Duration(seconds: 1), (timer) {});
  }

  // void _updateLastStickerTimestamp() async {
  //   DateTime? lastStickerTimestamp = await getLastStickerTimestamp();
  //   timeToWait = DateTime.now().difference(lastStickerTimestamp!);
  //   timer = timeToWait;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // _createRewardAd();
    // _updateLastStickerTimestamp();
  }

  // void _showRewardedAd() {
  //   if (_rewardAdd == null) {
  //     return;
  //   }
  //   _rewardAdd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdDismissedFullScreenContent: (ad) {
  //       ad.dispose();
  //       _createRewardAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (ad, error) {
  //       ad.dispose();
  //       _createRewardAd();
  //     },
  //   );
  //   // _rewardAdd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward){
  //   //   print("User earned reward: ${reward.amount}");
  //   // });
  // }

  // void _createRewardAd() {
  //   RewardedAd.load(
  //     adUnitId: AdMobService.rewardAdUnitId!,
  //     request: AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (RewardedAd ad) {
  //         setState(() {
  //           _rewardAdd = ad;
  //         });
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         _rewardAdd = null;
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Center(
                child: Text(
              "🧞",
              style: TextStyle(fontSize: 30),
            )),
            title: Text(
                "Hello! " +
                    FirebaseAuth.instance.currentUser!.displayName!.substring(
                        0,
                        min(
                            15,
                            FirebaseAuth
                                .instance.currentUser!.displayName!.length)),
                style: GoogleFonts.pixelifySans(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
            backgroundColor: Color(0xFF090979),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    "Logout",
                    style: GoogleFonts.pixelifySans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFF1A1A1A),
                          title: Text("Logout",
                              style: GoogleFonts.pixelifySans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )),
                          content: Text("WHYY are you leaving??😭",
                              style: GoogleFonts.pixelifySans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("SORRY! I'll stay",
                                    style: GoogleFonts.pixelifySans(
                                      textStyle: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ))),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await signOutGoogle();
                                Navigator.pushNamed(context, '/gettingStarted');
                              },
                              child: Text(
                                "Let me go! 😢",
                                style: GoogleFonts.pixelifySans(
                                    textStyle: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: kGradientBackgroundDecoration,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Generate a Sticker with AI 🧞",
                            style: GoogleFonts.pixelifySans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                              ),
                            )),
                        const SizedBox(height: 20),
                        imageLink == ""
                            ? Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: messageController,
                                      maxLength: 50,
                                      onChanged: (value) {
                                        prompt = value;
                                      },
                                      style: GoogleFonts.pixelifySans(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        hintText: "Enter the message",
                                        hintStyle: GoogleFonts.pixelifySans(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(height: 20),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    // child: timeToWait!.inMinutes>0||timeToWait!.inSeconds>0
                                    // ? StarsButton(buttonText: "${timer!.inMinutes}:${timer!.inSeconds} left", onPressed: (){})
                                    child: StarsButton(
                                        buttonText: isLoading
                                            ? "Generating..."
                                            : "Generate FAST!!",
                                        onPressed: isLoading
                                            ? () {
                                                //request focus to remove keyboard
                                                FocusScope.of(context)
                                                    .unfocus();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Color(0xFF1A1A1A),
                                                        title: Text(
                                                          "Please Wait",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "Please wait for the current sticker to generate",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            : () async {
                                                if (prompt == "") {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              Color(0xFF1A1A1A),
                                                          title: Text(
                                                            "Please Enter a message",
                                                            style: GoogleFonts
                                                                .pixelifySans(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          content: Text(
                                                            "Please enter a message to generate a sticker",
                                                            style: GoogleFonts
                                                                .pixelifySans(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  return;
                                                }
                                                FocusScope.of(context)
                                                    .unfocus();
                                                bool isOk = false;
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Color(0xFF1A1A1A),
                                                        title: Text(
                                                          "Generate?",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "LET ME EDIT!",
                                                                style: GoogleFonts
                                                                    .pixelifySans(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              )),
                                                          TextButton(
                                                            onPressed: () {
                                                              isOk = true;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "LESSGOO!!",
                                                              style: GoogleFonts
                                                                  .pixelifySans(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                        content: Text(
                                                          "Generate the sticker for prompt\n$prompt",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (isOk) {
                                                  // _showRewardedAd();
                                                  setState(() {
                                                    messageController.clear();
                                                    isLoading = true;
                                                  });
                                                  await http.post(
                                                      Uri.parse(
                                                          "https://fancy-adequately-fish.ngrok-free.app/generate"),
                                                      body: jsonEncode({
                                                        "dialog": prompt,
                                                      }),
                                                      headers: {
                                                        "Authorization":
                                                            "Bearer ${await getToken()}",
                                                        "Content-Type":
                                                            "application/json"
                                                      }).then((response) {
                                                    print(response.body);
                                                    var data = jsonDecode(
                                                        response.body);
                                                    // if(data["status"]=="")
                                                    if (data["status"] ==
                                                        false) {
                                                      //a dialog with "Please try again" and a button to close
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF1A1A1A),
                                                              content: Text(
                                                                "Some error occured, Please try again",
                                                                style: GoogleFonts
                                                                    .pixelifySans(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      return;
                                                    }
                                                    setState(() {
                                                      imageLink =
                                                          data["imguri"];
                                                      isLoading = false;
                                                    });
                                                    print(imageLink);
                                                  });
                                                  await updateLastStickerTimestamp();
                                                  setState(() {
                                                    isLoading = false;
                                                    prompt = "";
                                                  });
                                                }
                                              }),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: StarsButton(
                                        buttonText: "Previous Stickers",
                                        onPressed: isLoading
                                            ? () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Color(0xFF1A1A1A),
                                                        title: Text(
                                                          "Please Wait",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "Please wait for the current sticker to generate",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            : () {
                                                Navigator.pushNamed(context,
                                                    '/previousStickers');
                                              }),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Image.network(
                                    "https://storage.googleapis.com/travelmeet-e8a80.firebasestorage.app/stickers/${FirebaseAuth.instance.currentUser!.uid}/$imageLink",
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height:
                                        MediaQuery.of(context).size.width - 40,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: StarsButton(
                                        buttonText: sendToWpButtonText,
                                        onPressed: sendToWpButtonText ==
                                                "Sending..."
                                            ? () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            Color(0xFF1A1A1A),
                                                        title: Text(
                                                          "Please Wait",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        content: Text(
                                                          "Please wait for the current sticker to send",
                                                          style: GoogleFonts
                                                              .pixelifySans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            : () async {
                                                setState(() {
                                                  sendToWpButtonText =
                                                      "Sending...";
                                                });
                                                List<List<String>>
                                                    currentStickers;
                                                // print(
                                                // "https://storage.googleapis.com/pixelgenie-78323.appspot.com/stickers/${FirebaseAuth.instance.currentUser!.uid}/$imageLink");
                                                currentStickers =
                                                    await getUserCurrentStickers();
                                                currentStickers.add(
                                                    [imageLink, "😄", "😀"]);
                                                await updateUserCurrentStickers(
                                                    currentStickers);
                                                await installFromRemote(
                                                    currentStickers);
                                                setState(() {
                                                  sendToWpButtonText =
                                                      "Send to Whatsapp";
                                                });
                                              },
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: StarsButton(
                                        buttonText: "Generate Aother",
                                        onPressed: () {
                                          setState(() {
                                            imageLink = "";
                                          });
                                        }),
                                  )
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
