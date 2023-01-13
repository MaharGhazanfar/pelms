import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class CustomButton extends StatefulWidget {
  final void Function()? onPressed;
  final ButtonState buttonState;
  final String text;

  const CustomButton(
      {Key? key, required this.onPressed, required this.buttonState, this.text = 'Add'  })
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return buildTextWithIcon();
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
        maxWidth: 120.0,
        textStyle: const TextStyle(color: Colors.white),
        iconedButtons: {
          ButtonState.idle:  IconedButton(
              text: widget.text, icon: const Icon(Icons.send), color: Colors.blue),
          ButtonState.loading:
              IconedButton(text: "Loading", color: Colors.deepPurple.shade400),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: const Icon(Icons.cancel, color: Colors.white),
              color: Colors.red.shade300),
          ButtonState.success: IconedButton(
              text: "",
              icon: const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        },
        onPressed: widget.onPressed,
        state: widget.buttonState);
  }
}
