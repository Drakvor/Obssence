import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen/ShoppingCartState.dart';

class SizeEditButtons extends StatefulWidget {
  final ShoppingCartState state;
  SizeEditButtons(this.state);

  @override
  _SizeEditButtonsState createState() => _SizeEditButtonsState(state);
}

class _SizeEditButtonsState extends State<SizeEditButtons> {
  final ShoppingCartState state;
  _SizeEditButtonsState(this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getButtons(),
    );
  }

  List<Widget> getButtons () {
    List<Widget> buttons = [];
    for (int i = 0; i < state.selection!.item!.availableSizes!.length; i++) {
      buttons.add(buildButton(i));
    }
    return buttons;
  }

  Widget buildButton (int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          state.setSize(index);
        });
      },
      child: Container(
        height: 40,
        width: 40,
        child: Stack(
          children: [
            buttonImage(index),
            Center(
              child: Container(
                height: 30,
                width: 30,
                child: Center(
                  child: Text(state.selection!.item!.availableSizes![index].split(" ")[0], style: utils.resourceManager.textStyles.dots),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonImage (int index) {
    return Container(
      height: 40,
      width: 40,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: (index == state.size) ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
      ),
    );
  }
}
