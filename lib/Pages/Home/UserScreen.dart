import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class UserScreen extends StatefulWidget {

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

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
                height: 120,
                child: mainHeader(),
              ),
              CustomDivider(),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      child: mainColumn(),
                    ),
                    CustomDivider(),
                    Container(
                      height: 200,
                      child: mainFooter(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: buildOverlay(),
          ),
        ],
      ),
    );
  }

  Widget mainHeader () {
    return Column(
      children: [
        Container(
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
                      width: 30,
                    ),
                    Text(utils.dataManager.user!.firstName + "님", style: utils.resourceManager.textStyles.base16,),
                    CustomRoundButton(
                        whenPressed: () {
                          utils.appManager.toProfilePage(context, utils.pageNav);
                        },
                        image: utils.resourceManager.images.moreButton,
                        imagePressed: utils.resourceManager.images.moreButton,
                        h: 30,
                        w: 30)
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
        ),
        Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Member", style: utils.resourceManager.textStyles.baseXL,),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text("레벨", style: utils.resourceManager.textStyles.base12,),
              ),
              Container(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mainColumn () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: CustomButton(
            whenPressed: () {
              utils.appManager.toInvitationPage(context, utils.pageNav);
            },
            text: "초대권",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 200,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: CustomButton(
            whenPressed: () {
              utils.appManager.toOrderPage(context, utils.pageNav);
            },
            text: "주문 목록",
              style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 200
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: CustomButton(
            whenPressed: () {
              utils.appManager.toReturnsPage(context, utils.pageNav);
            },
            text: "취소 반품 교환 목록",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 200,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: CustomButton(
            whenPressed: () {
              utils.appManager.toBrowsePage(context, utils.pageNav);
            },
            text: "결제 수단",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 200,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
          child: CustomButton(
            whenPressed: () {
              utils.appManager.toSettingsPage(context, utils.pageNav);
            },
            text: "앱 설정",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 200
          ),
        ),
      ],
    );
  }

  Widget mainFooter () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text("1644-3333", style: utils.resourceManager.textStyles.base16,),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 2.5),
          child: Text("customer@obssence.com", style: utils.resourceManager.textStyles.base14_100U,),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 2.5),
          child: Text("10:00 - 17:00 (점심시간 12:00-1400)", style: utils.resourceManager.textStyles.base14_100,),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 2.5),
          child: Text("Day OFF (토/일/공휴일)", style: utils.resourceManager.textStyles.base14_100,),
        ),
        Container(),
      ],
    );
  }

  Widget buildOverlay () {
    return Container();
  }
}
