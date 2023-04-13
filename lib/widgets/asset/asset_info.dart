import 'package:bevis/data/models/asset.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetInfo extends StatelessWidget {
  AssetInfo({
    @required this.asset,
    this.onPublicKeyTapped,
  });

  final Asset asset;
  final void Function(String) onPublicKeyTapped;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _getDisplayValues(asset),
      ),
    );
  }

  List<Widget> _getDisplayValues(Asset asset) {
    var detailValues = <Widget>[];
    asset.displayValues.forEach((final element) {
      bool ispublicKey = element.fieldName == "public_key";
      print("found public key " + ispublicKey.toString());

      if (ispublicKey) {
        var row = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onPublicKeyTapped(element.fieldValue);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 15),
                    width: ScreenUtil().setWidth(80),
                    child: Text(
                      element.fieldTitle == null
                          ? element.fieldName
                          : element.fieldTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    )),
                Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        element.fieldValue == null ? "" : element.fieldValue,
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.textColor,
                        ),
                      )),
                ),
                Icon(
                  Icons.content_copy,
                  size: 15,
                  color: ColorConstants.hintTextColor,
                ),
              ],
            ),
          ),
        );

        var divider = Divider();
        detailValues.add(row);
        detailValues.add(divider);
      } else {
        var row = Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 15),
                width: ScreenUtil().setWidth(80),
                child: Text(
                  element.fieldTitle == null
                      ? element.fieldName
                      : element.fieldTitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorConstants.textColor,
                  ),
                )),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  element.fieldValue == null ? "" : element.fieldValue,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorConstants.textColor,
                  ),
                ),
              ),
            ),
          ],
        );

        var divider = Divider();
        detailValues.add(row);
        detailValues.add(divider);
      }
    });
    return detailValues;
  }
}
