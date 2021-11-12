import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class CustomPageRoute extends PageRouteBuilder {
  Widget nextPage;
  CustomPageRoute({required this.nextPage}) : super(
    transitionDuration: Duration(milliseconds: 400),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget page) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final secTween = Tween(begin: end, end: Offset(0.0, -0.5));
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      final secCurvedAnimation = CurvedAnimation(
        parent: secAnimation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: SlideTransition(
          position: secTween.animate(secCurvedAnimation),
          child: AnimatedBuilder(
            animation: secAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 1 - secAnimation.value,
                child: child,
              );
            },
            child: page,
          ),
        ),
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
      return nextPage;
    },
  );
}

class InstantPageRoute extends PageRouteBuilder {
  Widget nextPage;
  InstantPageRoute({required this.nextPage}) : super(
    transitionDuration: Duration(milliseconds: 0),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget page) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final secTween = Tween(begin: end, end: Offset(0.0, -0.5));
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );
      final secCurvedAnimation = CurvedAnimation(
        parent: secAnimation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: SlideTransition(
          position: secTween.animate(secCurvedAnimation),
          child: AnimatedBuilder(
            animation: secAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 1 - secAnimation.value,
                child: child,
              );
            },
            child: page,
          ),
        ),
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
      return nextPage;
    },
  );
}