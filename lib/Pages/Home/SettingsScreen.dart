import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
                Text("앱 설정", style: utils.resourceManager.textStyles.base15_700,),
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
            child: Text("알림", style: utils.resourceManager.textStyles.base14_700),
          ),
          CustomDividerShort(),
          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  width: MediaQuery.of(context).size.width - 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("새로운 상품 알림", style: utils.resourceManager.textStyles.base12_700),
                      ),
                      Container(
                        height: 5,
                      ),
                      Container(
                        child: Text("새로 올라오는 상품에 대한 정보를 빠르게 전달 받으실 수 있습니다.", style: utils.resourceManager.textStyles.base12_100),
                      ),
                    ],
                  ),
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
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Text("그 외", style: utils.resourceManager.textStyles.base14_700),
          ),
          CustomDividerShort(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("v0.0.1", style: utils.resourceManager.textStyles.base12_700),
                Text("최신버전입니다", style: utils.resourceManager.textStyles.base12_100),
              ],
            ),
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
