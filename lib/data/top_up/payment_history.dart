import 'package:flutter/cupertino.dart';

class PaymentHistory {
  String itemType;
  String dateTime;
  double balanceInUnits;
  double valueInUnits;
  String chargeType;
  PaymentHistory(
      {this.itemType, this.dateTime, this.balanceInUnits, this.valueInUnits});

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    itemType = json['itemType'];
    dateTime = json['dateTime'];
    balanceInUnits = json['balanceInUnits'];
    valueInUnits = json['valueInUnits'];
    chargeType = json['chargeType'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemType'] = this.itemType;
    data['dateTime'] = this.dateTime;
    data['balanceInUnits'] = this.balanceInUnits;
    data['valueInUnits'] = this.valueInUnits ?? 0;
    data['chargeType'] = this.chargeType;
    return data;
  }

  String getDisplayString() {
    if (itemType == "CREDITS_PAYMENT") {
      return "Unit spent";
    }
    if (itemType == "CREDITS_CHARGE" &&
        (chargeType == "APP_STORE" || chargeType == "GOOGLE_PLAY")) {
      return "Unit purchased";
    }

    if (itemType == "CREDITS_CHARGE" && chargeType == "FREE_PLAN") {
      return "FREE UNITS FROM BEVIS";
    }
    return "";
  }

  bool isPurchase() {
    return itemType == "CREDITS_CHARGE";
  }

  bool isSpent() {
    return itemType == "CREDITS_PAYMENT";
  }

  bool isGift() {
    return chargeType == "FREE_PLAN";
  }
}

class Pagination {
  int defaultPageSize = 0;
  int page = 0;
  int totalCount = 0;

  Pagination({this.defaultPageSize, this.page, this.totalCount});

  Pagination.fromJson(Map<String, dynamic> json) {
    defaultPageSize = json['defaultPageSize'];
    page = json['page'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['defaultPageSize'] = this.defaultPageSize;
    data['page'] = this.page;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class PaymentHistoryPagination {
  List<PaymentHistory> paymentHistories;
  Pagination pagination;

  PaymentHistoryPagination(
      {@required this.paymentHistories, @required this.pagination});
}
