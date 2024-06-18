import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final ValueNotifier<bool> _isPressed = ValueNotifier<bool>(false);
  final String text;
  final List<Color> gradiantColor;
  final List<Color> tapedGradiantColor;
  LoginButton({super.key, required this.onTap, required this.text, required this.gradiantColor, required this.tapedGradiantColor});

  void _onTapDown(TapDownDetails details) {
    _isPressed.value = true;
  }

  void _onTapUp(TapUpDetails details) {
    _isPressed.value = false;
    onTap();
  }

  void _onTapCancel() {
    _isPressed.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isPressed,
        builder: (context, isPressed, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPressed ? tapedGradiantColor: gradiantColor,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                if (isPressed)
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 40.0),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}