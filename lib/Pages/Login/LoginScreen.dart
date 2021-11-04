import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/CustomPageRoute.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Login/LoginScreen/Keyboard.dart';
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
  static List<String> phoneNumberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "010", "0"];
  static List<String> passwordNumberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0"];
  static List<String> passwordLetterKeys = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", ""];

  static int phoneNumberRows = 4;
  static int phoneNumberCols = 3;

  static int passwordNumberRows = 4;
  static int passwordNumberCols = 3;

  static int passwordLetterRows = 4;
  static int passwordLetterCols = 7;

  final int phoneNumberMaxLength = 11;
  final int passwordNumNumbers = 4;
  final int passwordMaxLength = 5;

  final double keyboardWidthHeightRatio = 2/3;

  LoginState state = LoginState();

  bool validNumber () {
    return (state.phoneNumber.length == phoneNumberKeys.length && state.phoneNumber.substring(0, 3) == "010");
  }

  void clearPhoneNumber () {
    setState(() {
      state.phoneNumber = "";
    });
  }

  void appendToPhoneNumber (String number) {
    setState(() {
      state.phoneNumber = state.phoneNumber + number;
    });
  }

  void subtractFromPhoneNumber () {
    setState(() {
      state.phoneNumber = state.phoneNumber.substring(0, state.phoneNumber.length - 1);
    });
  }

  void appendToPassword (String character) {
    setState(() {
      state.password = state.password + character;
    });
  }

  void subtractFromPassword () {
    setState(() {
      state.password = state.password.substring(0, state.password.length - 1);
    });
  }

  void toggleShowPassword () {
    setState(() {
      state.showPassword = !state.showPassword;
    });
  }

  void toggleActivatePhoneKeyboard () {
    setState(() {
      state.phoneKeyboardActiveState = !state.phoneKeyboardActiveState;
    });
  }

  void setPhoneNumberError(bool value) {
    setState(() {
      state.phoneNumberError = value;
    });
  }

  void nextState () {
    setState(() {
      state.state++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
      body: Stack(
        children: [
          (state.state == 0) ? getPhoneNumber() : getPassword(),
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


  Widget getPhoneNumber () {
    return Container(
      child: Column(
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
            child: buildPhoneNumberTextField(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: buildPhoneNumberButtons(),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 150),
              firstChild: buildPhoneNumberKeyboard(),
              secondChild: Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.width * keyboardWidthHeightRatio),
              crossFadeState: state.phoneKeyboardActiveState ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            )
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
            child: buildPasswordTextField(),
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
            child: buildPasswordKeyboard(),
          ),
        ],
      ),
    );
  }


  Widget buildPhoneNumberTextField () {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: 50,
          width: (MediaQuery.of(context).size.width < 299) ? MediaQuery.of(context).size.width - 10 : 343,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    toggleActivatePhoneKeyboard();
                    setPhoneNumberError(false);
                  });
                },
                child: Container(
                  child: Center(
                    child: Image.asset(utils.resourceManager.images.phoneNumberFieldInactive),
                  ),
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
                        child: IgnorePointer(
                          ignoring:true,
                          child: Text((state.phoneNumber.length > 0) ? state.phoneNumber : "전화번호", style: (state.phoneNumberError)? utils.resourceManager.textStyles.base13Red : ((state.phoneNumber.length > 0) ? utils.resourceManager.textStyles.base13 : utils.resourceManager.textStyles.base13grey)),
                        ),
                      ),
                    )
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
                        child: IgnorePointer(
                          ignoring:true,
                          child: Text("+82", style: utils.resourceManager.textStyles.base13, textAlign: TextAlign.end,),
                        ),
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

  Widget buildPasswordTextField () {
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


  Widget buildPhoneNumberConfirmButton () {
    return Container(
      child: CustomButton(
        whenPressed: () async {
          if (!validNumber()) {
            utils.appManager.buildAlertDialog(context, "유효한 전화번호를 기입해 주세요.");
            setState(() {
              setPhoneNumberError(true);
            });
            return;
          }
          List emailExists = await FirebaseAuth.instance.fetchSignInMethodsForEmail(state.phoneNumber + "@obssence.com");
          if (emailExists.isEmpty) {
            utils.appManager.buildAlertDialog(context, "이 전화번호는 계정이 없습니다.");
            print("email does not exist");
            return;
          }
          setState(() {
            nextState();
            setPhoneNumberError(false);
          });
        },
        text: "확인",
        style: utils.resourceManager.textStyles.base14,
        h: 30,
        w: 50,
      ),
    );
  }

  Widget buildPhoneNumberClearButton () {
    return Container(
      child: CustomButton(
        whenPressed: () async {
          setState(() {
            clearPhoneNumber();
            setPhoneNumberError(false);
          });
        },
        text: "Clear",
        style: utils.resourceManager.textStyles.base14,
        h: 30,
        w: 50,
      ),
    );
  }

  Widget buildPhoneNumberButtons () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildPhoneNumberClearButton(),
          Container(
            width: 20,
          ),
          buildPhoneNumberConfirmButton(),
        ]
      )
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
                toggleShowPassword();
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
                      CustomPageRoute(nextPage: HomePage()),
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


  Widget buildPhoneNumberKeyboard () {
    return Keyboard(
      characterSet: phoneNumberKeys,
      textFunction: (state.phoneKeyboardActiveState && state.phoneNumber.length < phoneNumberMaxLength)? appendToPhoneNumber : (String string){return;},
      specialFunctions: [subtractFromPhoneNumber],
      specialImageSet: [utils.resourceManager.images.backButton],
      numRows: phoneNumberRows,
      numCols: phoneNumberCols,
      style: utils.resourceManager.textStyles.base25,
    );
  }

  Widget buildPasswordKeyboard () {
    return Keyboard(
      characterSet: (state.password.length < passwordNumNumbers)? passwordNumberKeys : passwordLetterKeys,
      textFunction: (state.password.length < passwordMaxLength)? appendToPassword : (String string){return;},
      specialFunctions: [subtractFromPassword],
      specialImageSet: [utils.resourceManager.images.backButton],
      numRows: (state.password.length < passwordNumNumbers)? passwordNumberRows : passwordLetterRows,
      numCols: (state.password.length < passwordNumNumbers)? passwordNumberCols : passwordLetterCols,
      style: utils.resourceManager.textStyles.base25,
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