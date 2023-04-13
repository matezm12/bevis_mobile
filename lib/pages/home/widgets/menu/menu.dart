import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum MenuItemType {
  myAssets,
  topUp,
  settings,
  biometricLogin,
  logout,
}

class Menu extends StatelessWidget {
  Menu({
    @required this.biometricLoginEnabled,
    @required this.onSelectedMenuItem,
  });

  final bool biometricLoginEnabled;
  final void Function(MenuItemType menuItemType) onSelectedMenuItem;

  Widget build(BuildContext context) {
    final menuItems = _buildMenuItems();
    final menuItemsWithDividers = _insertDividersBetweenWidgets(menuItems);

    return PopupMenuButton<MenuItemType>(
      icon: Icon(Icons.dehaze),
      offset: Offset(0, 50),
      padding: EdgeInsets.all(0),
      elevation: 1,
      onSelected: onSelectedMenuItem,
      itemBuilder: (context) => menuItemsWithDividers,
    );
  }

  PopupMenuItem<MenuItemType> _buildPopupMenuItem({
    @required MenuItemType value,
    @required Widget icon,
    @required String title,
  }) {
    return PopupMenuItem<MenuItemType>(
      value: value,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 9,
            ),
            icon,
            SizedBox(
              width: 30,
            ),
            Text(
              title,
              style: TextStyle(
                color: ColorConstants.textColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<MenuItemType>> _buildMenuItems() {
    return <PopupMenuEntry<MenuItemType>>[
      _buildPopupMenuItem(
        icon: SvgPicture.asset("assets/menu/menu_assets.svg"),
        title: "My Assets",
        value: MenuItemType.myAssets,
      ),
      // _buildPopupMenuItem(
      //   icon: Icon(
      //     Icons.monetization_on,
      //     color: ColorConstants.textColor,
      //     size: 20,
      //   ),
      //   title: "Top Up",
      //   value: MenuItemType.topUp,
      // ),
      _buildPopupMenuItem(
        icon: SvgPicture.asset("assets/menu/menu_settings.svg"),
        title: "Setting",
        value: MenuItemType.settings,
      ),
      // _buildPopupMenuItem(
      //   icon: Icon(
      //     Icons.face,
      //     color: biometricLoginEnabled
      //         ? ColorConstants.facebookBlue
      //         : ColorConstants.textColor,
      //     size: 20,
      //   ),
      //   title: "Biometric Log In",
      //   value: MenuItemType.biometricLogin,
      // ),
      _buildPopupMenuItem(
        icon: Image.asset(
          "assets/menu/logout.png",
          color: ColorConstants.textColor,
        ),
        title: "Logout",
        value: MenuItemType.logout,
      ),
    ];
  }

  List<PopupMenuEntry> _insertDividersBetweenWidgets(
      List<PopupMenuEntry> widgets) {
    int i = 1;

    final List<PopupMenuEntry> listOfMenuEntries = widgets;

    while (i < listOfMenuEntries.length) {
      listOfMenuEntries.insert(
        i,
        PopupMenuDivider(
          height: 10,
        ),
      );
      i += 2;
    }

    return listOfMenuEntries;
  }
}
