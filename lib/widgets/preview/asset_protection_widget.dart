import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/rounded_corner_button_with_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetProtectionWidget extends StatelessWidget {
  AssetProtectionWidget({
    @required this.onPasswordActionButtonPressed,
    @required this.isAssetProtected,
  });

  final VoidCallback onPasswordActionButtonPressed;
  final bool isAssetProtected;

  Widget build(BuildContext context) {
    if(kIsWeb) {
      return Container();
    }
    
    final assetProtectionStateIcon = isAssetProtected
        ? SvgPicture.asset('assets/asset_preview_page/encrypted_asset.svg')
        : SvgPicture.asset('assets/asset_preview_page/not_encrypted_asset.svg');

    final protectButtonTitle =
        isAssetProtected ? 'Edit password' : 'Encrypt Files';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        assetProtectionStateIcon,
        SizedBox(
          width: 8,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isAssetProtected
                  ? 'Your file has been password-protected'
                  : 'Add additional layer of protection',
              style: TextStyle(
                fontSize: 12,
                color: ColorConstants.hintTextColor,
              ),
            ),
            RoundedCornerButtonWithBorder(
              title: protectButtonTitle,
              onPressed: onPasswordActionButtonPressed,
            ),
          ],
        ),
      ],
    );
  }
}
