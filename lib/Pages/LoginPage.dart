import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Login/WelcomeScreen.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void changeState () {
    setState(() {
      //do nothing
    });
  }

  @override
  void initState () {
    super.initState();
    utils.appManager.setStateFunction(changeState);
    utils.appManager.setScreen(1);
  }

  Widget build(BuildContext context) {
    return buildFramework();
  }

  Widget buildFramework () {
    return WillPopScope(
      onWillPop: () async {
        final pop = await utils.loginNav.currentState!.maybePop();
        if (pop) {
          return false;
        }
        dispose();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          primary: true,
          backgroundColor: utils.resourceManager.colours.background,
          body: Stack(
            children: [
              buildBG(),
              buildPage(),
              buildAgent(),
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
    return Navigator(
      key: utils.loginNav,
      initialRoute: "/welcome",
      onGenerateInitialRoutes: (NavigatorState navigator, String initRouteName) {
        return [navigator.widget.onGenerateRoute!(RouteSettings(name: "/"))!];
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          default:
            return MaterialPageRoute(builder: (context) {
              return WelcomeScreen();
            });
        }
      },
    );
  }

  Widget buildAgent() {
    return Container();
  }
}
