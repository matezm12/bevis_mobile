import 'package:bevis/pages/home/widgets/bottom_menu/bottom_menu_button.dart';
import 'package:bevis/pages/home/widgets/bottom_menu/bottom_menu_element.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WriteToBlockchainWidget extends StatelessWidget {
  WriteToBlockchainWidget({@required this.onPressed});

  final VoidCallback onPressed;

  Widget build(BuildContext context) {
    return BottomMenuElement(
      title: 'WRITE',
      subtitle: 'to the blockchain',
      menuButton: BottomMenuButton(
        onPressed: onPressed,
        icon: SvgPicture.asset('assets/home/write_asset_icon.svg'),
        backgroundColor: ColorConstants.colorAppRed,
      ),
    );
  }
}
