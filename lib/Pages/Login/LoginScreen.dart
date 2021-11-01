import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Login/LoginScreen/LoginState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luxury_app_pre/Pages/HomePage.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginState state = LoginState();
  List<String> numberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "010", "0"];
  List<String> passwordKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0"];
  List<String> letterKeys = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", ""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
      body: Stack(
        children: [
          (state.state == 0) ? getNumber() : getPassword(),
          Positioned(
            top: 0,
            left: 0,
            height: 50,
            width: 50,
            child: backButton(),
          ),
        ],
      ),
    );
  }

  Widget getNumber () {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text("전화번호 입력", style: utils.resourceManager.textStyles.base15_700),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: buildNumberField(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: buildNumberConfirm(),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: buildNumberKeyboard(),
          ),
        ],
      ),
    );
  }

  Widget getPassword () {
    return Container(
      //color: Color(0xff585653),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
            child: Text("비밀번호를 입력해 주세요.", style: utils.resourceManager.textStyles.base15_700),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
            child: Text("숫자 4자리 + 영문자 1자리", style: utils.resourceManager.textStyles.base15),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: buildPasswordField(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: buildPasswordButtons(),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: getCorrectKeyboard(),
          ),
        ],
      ),
    );
  }

  Widget buildNumberField () {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: 50,
          width: (MediaQuery.of(context).size.width < 299) ? MediaQuery.of(context).size.width - 10 : 343,
          child: Stack(
            children: [
              Container(
                child: Center(
                  child: Image.asset(utils.resourceManager.images.phoneNumberFieldInactive),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: (MediaQuery.of(context).size.width < 299) ? (MediaQuery.of(context).size.width - 10)*(81/343) : 81,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      height: 50,
                      child: Center(
                        child: Text((state.phoneNumber.length > 0) ? state.phoneNumber : "전화번호", style: (state.phoneNumber.length > 0) ? utils.resourceManager.textStyles.base13 : utils.resourceManager.textStyles.base13grey,),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: (MediaQuery.of(context).size.width < 299) ? (MediaQuery.of(context).size.width - 10)*(81/343) : 81,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("+82", style: utils.resourceManager.textStyles.base13, textAlign: TextAlign.end,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField () {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: (state.showPassword) ?
        [
          Container(
            width: 50,
          ),
          (state.password.length > 0) ? Container(width: 20, child: Text(state.password.substring(0, 1), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.password.length > 1) ? Container(width: 20, child: Text(state.password.substring(1, 2), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.password.length > 2) ? Container(width: 20, child: Text(state.password.substring(2, 3), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.password.length > 3) ? Container(width: 20, child: Text(state.password.substring(3, 4), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(),
          (state.password.length > 4) ? Container(width: 20, child: Text(state.password.substring(4, 5), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(
            width: 50,
          ),
        ] :
        [
          Container(
            width: 50,
          ),
          (state.password.length > 0) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.password.length > 1) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.password.length > 2) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.password.length > 3) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(),
          (state.password.length > 4) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(
            width: 50,
          ),
        ],
      ),
    );
  }

  Widget buildNumberConfirm () {
    return Container(
      child: CustomButton(
        whenPressed: () async {
          if (!state.validNumber()) {
            utils.appManager.buildAlertDialog(context, "유효한 전화번호를 기입해 주세요.");
            return;
          }
          List emailExists = await FirebaseAuth.instance.fetchSignInMethodsForEmail(state.phoneNumber + "@obssence.com");
          if (emailExists.isEmpty) {
            utils.appManager.buildAlertDialog(context, "이 전화번호는 계정이 없습니다.");
            print("email does not exist");
            return;
          }
          setState(() {
            state.nextState();
          });
        },
        text: "확인",
        style: utils.resourceManager.textStyles.base14,
        h: 30,
        w: 50,
      ),
    );
  }

  Widget buildPasswordButtons () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                state.togglePassword();
              });
            },
            child: state.showPassword ? buildPressed(context) : buildUnpressed(context),
          ),
          Container(
            width: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: CustomButton(
              whenPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: state.phoneNumber + "@obssence.com", password: state.password + "0");
                  if (FirebaseAuth.instance.currentUser != null) {
                    utils.mainNav.currentState!.pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return HomePage();
                      })
                    );
                  }
                }
                catch (e) {
                  utils.appManager.buildAlertDialog(context, "로그인 실패했습니다.");
                  print(e);
                }
              },
              text: "확인",
              style: utils.resourceManager.textStyles.base14,
              h: 30,
              w: 90,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumberKeyboard () {
    return Container(
      height: MediaQuery.of(context).size.width*(2/3),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: MediaQuery.of(context).size.width*(2/3)/4,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (index < 11) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  state.appendNumber(numberKeys[index]);
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.width*(2/3)/4,
                width: MediaQuery.of(context).size.width/3,
                color: utils.resourceManager.colours.almostBackground,
                child: Center(
                  child: Text(numberKeys[index], textAlign: TextAlign.center, style: utils.resourceManager.textStyles.base25,),
                ),
              ),
            );
          }
          else {
            return GestureDetector(
              onTap: () {
                setState(() {
                  state.subtractNumber();
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.width*(2/3)/4,
                width: MediaQuery.of(context).size.width/3,
                color: utils.resourceManager.colours.almostBackground,
                child: Center(
                  child: Container(
                    height: 20,
                    child: Image.asset(utils.resourceManager.images.backButton),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget getCorrectKeyboard () {
    if (state.password.length < 4) {
      return buildPasswordKeyboard();
    }
    if (state.password.length == 4 || state.password.length == 5) {
      return buildLetterKeyboard();
    }
    else {
      return Container(
        height: 400,
      );
    }
  }

  Widget buildPasswordKeyboard () {
    return Container(
      height: MediaQuery.of(context).size.width*(2/3),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: MediaQuery.of(context).size.width*(2/3)/4,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (index < 11) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  state.appendPassword(passwordKeys[index]);
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.width*(2/3)/4,
                width: MediaQuery.of(context).size.width/3,
                color: utils.resourceManager.colours.almostBackground,
                child: Center(
                  child: Text(passwordKeys[index], textAlign: TextAlign.center, style: utils.resourceManager.textStyles.base25,),
                ),
              ),
            );
          }
          else {
            return GestureDetector(
              onTap: () {
                setState(() {
                  state.subtractPassword();
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.width*(2/3)/4,
                width: MediaQuery.of(context).size.width/3,
                color: utils.resourceManager.colours.almostBackground,
                child: Center(
                  child: Container(
                    height: 20,
                    child: Image.asset(utils.resourceManager.images.backButton),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildLetterKeyboard () {
    return Container(
      height: MediaQuery.of(context).size.width*(2/3),
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: MediaQuery.of(context).size.width*(2/3)/4,
        ),
        itemCount: 28,
        itemBuilder: (context, index) {
          if (index < 27) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  state.appendPassword(letterKeys[index]);
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.width*(2/3)/4,
                width: MediaQuery.of(context).size.width/7,
                color: utils.resourceManager.colours.almostBackground,
                child: Center(
                  child: Text(letterKeys[index], textAlign: TextAlign.center, style: utils.resourceManager.textStyles.base25,),
                ),
              ),
            );
          }
          else {
            return GestureDetector(
              onTap: () {
                setState(() {
                  state.subtractPassword();
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.width*(2/3)/4,
                width: MediaQuery.of(context).size.width/7,
                color: utils.resourceManager.colours.almostBackground,
                child: Center(
                  child: Container(
                    height: 20,
                    child: Image.asset(utils.resourceManager.images.backButton),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildUnpressed (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 30,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: utils.resourceManager.colours.background,
        boxShadow: [
          BoxShadow(
            color: utils.resourceManager.colours.shadowDark,
            offset: Offset(6, 2),
            blurRadius: 8,
          ),
          BoxShadow(
            color: utils.resourceManager.colours.shadowLight,
            offset: Offset(-3, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRect(
        child:  BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
          child: Container(
            height: 30,
            width: 90,
            child: Center(
              child: Text("입력값 보기", style: utils.resourceManager.textStyles.base14),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPressed (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 30,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.5),
        color: utils.resourceManager.colours.background,
        gradient: LinearGradient(
          begin: Alignment(-0.02, -4),
          end: Alignment(0.02, 4),
          colors: [
            utils.resourceManager.colours.shadowDark,
            utils.resourceManager.colours.background,
            utils.resourceManager.colours.shadowLight,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: utils.resourceManager.colours.background,
            spreadRadius: -20,
            offset: Offset(-10, -5),
          ),
        ],
      ),
      child: ClipRect(
        child:  BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
          child: Container(
            height: 30,
            width: 90,
            child: Center(
              child: Text("입력값 보기", style: utils.resourceManager.textStyles.base14),
            ),
          ),
        ),
      ),
    );
  }

  Widget backButton () {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: CustomRoundButton(
        whenPressed: () {
          utils.appManager.previousPage(utils.loginNav);
        },
        image: utils.resourceManager.images.backButton,
        imagePressed: utils.resourceManager.images.backButton,
        h: 40,
        w: 40,
      ),
    );
  }
}
