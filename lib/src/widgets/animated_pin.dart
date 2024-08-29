import 'package:flutter/material.dart';
import 'package:place_picker_google/place_picker_google.dart';

class AnimatedPin extends StatelessWidget {
  const AnimatedPin({
    super.key,
    this.child,
    this.state = PinState.idle,
  });

  final Widget? child;
  final PinState state;

  @override
  Widget build(final BuildContext context) {
    return state == PinState.preparing
        ? const SizedBox.shrink()
        : AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: state == PinState.dragging
                ? Matrix4.translationValues(0, -12, 0)
                : Matrix4.translationValues(0, 0, 0),
            child: child,
          );
  }
}
