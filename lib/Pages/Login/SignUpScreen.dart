import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Login/LoginScreen/Keyboard.dart';
import 'package:luxury_app_pre/Pages/Login/SignUpScreen/SignUpState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_app_pre/Widget/CustomPhoneNumberField.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpState state = SignUpState();
  List<String> phoneNumberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "010", "0"];
  List<String> passwordNumberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0"];
  List<String> passwordLetterKeys = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", ""];

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

  FocusNode node = FocusNode();

  TextEditingController textControl = TextEditingController();

  bool validNumber () {
    return (textControl.text.length == phoneNumberKeys.length && textControl.text.substring(0, 3) == "010");
  }

  void clearPhoneNumber () {
    setState(() {
      state.phoneNumber = "";
      textControl.clear();
    });
  }

  void appendToPhoneNumber (String number) {
    setState(() {
      state.phoneNumber = state.phoneNumber + number;
      textControl.text = textControl.text + number;
      textControl.selection = TextSelection.fromPosition(TextPosition(offset: textControl.text.length));
    });
  }

  void subtractFromPhoneNumber () {
    if (textControl.text.length > 0) {
      setState(() {
        state.phoneNumber = state.phoneNumber.substring(0, state.phoneNumber.length - 1);
        textControl.text = textControl.text.substring(0, textControl.text.length - 1);
        textControl.selection = TextSelection.fromPosition(TextPosition(offset: textControl.text.length));
      });
    }
  }

  void appendToPassword (String character) {
    setState(() {
      state.currentPassword = state.currentPassword + character;
    });
  }

  void subtractFromPassword () {
    setState(() {
      state.currentPassword = state.currentPassword.substring(0, state.currentPassword.length - 1);
    });
  }

  void setShowPassword (bool value) {
    setState(() {
      state.showPassword = value;
    });
  }

  void toggleShowPassword (){
    setShowPassword(!state.showPassword);
  }

  void toggleActivatePhoneKeyboard () {
    setState(() {
      state.phoneKeyboardActiveState = !state.phoneKeyboardActiveState;
    });
  }

  void setActivatePhoneKeyboard () {
    setState(() {
      state.phoneKeyboardActiveState = true;
    });
  }

  void setInactivatePhoneKeyboard () {
    setState(() {
      state.phoneKeyboardActiveState = false;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setInactivatePhoneKeyboard();
      },
      child: Scaffold(
        backgroundColor: utils.resourceManager.colours.background,
        body: Stack(
          children: [
            buildContent(),
            Positioned(
              top: 0,
              left: 0,
              height: 50,
              width: 50,
              child: backButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent () {
    if (state.state == 0) {
      return getPhoneNumber();
    }
    else if (state.state == 1 || state.state == 2) {
      return getPassword();
    }
    return Container();
  }


  Widget getPhoneNumber () {
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
            child: Text("전화번호 초대권 확인", style: utils.resourceManager.textStyles.base15_700),
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
            child:  Text((state.state == 1)? "OBSSENCE에서 사용할 비밀번호를 입력해 주세요." : "비밀번호를 재입력해 주세요.", style: utils.resourceManager.textStyles.base15_700),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 20),
            child: Text("숫자 4자리 + 영문자 1자리", style: utils.resourceManager.textStyles.base15),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          child: Stack(
            children: [
              CustomPhoneNumberField(textControl, "전화번호 기입", node, setActivatePhoneKeyboard),
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
          (state.currentPassword.length > 0) ? Container(width: 20, child: Text(state.currentPassword.substring(0, 1), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.currentPassword.length > 1) ? Container(width: 20, child: Text(state.currentPassword.substring(1, 2), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.currentPassword.length > 2) ? Container(width: 20, child: Text(state.currentPassword.substring(2, 3), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.currentPassword.length > 3) ? Container(width: 20, child: Text(state.currentPassword.substring(3, 4), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(),
          (state.currentPassword.length > 4) ? Container(width: 20, child: Text(state.currentPassword.substring(4, 5), style: utils.resourceManager.textStyles.base20, textAlign: TextAlign.center,)) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(
            width: 50,
          ),
        ] :
        [
          Container(
            width: 50,
          ),
          (state.currentPassword.length > 0) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.currentPassword.length > 1) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.currentPassword.length > 2) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          (state.currentPassword.length > 3) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
          Container(),
          (state.currentPassword.length > 4) ? Icon(Icons.star, color: Color(0xffffffff), size: 20) : Icon(Icons.star, color: Color(0xffbbbbbb), size: 20),
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
          CollectionReference invitations = FirebaseFirestore.instance.collection("invitations");
          if (!validNumber()) {
            utils.appManager.buildAlertDialog(context, "유효한 전화번호를 기입해 주세요.");
            return;
          }
          List emailExists = await FirebaseAuth.instance.fetchSignInMethodsForEmail(state.phoneNumber + "@obssence.com");
          if (emailExists.isNotEmpty) {
            utils.appManager.buildAlertDialog(context, "이 번호는 계정이 벌써 있습니다.");
            print("email already exists");
            return;
          }
          QuerySnapshot snapshot = await invitations.where('target', isEqualTo: state.phoneNumber).get();
          if (snapshot.docs.isEmpty) {
            utils.appManager.buildAlertDialog(context, "초대장을 받은 전화번호가 아닙니다.");
            print("no invitation");
            return;
          }
          nextState();
        },
        text: "확인",
        style: utils.resourceManager.textStyles.base14,
        h: 25,
        w: 100,
      ),
    );
  }

  Widget buildPhoneNumberButtons () {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              toggleShowPassword();
            },
            child: state.showPassword ? buildPressed(context) : buildUnpressed(context),
          ),
          Container(
            key: Key("button1"),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: CustomButton(
              whenPressed: () async {
                if (state.currentPassword.length == 5) {
                  if (state.state == 1) {
                    setShowPassword(false);
                    nextState();
                    state.finalisedPassword = state.currentPassword;
                    state.currentPassword = "";
                  } else if (state.state == 2){
                    if (state.currentPassword == state.finalisedPassword) {
                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: state.phoneNumber + "@obssence.com", password: state.currentPassword + "0");
                        if (FirebaseAuth.instance.currentUser != null) {
                          CollectionReference users = FirebaseFirestore.instance.collection('users');
                          await users.add(
                              {
                                "uid": FirebaseAuth.instance.currentUser!.uid,
                                "phoneNumber": state.phoneNumber,
                                "firstName": "Bob",
                                "lastName": "Builder",
                                "notifications": "false",
                                "invitations": 1,
                              }
                          );
                          utils.mainNav.currentState!.pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return HomePage();
                              })
                          );
                        }
                      }
                      catch (e) {
                        utils.appManager.buildAlertDialog(context, "회원가입이 실패했습니다.");
                        print(e);
                      }
                    }
                    else {
                      utils.appManager.buildAlertDialog(context, "비밀번호가 같지 않습니다.");
                    }
                  }
                }
                else {
                  utils.appManager.buildAlertDialog(context, "유효한 비밀번호를 기입해 주세요.");
                  //do nothing
                }
              },
              text: (state.state==1)? "확인" : "가입하기",
              style: utils.resourceManager.textStyles.base14,
              h: 25,
              w: 100,
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
      characterSet: (state.currentPassword.length < passwordNumNumbers)? passwordNumberKeys : passwordLetterKeys,
      textFunction: (state.currentPassword.length < passwordMaxLength)? appendToPassword : (String string){return;},
      specialFunctions: [subtractFromPassword],
      specialImageSet: [utils.resourceManager.images.backButton],
      numRows: (state.currentPassword.length < passwordNumNumbers)? passwordNumberRows : passwordLetterRows,
      numCols: (state.currentPassword.length < passwordNumNumbers)? passwordNumberCols : passwordLetterCols,
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

