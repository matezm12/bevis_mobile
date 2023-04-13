import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularCheckBox extends StatelessWidget {
  CircularCheckBox({
    @required this.onChanged,
    @required this.isActive,
  });

  final void Function(bool newActiveState) onChanged;
  final bool isActive;

  Widget build(BuildContext context) {
    final icon = isActive
        ? SvgPicture.asset('assets/widgets/checkboxes/checkbox_selected.svg')
        : SvgPicture.asset('assets/widgets/checkboxes/checkbox_unselected.svg');
    return ElevatedButton(
      onPressed: () {
        onChanged(!isActive);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: CircleBorder(),
      ),
      child: icon,
    );
  }
}
