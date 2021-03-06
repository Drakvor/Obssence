import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Data/Brand.dart';
import 'package:luxury_app_pre/Management/CustomPageRoute.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/BrandScreen.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Pages/Home/ExitSurveyScreen.dart';
import 'package:luxury_app_pre/Pages/Home/ImageScreen.dart';
import 'package:luxury_app_pre/Pages/Home/InvitationScreen.dart';
import 'package:luxury_app_pre/Pages/Home/ItemScreen.dart';
import 'package:luxury_app_pre/Pages/Home/OrderDetailsScreen.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen.dart';
import 'package:luxury_app_pre/Pages/Home/OrderScreen.dart';
import 'package:luxury_app_pre/Pages/Home/PaymentScreen.dart';
import 'package:luxury_app_pre/Pages/Home/PostPaymentScreen.dart';
import 'package:luxury_app_pre/Pages/Home/ProcessPaymentsScreen.dart';
import 'package:luxury_app_pre/Pages/Home/ProfileScreen.dart';
import 'package:luxury_app_pre/Pages/Home/ReturnsScreen.dart';
import 'package:luxury_app_pre/Pages/Home/SearchResultsScreen.dart';
import 'package:luxury_app_pre/Pages/Home/SearchScreen.dart';
import 'package:luxury_app_pre/Pages/Home/SettingsScreen.dart';
import 'dart:io';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen.dart';
import 'package:luxury_app_pre/Pages/Home/TermsConditionsScreen.dart';
import 'package:luxury_app_pre/Pages/Home/TestPage.dart';
import 'package:luxury_app_pre/Pages/Home/UserScreen.dart';
import 'package:luxury_app_pre/Pages/Login/LoginScreen.dart';
import 'package:luxury_app_pre/Pages/Login/SignUpScreen.dart';
import 'package:luxury_app_pre/Pages/LoginPage.dart';

class AppManager {
  bool appOpened = false;
  bool loadCart = true;
  Function changeState;
  Function? loadOverlay;
  int currentScreen = 0; //0: inactive, 1: login, 2:home
  TextEditingController searchControl = new TextEditingController();
  late AnimationController overlayCont;

  bool loggedIn = false;
  bool agentOn = false;

  AppManager(this.changeState);

  void setStateFunction (Function f) {
    changeState = f;
  }

  void setLoggedIn () {
    loggedIn = true;
  }

  void setLoggedOut () {
    loggedIn = false;
  }

  void setScreen (int data) {
    currentScreen = data;
  }

  void setAppOpened () {
    appOpened = true;
  }

  void setLoadCartToTrue () {
    loadCart = true;
  }

  void setLoadCartToFalse () {
    loadCart = false;
  }

  void toBrowsePage (BuildContext context, GlobalKey<NavigatorState> nav, {List<String>? tags}) {
    print("why");
    if (tags != null) {
      utils.agentManager.setSearchTags(tags);
    }
    nav.currentState!.push(
      CustomPageRoute(nextPage: BrowseScreen()),
    );
    changeState();
  }

  void toSearchPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: SearchScreen()),
    );
  }

  void toSearchResultsPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: SearchResultsScreen()),
    );
  }

  void toItemPage (BuildContext context, GlobalKey<NavigatorState> nav, ItemData data, List<File> images, {bool editing=false}) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: ItemScreen(data, images, editing: editing,)),
    );
  }

  void toImagePage (BuildContext context, GlobalKey<NavigatorState> nav, File image) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: ImageScreen(image)),
    );
  }

  void toBrandPage (BuildContext context, GlobalKey<NavigatorState> nav, Brand brand) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: BrandScreen(brand)),
    );
  }

  void toUserPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: UserScreen()),
    );
  }

  void toProfilePage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: ProfileScreen()),
    );
  }

  void toExitSurveyPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: ExitSurveyScreen()),
    );
  }

  void toShoppingPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    loadCart = true;
    nav.currentState!.push(
      CustomPageRoute(nextPage: ShoppingScreen()),
    );
  }

  void toPaymentPage (BuildContext context, GlobalKey<NavigatorState> nav, double price, double discount) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: PaymentScreen(price, discount)),
    );
  }

  void toProcessPaymentsPage (BuildContext context, GlobalKey<NavigatorState> nav, String method) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: ProcessPaymentsScreen(method)),
    );
  }

  void toPostPaymentPage (BuildContext context, GlobalKey<NavigatorState> nav, Map<String, String> results) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: PostPaymentScreen(results)),
    );
  }

  void toInvitationPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: InvitationScreen()),
    );
  }

  void toOrderPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: OrderScreen()),
    );
  }

  void toOrderEditPage (BuildContext context, GlobalKey<NavigatorState> nav, OrderData order) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: OrderEditScreen(order)),
    );
  }
  
  void toOrderDetailsPage (BuildContext context, GlobalKey<NavigatorState> nav, OrderData order) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: OrderDetailsScreen(order)),
    );
  }

  void toReturnsPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: ReturnsScreen()),
    );
  }

  void toSettingsPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: SettingsScreen()),
    );
  }

  void toTermsConditionsPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: TermsConditionsScreen()),
    );
  }

  void toTestPage (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
        MaterialPageRoute(builder: (context) {
          return TestPage();
        })
    );
  }

  void toSignUpScreen (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: SignUpScreen()),
    );
  }

  void toLoginScreen (BuildContext context, GlobalKey<NavigatorState> nav) {
    nav.currentState!.push(
      CustomPageRoute(nextPage: LoginScreen()),
    );
  }

  void previousPage (GlobalKey<NavigatorState> nav) {
    nav.currentState!.pop();
  }

  void logOutNav (GlobalKey<NavigatorState> nav) {
    nav.currentState!.pushReplacement(
      CustomPageRoute(nextPage: LoginPage()),
    );
  }
  Future<void> buildAlertDialog (BuildContext context, String text) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            child: Text(text),
          ),
        );
      },
    );
  }

  Future<bool> buildActionDialog (BuildContext context, String text, String action1, String action2, {Function? f1, Function? f2}) async {
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Container(
            child: Text(text, style: utils.resourceManager.textStyles.base12,),
          ),
          actions: [
            CupertinoDialogAction(
              textStyle: utils.resourceManager.textStyles.base12black,
              onPressed: () {
                if (f1 == null) {
                  Navigator.of(context).pop(true);
                  return;
                }
                f1();
                Navigator.of(context).pop(true);
                return;
              },
              child: Text(action1, style: utils.resourceManager.textStyles.base12black),
            ),
            CupertinoDialogAction(
              textStyle: utils.resourceManager.textStyles.base12black,
              onPressed: () {
                if (f2 == null) {
                  Navigator.of(context).pop(false);
                  return;
                }
                f2();
                Navigator.of(context).pop(false);
                return;
              },
              child: Text(action2, style: utils.resourceManager.textStyles.base12black),
            ),
          ],
        );
      }
    );
  }
}