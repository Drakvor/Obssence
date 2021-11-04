import 'package:flutter/material.dart';
import 'package:luxury_app_pre/Widget/KeyboardButton.dart';

class Keyboard extends StatelessWidget {
  Keyboard({
    Key? key,
    required this.characterSet,
    required this.functionSet,
    required this.numRows,
    required this.numCols,
    required this.style,
    this.widthHeightRatio = 2/3,
  }) :  totalButtons = numRows * numCols,
        assert(characterSet.length == functionSet.length),
        usableButtons = characterSet.length,
        super(key: key,);

  final List<String> characterSet;
  final List<void Function(String)> functionSet;
  final TextStyle style;
  final int numRows;
  final int numCols;
  final double widthHeightRatio;
  final int totalButtons;
  final int usableButtons;
  late final double height;
  late final double width;
  late final double buttonHeight;
  late final double buttonWidth;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = width * widthHeightRatio;
    buttonWidth = width / numCols;
    buttonHeight = height / numRows;

    return Container(
      height: MediaQuery.of(context).size.width*widthHeightRatio,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: numCols,
          mainAxisExtent: MediaQuery.of(context).size.width*widthHeightRatio/numRows,
        ),
        itemCount: totalButtons,
        itemBuilder: (context, index) {
          if (index + 1 <= usableButtons) {
            return KeyboardButton(
              whenPressed: functionSet[index],
              text: characterSet[index],
              style: style,
              h: buttonHeight,
              w: buttonWidth,
            );
          } else {
            return KeyboardButton(
              whenPressed: (String string){return;},
              text: '',
              style: style,
              h: buttonHeight,
              w: buttonWidth,
            );
          }
        },
      ),
    );
  }
}