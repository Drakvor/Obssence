import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class OverlayMain extends StatefulWidget {
  final double height;
  final Widget contents;
  OverlayMain(this.height, this.contents);

  @override
  _OverlayMainState createState() => _OverlayMainState();
}

class _OverlayMainState extends State<OverlayMain> with SingleTickerProviderStateMixin {
  late AnimationController overlayCont;

  @override
  void initState () {
    super.initState();
    overlayCont = AnimationController(vsync: this);
    utils.appManager.overlayCont = overlayCont;
  }

  void dispose () {
    overlayCont.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: coverScreen(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: widget.height + 20,
            child: overlayContents(),
          ),
        ],
      ),
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
            0, (1-overlayCont.value)*widget.height + 20, 0, 1,
          ),
          child: GestureDetector(
            child: Container(
              height: widget.height + 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
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
                  child!,
                ],
              ),
            ),
          ),
        );
      },
      child: widget.contents,
    );
  }
}
