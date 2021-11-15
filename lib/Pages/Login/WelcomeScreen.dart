import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Pages/HomePage.dart';
import 'package:luxury_app_pre/Widget/CustomPhoneNumberField.dart';

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTitle(context),
              buildWelcomeText(),
              buildButtons(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitle (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text("OBSSENCE", style: utils.resourceManager.textStyles.dots24,),
      ),
    );
  }

  Widget buildWelcomeText () {
    return Container(
      margin: EdgeInsets.fromLTRB(50, 20, 50, 20),
      child: Text("어서오세요! 반갑습니다. :) \n \n저희는 선별된 귀분들을 위한 패션 큐레이션 플랫폼 OBSSENCE 입니다. \n세상 어디에도 없는 저희만의 명품 서비스를 총해 더욱 더 차별화된 삶을 누리실 수 있도록 도와드리고 있습니다.",
        style: utils.resourceManager.textStyles.base16,
        strutStyle: StrutStyle(forceStrutHeight: true, height: 1.8),
      ),
    );
  }

  Widget buildButtons (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            whenPressed: () {
              utils.appManager.toSignUpScreen(context, utils.loginNav);
            },
            text: "초대권 확인하고 가입하기",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 180,
          ),
          Container(
            height: 10,
          ),
          CustomButton(
            whenPressed: () {
              utils.appManager.toLoginScreen(context, utils.loginNav);
            },
            text: "기존회원 로그인하기",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 150,
          ),
          Container(
            height: 10,
          ),
          CustomButton(
            whenPressed: () {
              //utils.appManager.toLoginScreen(context, utils.loginNav);
              utils.mainNav.currentState!.pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  })
              );
            },
            text: "서비스 둘러보기",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 130,
          ),
        ],
      ),
    );
  }
}
