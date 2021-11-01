import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iamport_flutter/Iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:dio/dio.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luxury_app_pre/Pages/HomePage.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:luxury_app_pre/Pages/LoginPage.dart';
import 'package:luxury_app_pre/main.mapper.g.dart';

void main() {
  initializeJsonMapper();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: utils.mainNav,
      title: 'Luxury App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: LandingPage(utils),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            utils.setPadding(MediaQuery.of(context).size.height, MediaQuery.of(context).padding.top, MediaQuery.of(context).padding.bottom);
            User? appUser = FirebaseAuth.instance.currentUser;
            if (appUser == null) {
              return LoginPage();
            }
            else {
              return HomePage();
            }
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    utils.setPadding(MediaQuery.of(context).size.height, MediaQuery.of(context).padding.top, MediaQuery.of(context).padding.bottom);

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        else if (snapshot.connectionState == ConnectionState.done) {
          User? appUser = FirebaseAuth.instance.currentUser;
          if (appUser == null) {
            return LoginPage();
          }
          else {
            return HomePage();
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class InitialPage extends StatelessWidget {
  final TextEditingController control = new TextEditingController();
  final AudioPlayer audio = new AudioPlayer();

  void testServer () async {
    try {
      String text = "일등 축하해요 ";
      var res = await Dio().get('http://211.40.224.20:8090/audio/lol/$text');
      print(res);
      testAudio();
    }
    catch (e) {
      print(e);
    }
  }

  void testAudio () async {
    await audio.setUrl('http://211.40.224.20:8080/api/audio/lol');
    audio.setVolume(100);
    audio.play();
  }

  @override
  
  Widget build (BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: control,
          ),
          TextButton(
            onPressed: () {
              testServer();
            },
            child: Text("Test")
          ),
        ],
      ),
    );
  }
}

class Certify extends StatelessWidget {

  @override
  Widget build (BuildContext context) {
    return IamportCertification(
      userCode: 'imp00579348',
      data: CertificationData(
        name: '권가람',
        phone: '01065809860',
        carrier: 'MVNO',
        company: 'Luxury',
        merchantUid: 'mid_${DateTime.now().millisecondsSinceEpoch}',
        minAge: 16,
      ),
      callback: (result) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) {
                  print(result);
                  return LandingPage();
                }
            )
        );
      }
    );
  }
}
