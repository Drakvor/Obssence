import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/InvitationScreen/InvitationScreenState.dart';
import 'package:luxury_app_pre/Pages/Login/LoginScreen/Keyboard.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomPhoneNumberField.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'dart:io';

class InvitationScreen extends StatefulWidget {

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  InvitationScreenState state = InvitationScreenState();
  static List<String> phoneNumberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "010", "0"];

  static int phoneNumberRows = 4;
  static int phoneNumberCols = 3;

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
            Column(
              children: [
                Container(
                  child: mainHeader(),
                ),
                Expanded(
                  child: mainColumn(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainHeader () {
    return Container(
      height: 50,
      child: Stack(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text("초대권: ", style: utils.resourceManager.textStyles.base15_700,),
                ),
                Container(
                  child: Text(utils.dataManager.user!.invitations.toString(), style: utils.resourceManager.textStyles.dots15,),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            height: 50,
            width: 50,
            child: CustomRoundButton(
              whenPressed: () {
                utils.appManager.previousPage(utils.pageNav);
              },
              image: utils.resourceManager.images.backButton,
              imagePressed: utils.resourceManager.images.backButton,
              h: 50,
              w: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget mainColumn () {
    return Container(
      child: Column(
        children: [
          CustomThinDivider(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("저희 서비스의 혜택을 함께 누리고 싶은 분은 초대하여 특별한 서비스를 함께 누리는 것은 어때요? 아래 전화번호를 직접 기입하시거나, 주소록에 등록되어있는 분을 초대해요.", style: utils.resourceManager.textStyles.base12,),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: buildNumberField(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  whenPressed: () async {
                    PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
                    setState(() {
                      state.setNumber(contact.phoneNumber?.number?.replaceAll(new RegExp(r'[^0-9]'), '') ?? "");
                      textControl.text = contact.phoneNumber?.number?.replaceAll(new RegExp(r'[^0-9]'), '') ?? "";
                    });
                  },
                  text: "주소록에서 불러오기",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 150,
                ),
                Container(
                  width: 20,
                ),
                CustomButton(
                  whenPressed: () async {
                    CollectionReference invitations = FirebaseFirestore.instance.collection('invitations');
                    invitations.add(
                      {
                        "date": DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day,
                        "sender": utils.dataManager.user!.id,
                        "target": textControl.text,
                      }
                    );
                    if (Platform.isAndroid) {
                      await launch("sms:${textControl.text}?body=OBSSENCE 초대권이 있어서 초대해요. 귀빈 전용 서비스라 반드시 전화번호로만 가입이 가능해요. 링크입니다!");
                    }
                    if (Platform.isIOS) {
                      await launch("sms:${textControl.text};body=OBSSENCE 초대권이 있어서 초대해요. 귀빈 전용 서비스라 반드시 전화번호로만 가입이 가능해요. 링크입니다!");
                    }
                  },
                  text: "초대권 보내기",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 150,
                ),
              ],
            ),
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

  Widget buildNumberField () {
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

  Widget buildPhoneNumberKeyboard () {
    return Keyboard(
      characterSet: phoneNumberKeys,
      textFunction: appendToPhoneNumber,
      specialFunctions: [subtractFromPhoneNumber],
      specialImageSet: [utils.resourceManager.images.backButton],
      numRows: phoneNumberRows,
      numCols: phoneNumberCols,
      style: utils.resourceManager.textStyles.base25,
    );
  }
}
