import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomSearchBar.dart';

class AgentMain extends StatefulWidget {

  @override
  _AgentMainState createState() => _AgentMainState();
}

class _AgentMainState extends State<AgentMain> {
  late final TextEditingController textCont;
  bool buttonPressed = false;

  @override
  void initState () {
    super.initState();
    textCont = TextEditingController();
  }

  void dispose () {
    textCont.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          height: 50,
          width: 50,
          child: agentSymbol(),
        ),
      ],
    );
  }

  Widget buildOverlayContent () {
    return Container(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text("무엇을 도와드릴까요?"),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
                    utils.appManager.toUserPage(context, utils.pageNav);
                  },
                  text: "고객님 메뉴",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 90,
                ),
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
                    utils.appManager.toOrderPage(context, utils.pageNav);
                  },
                  text: "배송조회",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 90,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
                    utils.appManager.toShoppingPage(context, utils.pageNav);
                  },
                  text: "쇼핑백",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 90,
                ),
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
                    utils.appManager.toSearchPage(context, utils.pageNav);
                  },
                  text: "검색 홈",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 90,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget agentSymbol () {
    return GestureDetector(
      onTap: () {
        utils.appManager.loadOverlay!(200, buildOverlayContent());
        utils.appManager.overlayCont.animateTo(1, duration: Duration(milliseconds: 150), curve: Curves.linear);
      },
      onTapDown: (TapDownDetails details) {
        setState(() {
          buttonPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          buttonPressed = false;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          buttonPressed = false;
        });
      },
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 40,
              width: 40,
              child: buttonPressed ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
            ),
          ),
          Center(
            child: Container(
              height: 20,
              width: 20,
              child: Icon(
                Icons.more_horiz,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
