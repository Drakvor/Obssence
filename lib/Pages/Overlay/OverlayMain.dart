import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class OverlayMain extends StatefulWidget {

  @override
  _OverlayMainState createState() => _OverlayMainState();
}

class _OverlayMainState extends State<OverlayMain> with SingleTickerProviderStateMixin {
  int height = 0;
  Widget contents = Container();
  late AnimationController overlayCont;

  void loadOverlay (int h, Widget c) {
    setState(() {
      height = h;
      contents = c;
    });
  }

  @override
  void initState () {
    super.initState();
    overlayCont = AnimationController(vsync: this);
    utils.appManager.loadOverlay = loadOverlay;
    utils.appManager.overlayCont = overlayCont;
  }

  void dispose () {
    overlayCont.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: 0,
          child: coverScreen(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: height + 20,
          child: overlayContents(),
        ),
      ],
    );
  }

  Widget coverScreen () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (overlayCont.value == 0) ? MediaQuery.of(context).size.height : 0, 0, 1,
          ),
          child: GestureDetector(
            onTap: () {
              //turn off overlay.
              overlayCont.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
            },
            child: Opacity(
              opacity: overlayCont.value/2,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        color: utils.resourceManager.colours.coverScreen,
      ),
    );
  }

  Widget overlayContents () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (1-overlayCont.value)*height + 20, 0, 1,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: (DragUpdateDetails details) {
              overlayCont.animateTo((overlayCont.value - details.delta.dy/height >= 0 && overlayCont.value - details.delta.dy/height <= 1) ? overlayCont.value - details.delta.dy/height : overlayCont.value, duration: Duration(seconds: 0), curve: Curves.linear);
            },
            onVerticalDragEnd: (DragEndDetails details) {
              if (overlayCont.value < 0.5) {
                overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
              }
              if (overlayCont.value >= 0.5) {
                overlayCont.animateTo(1, duration: Duration(milliseconds: 200), curve: Curves.linear);
              }
            },
            onVerticalDragCancel: () {
              overlayCont.animateTo(1, duration: Duration(milliseconds: 200), curve: Curves.linear);
            },
            child: Container(
              height: height + 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: utils.resourceManager.colours.background,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      overlayCont.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
                    },
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Container(
                          height: 10,
                          child: Image.asset(utils.resourceManager.images.downIndicator),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: child!,
                  ),
                  (height > 20) ? Container(
                    height: 20,
                  ) : Container(),
                ],
              ),
            ),
          ),
        );
      },
      child: contents,
    );
  }
}
