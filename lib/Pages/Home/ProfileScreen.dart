import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build (BuildContext context) {
    return buildScaffold();
  }

  Widget buildScaffold () {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                child: mainHeader(),
              ),
              //CustomThinDivider(),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    mainColumn(),
                  ],
                ),
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
                Text("회원정보수정", style: utils.resourceManager.textStyles.base15_700,),
                //plus button
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            width: 50,
            height: 50,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Text("회원 정보", style: utils.resourceManager.textStyles.base14_700,),
          ),
          CustomDividerShort(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("성명", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(utils.dataManager.user!.firstName + " " + utils.dataManager.user!.lastName, style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("생년월일", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text("2000년 5월 9일", style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("연락처", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(utils.dataManager.user!.phoneNumber, style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              whenPressed: () {

              },
              text: "본인인증으로 정보 수정하기",
              style: utils.resourceManager.textStyles.base14,
              w: 200,
              h: 30,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("이메일", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text(utils.dataManager.user!.email, style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("주소", style: utils.resourceManager.textStyles.base12,),
                ),
                Expanded(
                  child: Text(utils.dataManager.user!.address, style: utils.resourceManager.textStyles.base12, textAlign: TextAlign.start,),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Text("마케팅 정보 수신 및 활동 동의", style: utils.resourceManager.textStyles.base14_700,),
          ),
          CustomDividerShort(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        CollectionReference users = FirebaseFirestore.instance.collection('users');
                        String temp = "";
                        if (utils.dataManager.user!.notifications == "true") {
                          temp = "false";
                        }
                        else {
                          temp = "true";
                        }
                        users.doc(utils.dataManager.user!.id).update(
                            {
                              'notifications': temp,
                            }
                        );
                        //do something
                        setState(() {
                          utils.dataManager.user!.toggleNotifications();
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Stack(
                          children: [
                            buttonPressed(),
                            Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset(utils.resourceManager.images.downButton),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text("문자메시지", style: utils.resourceManager.textStyles.base13,),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        CollectionReference users = FirebaseFirestore.instance.collection('users');
                        String temp = "";
                        if (utils.dataManager.user!.notifications == "true") {
                          temp = "false";
                        }
                        else {
                          temp = "true";
                        }
                        users.doc(utils.dataManager.user!.id).update(
                            {
                              'notifications': temp,
                            }
                        );
                        //do something
                        setState(() {
                          utils.dataManager.user!.toggleNotifications();
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Stack(
                          children: [
                            buttonPressed(),
                            Center(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Image.asset(utils.resourceManager.images.downButton),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text("문자메시지", style: utils.resourceManager.textStyles.base13,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("""서비스의 중요 안내사항 및 서비스에 대한 정보는 위 수신 여부와 관계없이 발송됩니다. \n앱 풋시 알림은 OBSSENCE Club 앱 로그인 > My > 설정 > 쇼핑알림 에서 아림을 끌 수 있습니다.""", style: utils.resourceManager.textStyles.base12_100,),
          ),
          Container(
            height: 40,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Text("멤버십 설정", style: utils.resourceManager.textStyles.base14_700,),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("가입일", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text("2021.11.03", style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("유료 전환일", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text("2021.11.03", style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  child: Text("다음 결재일", style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Text("2021.11.03", style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
          CustomDividerShort(),Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child: CustomButton(
                whenPressed: () async {
                  bool state;
                  state = await utils.appManager.buildActionDialog(context, "멤버십을 취소 하시겠습니까?", "네", "아니오", f1: (context) {},);
                  if (state) {
                    state = await utils.appManager.buildActionDialog(context, "멤버십을 취소 하시겠습니까?", "네", "아니오", f1: (context) {},);
                    if (state) {
                      //go to survey page
                    }
                  }
                },
                text: "멤버십 취소",
                style: utils.resourceManager.textStyles.base14,
                w: 100,
                h: 30,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child: CustomButton(
                whenPressed: () async {
                  await utils.appManager.buildActionDialog(context, "로그아웃 하시겠습니까?", "네", "아니오", f1: (context) {FirebaseAuth.instance.signOut(); utils.appManager.logOutNav(utils.mainNav);},);
                },
                text: "로그아웃",
                style: utils.resourceManager.textStyles.base14,
                w: 80,
                h: 30,
              ),
            ),
          ),
          Container(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget buttonPressed () {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: (utils.dataManager.user!.notifications == "true") ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
        ),
      ),
    );
  }
}
