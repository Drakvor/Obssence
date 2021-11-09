import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/InvitationScreen/InvitationScreenState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
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
  List<String> numberKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "010", "0"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "target": state.phoneNumber,
                      }
                    );
                    if (Platform.isAndroid) {
                      await launch("sms:${state.phoneNumber}?body=OBSSENCE 초대권이 있어서 초대해요. 귀빈 전용 서비스라 반드시 전화번호로만 가입이 가능해요. 링크입니다!");
                    }
                    if (Platform.isIOS) {
                      await launch("sms:${state.phoneNumber};body=OBSSENCE 초대권이 있어서 초대해요. 귀빈 전용 서비스라 반드시 전화번호로만 가입이 가능해요. 링크입니다!");
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
            child: buildNumberKeyboard(),
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
                  child: Image.asset(utils.resourceManager.images.phoneNumberField),
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
                        child: Text("+82", textAlign: TextAlign.end,),
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
                  child: Text(numberKeys[index], textAlign: TextAlign.center, style: utils.resourceManager.textStyles.dots20,),
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
}
