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
                Text(utils.dataManager.user!.firstName + " " + utils.dataManager.user!.lastName, style: utils.resourceManager.textStyles.base12,),
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
                Text("2000년 5월 9일", style: utils.resourceManager.textStyles.base12,),
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
                Text(utils.dataManager.user!.phoneNumber, style: utils.resourceManager.textStyles.base12,),
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
                  child: Text("이메일", style: utils.resourceManager.textStyles.base12,),
                ),
                Text(utils.dataManager.user!.email, style: utils.resourceManager.textStyles.base12,),
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
                  child: Text(utils.dataManager.user!.address, style: utils.resourceManager.textStyles.base12, textAlign: TextAlign.end,),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Text("멤버십 설정", style: utils.resourceManager.textStyles.base14_700,),
          ),
          CustomDividerShort(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child: CustomButton(
                whenPressed: () {
                  FirebaseAuth.instance.signOut();
                  utils.appManager.logOutNav(utils.mainNav);
                },
                text: "로그아웃",
                style: utils.resourceManager.textStyles.base14,
                w: 80,
                h: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
