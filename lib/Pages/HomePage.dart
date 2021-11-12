import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/CustomPageRoute.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Data/Tags.dart';
import 'package:luxury_app_pre/Data/User.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen.dart';
import 'package:luxury_app_pre/Pages/Agent/AgentMain.dart';
import 'package:luxury_app_pre/Pages/Overlay/OverlayMain.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<bool> initialised;

  void changeState () {
    setState(() {
      //do nothing.
    });
  }

  @override
  void initState () {
    super.initState();
    if (utils.pageNavObj == null) {
      utils.pageNavObj = Navigator(
        key: utils.pageNav,
        initialRoute: "/home",
        onGenerateInitialRoutes: (NavigatorState navigator, String initRouteName) {
          return [navigator.widget.onGenerateRoute!(RouteSettings(name: "/"))!];
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            default:
              return CustomPageRoute(nextPage: BrowseScreen());
          }
        },
      );
    }
    initialised = utils.dataManager.getUserData();
    utils.appManager.setStateFunction(changeState);
    utils.appManager.setScreen(2);
  }

  Widget build (BuildContext context) {
    return FutureBuilder(
      future: initialised,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildFramework();
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Widget buildFramework () {
    return WillPopScope(
      onWillPop: () async {
        if (utils.appManager.overlayCont.value != 0) {
          utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
          return false;
        }
        final pop = await utils.pageNav.currentState!.maybePop();
        if (pop) {
          return false;
        }
        dispose();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        primary: true,
        backgroundColor: utils.resourceManager.colours.background,
        body: SafeArea(
          child: Stack(
            children: [
              buildBG(),
              buildPage(),
              buildAgent(),
              buildOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBG () {
    //replace with Navigator if needed.
    return Container(
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget buildPage () {
    return utils.pageNavObj!;
  }

  Widget buildAgent() {
    return AgentMain();
  }

  Widget buildOverlay () {
    return OverlayMain();
  }
}