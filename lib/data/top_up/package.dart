class CreditPackage {
  int id;
  double amountInUnits;
  double packagePrice;
  String productId;

  CreditPackage({this.id, this.amountInUnits, this.packagePrice});

  CreditPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amountInUnits = json['amountInUnits'];
    packagePrice = json['packagePrice'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['amountInUnits'] = this.amountInUnits;
    data['packagePrice'] = this.packagePrice;
    data['productId'] = this.productId;
    return data;
  }
}
