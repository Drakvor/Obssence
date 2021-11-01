import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Pages/Home/ItemScreen/SelectionState.dart';

class QuantityButtons extends StatefulWidget {
  final ItemData item;
  final SelectionState state;
  QuantityButtons(this.state, this.item);

  @override
  _QuantityButtonsState createState() => _QuantityButtonsState(state, item);
}

class _QuantityButtonsState extends State<QuantityButtons> {
  final ItemData item;
  final SelectionState state;
  _QuantityButtonsState(this.state, this.item);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getButtons(),
    );
  }

  List<Widget> getButtons () {
    List<Widget> buttons = [];
    for (int i = 0; i < item.availableNumber; i++) {
      buttons.add(buildButton(i));
    }
    return buttons;
  }

  Widget buildButton (int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          state.setQuantity(index + 1);
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
                height: 20,
                width: 20,
                child: Center(
                  child: Text((index + 1).toString(), style: utils.resourceManager.textStyles.dots),
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
        child: (index + 1 == state.quantity) ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
      ),
    );
  }
}
