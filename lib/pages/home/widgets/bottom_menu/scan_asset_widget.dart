import 'package:bevis/pages/home/widgets/bottom_menu/bottom_menu_button.dart';
import 'package:bevis/pages/home/widgets/bottom_menu/bottom_menu_element.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ScanAssetWidget extends StatelessWidget {
  ScanAssetWidget({@required this.onPressed});

  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return BottomMenuElement(
      title: 'READ',
      subtitle: 'QR camera scan',
      menuButton: BottomMenuButton(
        onPressed: onPressed,
        icon: SvgPicture.asset('assets/home/scan_icon.svg'),
        backgroundColor: ColorConstants.textColor,
      ),
    );
  }
}
