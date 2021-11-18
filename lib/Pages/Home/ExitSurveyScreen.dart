import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/ExitSurveyScreen/SurveyState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:luxury_app_pre/Widget/CustomSearchBar.dart';

class ExitSurveyScreen extends StatefulWidget {

  @override
  _ExitSurveyScreenState createState() => _ExitSurveyScreenState();
}

class _ExitSurveyScreenState extends State<ExitSurveyScreen> {
  SurveyState state = SurveyState();
  final TextEditingController textControl = new TextEditingController();
  _ExitSurveyScreenState();

  Map<String, List<String>> reasons = {
    "상품 및 브랜드 문제": ["원하는 브랜드 및 상품이 없습니다.", "상품의 종류가 다양하지 않습니다.", "내게 맞는 사이즈가 없습니다."],
    "앱 사용성 문제": ["글씨 및 이미지가 잘 보이지 않습니다.", "앱이 너무 복잡해서 사용하기 힘듭니다.", "앱 디자인이 고급지지 않습니다."],
    "서비스 문제": ["가품일까 걱정 됩니다.", "회원비 대비 혜택이 좋지 않습니다.", "가격이 비씹니다."],
    "기타": ["그 외 코멘트"],
  };
  List<String> reasonsIndex = ["상품 및 브랜드 문제", "앱 사용성 문제", "서비스 문제", "기타"];

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: utils.resourceManager.colours.background,
        body: buildMain(),
      ),
    );
  }

  Widget buildMain() {
    return Column(
      children: [
        Container(
          child: buildHeader(),
        ),
        CustomDivider(),
        Expanded(
            child: buildList()
        ),
        CustomDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: CustomButton(
            whenPressed: () async {
              CollectionReference feedbackRef = FirebaseFirestore.instance.collection('feedback');

              await feedbackRef.add({
                "user": utils.dataManager.user!.id,
                "reason": state.reason,
                "customReason": textControl.text,
              });

              utils.appManager.toProfilePage(context, utils.pageNav);
            },
            text: "보다 나은 서비스를 위한 제한",
            style: utils.resourceManager.textStyles.base14,
            w: 260,
            h: 30,
          ),
        ),
      ],
    );
  }

  Widget buildHeader () {
    return Column(
      children: [
        Container(
          height: 50,
          child: Stack(
            children: [
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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          height: 70,
          child: Text("새라님의 피드백은 저희가 더 나은 서비스를 제공하기 위해 매우 중요합니다. 소중한 의견 반드시 서비스에 반영도록 하겠습니다.  어떤 문제가 있었나요?", style: utils.resourceManager.textStyles.base14_700,),
        ),
      ],
    );
  }

  Widget buildList () {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: reasonsIndex.length + 1,
        itemBuilder: (context, index) {
          if (index == reasonsIndex.length) {
            return buildTextField();
          }
          return Column(
            children: getReasons(index),
          );
        }
    );
  }

  List<Widget> getReasons (int index) {
    List<Widget> reasonBlocks = [];
    reasonBlocks.add(
      Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Text(reasonsIndex[index], style: utils.resourceManager.textStyles.base12_100,),
      ),
    );
    for (int i = 0; i < reasons[reasonsIndex[index]]!.length; i++) {
      reasonBlocks.add(
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(reasons[reasonsIndex[index]]![i], style: utils.resourceManager.textStyles.base14,),
              Container(
                height: 50,
                width: 50,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (state.reason.contains(reasons[reasonsIndex[index]]![i])) {
                          state.removeReason(reasons[reasonsIndex[index]]![i]);
                        }
                        else {
                          state.addReason(reasons[reasonsIndex[index]]![i]);
                        }
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Stack(
                        children: [
                          (state.reason.contains(reasons[reasonsIndex[index]]![i])) ? buttonPressed() : buttonUnpressed(),
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
      );
    }
    if (index != 3) {
      reasonBlocks.add(
        CustomThinDivider(),
      );
    }
    return reasonBlocks;
  }

  Widget buttonPressed () {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButtonPressed),
        ),
      ),
    );
  }

  Widget buttonUnpressed () {
    return Center(
      child: Container(
        height: 40,
        width: 40,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButton),
        ),
      ),
    );
  }

  Widget buildTextField () {
    return Column(
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: CustomSearchBar(textControl, "*필수입력"),
          ),
        ),
        Container(
          height: 25,
        ),
      ],
    );
  }
}
