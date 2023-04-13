import 'package:bevis/pages/home/widgets/bottom_menu/scan_asset_widget.dart';
import 'package:bevis/pages/home/widgets/bottom_menu/write_to_blockchain_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomMenu extends StatelessWidget {
  BottomMenu({
    @required this.onScanPressed,
    @required this.onWritePressed,
  });

  final VoidCallback onScanPressed;
  final VoidCallback onWritePressed;

  Widget build(BuildContext context) {
    final scanAssetButton = ScanAssetWidget(
      onPressed: onScanPressed,
    );

    final writeToBlockchainButton = WriteToBlockchainWidget(
      onPressed: onWritePressed,
    );

    final List<Widget> menuElements = [scanAssetButton, writeToBlockchainButton];

    if(kIsWeb) {
      menuElements.removeAt(0);
    }

    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(10),
        bottom: ScreenUtil().setHeight(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: menuElements,
      ),
    );
  }
}
