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

class _AgentMainState extends State<AgentMain> with SingleTickerProviderStateMixin {
  late final AnimationController overlayCont;
  late final TextEditingController textCont;
  bool buttonPressed = false;

  void agentOff () {
    overlayCont.animateTo(220, duration: Duration(milliseconds: 200), curve: Curves.linear);
    utils.appManager.setAgentOff();
  }

  @override
  void initState () {
    super.initState();
    overlayCont = AnimationController.unbounded(value: 220, vsync: this);
    textCont = TextEditingController();
  }

  void dispose () {
    overlayCont.dispose();
    textCont.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    utils.appManager.setAgentFunction(agentOff);

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          height: 50,
          width: 50,
          child: agentSymbol(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: 0,
          child: buildCoverScreen(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          height: 220,
          child: buildOverlay(),
        ),
      ],
    );
  }

  Widget buildOverlay () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, overlayCont.value, 0, 1,
          ),
          child: child,
        );
      },
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          overlayCont.animateTo((overlayCont.value + details.delta.dy > 20) ? overlayCont.value+details.delta.dy : 20, duration: Duration(seconds: 0), curve: Curves.linear);
        },
        onVerticalDragEnd: (DragEndDetails details) {
          if (overlayCont.value > 100) {
            overlayCont.animateTo(220, duration: Duration(milliseconds: 100), curve: Curves.linear);
            utils.appManager.setAgentOff();
          }
          if (overlayCont.value <= 100) {
            overlayCont.animateTo(20, duration: Duration(milliseconds: 100), curve: Curves.linear);
          }
        },
        onVerticalDragCancel: () {
          overlayCont.animateTo(20, duration: Duration(milliseconds: 100), curve: Curves.linear);
        },
        child: Container(
          height: 220,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: utils.resourceManager.colours.background,
          ),
          child: buildOverlayContent(),
        ),
      ),
    );
  }

  Widget buildOverlayContent () {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 10,
            child: Center(
              child: Image.asset(utils.resourceManager.images.downIndicator),
            ),
          ),
          Container(
            child: Text("무엇을 도와드릴까요?"),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.agentOff!();
                    utils.appManager.toUserPage(context, utils.pageNav);
                  },
                  text: "고객님 메뉴",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 90,
                ),
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.agentOff!();
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
                    await utils.appManager.agentOff!();
                    utils.appManager.toShoppingPage(context, utils.pageNav);
                  },
                  text: "쇼핑백",
                  style: utils.resourceManager.textStyles.base14,
                  h: 30,
                  w: 90,
                ),
                CustomButton(
                  whenPressed: () async {
                    await utils.appManager.agentOff!();
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

  Widget buildCoverScreen () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (overlayCont.value < 200) ? 0 : MediaQuery.of(context).size.height, 0, 1,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              utils.appManager.agentOff!();
            },
            child: Opacity(
              opacity: ((1-(overlayCont.value-20)/200)/2 >= 0) ? (1-(overlayCont.value-20)/200)/2 : 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xff000000),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget agentSymbol () {
    return GestureDetector(
      onTap: () {
        if (!utils.appManager.agentOn){
          overlayCont.animateTo(20, duration: Duration(milliseconds: 100), curve: Curves.linear);
          utils.appManager.setAgentOn();
        }
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
