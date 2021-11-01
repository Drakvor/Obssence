import 'package:flutter/material.dart';
import 'package:luxury_app_pre/Management/AgentManager.dart';
import 'package:luxury_app_pre/Management/AppManager.dart';
import 'package:luxury_app_pre/Management/DataManager.dart';
import 'package:luxury_app_pre/Management/ResourceManager.dart';

class Utils {
  GlobalKey<NavigatorState> mainNav = GlobalKey();
  GlobalKey<NavigatorState> bgNav = GlobalKey();
  GlobalKey<NavigatorState> pageNav = GlobalKey();
  GlobalKey<NavigatorState> agentNav = GlobalKey();
  GlobalKey<NavigatorState> loginNav = GlobalKey();
  Navigator? mainNavObj;
  Navigator? bgNavObg;
  Navigator? pageNavObj;
  Navigator? agenNavObj;
  Navigator? loginNavObj;

  double screenHeight;
  double topPadding;
  double bottomPadding;
  double totalPadding;
  Utils({this.screenHeight=0, this.topPadding=0, this.bottomPadding=0, this.totalPadding=0});

  AppManager appManager = new AppManager(() {});
  DataManager dataManager = new DataManager();
  AgentManager agentManager = new AgentManager();
  ResourceManager resourceManager = new ResourceManager();

  void setPadding(double height, double top, double bot) {
    screenHeight = height;
    topPadding = top;
    bottomPadding = bot;
    totalPadding = top + bot;
  }
}

Utils utils = Utils();