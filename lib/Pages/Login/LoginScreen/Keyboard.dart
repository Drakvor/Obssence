import 'package:flutter/material.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/KeyboardButton.dart';

class Keyboard extends StatelessWidget {
  Keyboard({
    Key? key,
    required this.characterSet,
    required this.textFunction,
    required this.specialFunctions,
    required this.specialImageSet,
    required this.numRows,
    required this.numCols,
    required this.style,
    this.widthHeightRatio = 2/3,
    this.dark = false,
  }) :  totalButtons = numRows * numCols,
        textButtons = characterSet.length,
        assert(specialFunctions.length + characterSet.length == numRows * numCols),
        super(key: key,);

  final bool dark;
  final List<String> characterSet;
  final void Function(String) textFunction;
  final List<void Function()> specialFunctions;
  final List<String> specialImageSet;
  final int numRows;
  final int numCols;
  final TextStyle style;
  final double widthHeightRatio;
  final int totalButtons;
  final int textButtons;
  late final double height;
  late final double width;
  late final double buttonHeight;
  late final double buttonWidth;

  bool isTextButton(index) {
    return index + 1 <= textButtons;
  }

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
          return KeyboardButton(
            whenPressed: (isTextButton(index))? textFunction : (String string){return specialFunctions[index-textButtons]();},
            text: (isTextButton(index))? characterSet[index] : '',
            style: style,
            h: buttonHeight,
            w: buttonWidth,
            isText: isTextButton(index),
            imageStr: (isTextButton(index))? utils.resourceManager.images.roundButton : specialImageSet[index-textButtons],
            dark: dark,
          );
        },
      ),
    );
  }
}