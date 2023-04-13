import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class MLoadMoreDelegate extends LoadMoreDelegate {
  const MLoadMoreDelegate();

  @override
  double widgetHeight(LoadMoreStatus status) {
    return status == LoadMoreStatus.loading ? 50 : 10;
  }

  @override
  Widget buildChild(LoadMoreStatus status,
      {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese}) {
    String text = "Fetching from server";
    if (status == LoadMoreStatus.fail) {
      return Container(
        child: Text(
          "Fetch failed",
          style: TextStyle(color: ColorConstants.textColor),
        ),
      );
    }
    if (status == LoadMoreStatus.idle) {
      return Text("", style: TextStyle(color: ColorConstants.textColor));
    }
    if (status == LoadMoreStatus.loading) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text(text, style: TextStyle(color: ColorConstants.textColor)),
            ),
          ],
        ),
      );
    }
    if (status == LoadMoreStatus.nomore) {
      return Text("");
    }

    return Text("Nothing to Fetch");
  }
}
