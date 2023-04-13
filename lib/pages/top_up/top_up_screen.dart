import 'dart:async';
import 'dart:io';
import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/blocs/balance_bloc.dart';
import 'package:bevis/blocs/blocs/credit_package_bloc/credit_package_bloc.dart';
import 'package:bevis/blocs/blocs/validate_purchase/purchase_validate_bloc.dart';
import 'package:bevis/blocs/events/balance_event_bloc.dart';
import 'package:bevis/blocs/states/balance_state.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/balance_network_repositoryImpl.dart';
import 'package:bevis/data/repositories/network_repositories/http/top_up_repository_imp.dart';
import 'package:bevis/data/top_up/package.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/top_up/transaction_history_screen.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopUpPageState();
  }
}

class _TopUpPageState extends State<TopUpPage> {
  CreditPackageBloc _creditPackageBloc;
  PurchaseValidateBloc _purchaseValidateBloc;
  BalanceInfoBloc _balanceInfoBloc;
//  StreamSubscription<List<PurchaseDetails>> _subscription;
  BehaviorSubject<bool> storeAvailable = BehaviorSubject();
  BehaviorSubject<String> balance = BehaviorSubject();

  BehaviorSubject<List<IAPItem>> products = BehaviorSubject();
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;
  BlocListener _creditPackageListener;
  BlocListener _balanceListener;

  BlocListener _purchaseValidateListener;
  BehaviorSubject<String> currentPurchasingPackage = BehaviorSubject();

  List<PurchasedItem> pendingItems = <PurchasedItem>[];
  PurchasedItem purchaseItem;

  @override
  void dispose() {
    super.dispose();
    storeAvailable.close();
    currentPurchasingPackage.close();
    _conectionSubscription.cancel();
    _purchaseErrorSubscription.cancel();
    _purchaseUpdatedSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    initStore();

    _creditPackageBloc = CreditPackageBloc(
        networkRepo: TopUpNetworkRepositoryImpl(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    ));
    _purchaseValidateBloc = PurchaseValidateBloc(
        networkRepo: TopUpNetworkRepositoryImpl(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    ));
    _balanceInfoBloc = BalanceInfoBloc(
        balanceNetworkRepository: BalanceNetworkRepositoryImpl(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    ));
    _creditPackageListener =
        BlocListener<CreditPackageBloc, CreditPackageState>(
            bloc: _creditPackageBloc,
            listener: (context, state) {
              // do stuff here based on BlocA's state
              if (state is SuccessLoadCreditPackageState) {
                print("state " + state.packages.length.toString());
                List<String> productIds = <String>[];
                state.packages.forEach((element) {
                  print("product id " + element.productId.toString());
                  productIds.add(element.productId);
                });
                getProductsFromStore(productIds);
              }
            });
    _balanceListener = BlocListener<BalanceInfoBloc, BalanceInfoState>(
        bloc: _balanceInfoBloc,
        listener: (context, state) {
          // do stuff here based on BlocA's state
          print("IN satate");
          print("Balance " + state.balance);
          balance.add(state.balance);
        });
    _purchaseValidateListener =
        BlocListener<PurchaseValidateBloc, PurchaseValidateState>(
            bloc: _purchaseValidateBloc,
            listener: (context, state) async {
              // do stuff here based on BlocA's state
              print("IN satate");
              if (state is SuccessPurchaseValidateState) {
                if (state.balance != null) {
                  balance.add(state.balance);
                }
                print("purchase item " + state.purchasedItem.toString());

                showNewBalance(context);
                if (Platform.isIOS) {
                  await FlutterInappPurchase.instance
                      .finishTransaction(state.purchasedItem);
                }
                if (Platform.isAndroid) {
                  await FlutterInappPurchase.instance.consumePurchaseAndroid(
                      state.purchasedItem.purchaseToken);
                }
                removeSuccessPurchaseFromPendingList(state);
              }
              if (state is DuplicatePurchaseValidateState) {
                if (Platform.isIOS) {
                  await FlutterInappPurchase.instance
                      .finishTransaction(state.purchasedItem);
                }
                if (Platform.isAndroid) {
                  print("state " +
                      state.purchasedItem.purchaseStateAndroid.toString());
                  await FlutterInappPurchase.instance.consumePurchaseAndroid(
                      state.purchasedItem.purchaseToken);
                }
              }
            });
    _creditPackageBloc.add(LoadCreditPackageEvent());
    _balanceInfoBloc.add(LoadBalanceInfo());
  }

  void removeSuccessPurchaseFromPendingList(
      SuccessPurchaseValidateState state) {
    PurchasedItem purchasedItem;
    pendingItems.forEach((element) {
      if (element.productId == state.purchasedItem.productId) {
        purchasedItem = element;
      }
    });
    pendingItems.remove(purchasedItem);
    print("Pending size" + pendingItems.length.toString());
    refreshProduct();
  }

  void showNewBalance(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BevisInfoDialog(
          title: 'Successfully Purchased',
          message: 'Your new balance is ${balance.value}',
        );
      },
    );
  }

  void showTransactionState(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final purchaseProcessorName =
            Platform.isAndroid ? "Google Play" : "App Store";
        return BevisInfoDialog(
          title: 'Info',
          message:
              'Your purchase is still processing by $purchaseProcessorName',
        );
      },
    );
  }

  Future<void> getProductsFromStore(List<String> productIds) async {
    print("product ids count " + productIds.length.toString());
    List<IAPItem> items = await FlutterInappPurchase.instance
        .getProducts(productIds.toSet().toList());
    products.add(items);

    print("store fetched success " + items.length.toString());
  }

  Future<void> initStore() async {
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    handlePastPurchase();

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      currentPurchasingPackage.add("");
      purchaseItem = productItem;
      pendingItems.add(purchaseItem);
      handlePurchase(productItem);
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      currentPurchasingPackage.add("");
      if (purchaseError.responseCode == 7) {
        showTransactionState(context);
      }
    });
  }

  Future handlePastPurchase() async {
    if (Platform.isIOS) {
      await FlutterInappPurchase.instance.clearTransactionIOS();
      var pending =
          await FlutterInappPurchase.instance.getPendingTransactionsIOS();
      print("Size " + pending.length.toString());
      pendingItems = pending;
      pending.forEach((element) async {
        print("Prurchae ID" + element.transactionStateIOS.toString());

        purchaseItem = element;
        _purchaseValidateBloc.add(ValidatePurchaseEvent(
            purchasedItem: purchaseItem,
            productId: element.productId,
            purchaseId: element.transactionId,
            provider: "APP_STORE",
            receiptData: element.transactionReceipt));
        print("end transactino");
      });
    }
    if (Platform.isAndroid) {
      print("in android");
      var pending = await FlutterInappPurchase.instance.getAvailablePurchases();
      print("Size " + pending.length.toString());
      pendingItems = pending;

      pending.forEach((element) async {
        print("Prurchae token" + element.purchaseStateAndroid.toString());

        purchaseItem = element;
        handlePurchase(purchaseItem);

        print("end transactino");
      });
    }
  }

  void handlePurchase(final PurchasedItem productItem) {
    if (Platform.isIOS) {
      if (purchaseItem.transactionStateIOS == TransactionState.purchased) {
        _purchaseValidateBloc.add(ValidatePurchaseEvent(
            purchasedItem: purchaseItem,
            productId: productItem.productId,
            purchaseId: productItem.transactionId,
            provider: Platform.isIOS ? "APP_STORE" : "GOOGLE_PLAY",
            receiptData: Platform.isIOS
                ? productItem.transactionReceipt
                : productItem.purchaseToken));
      } else {
//        showTransactionState(context);
      }
    } else {
      if (Platform.isAndroid) {
        print(
            'purchase-updated: ' + productItem.purchaseStateAndroid.toString());
        switch (purchaseItem.purchaseStateAndroid) {
          case PurchaseState.purchased:
            _purchaseValidateBloc.add(
              ValidatePurchaseEvent(
                purchasedItem: purchaseItem,
                productId: productItem.productId,
                purchaseId: productItem.transactionId,
                provider: Platform.isIOS ? "APP_STORE" : "GOOGLE_PLAY",
                receiptData: Platform.isIOS
                    ? productItem.transactionReceipt
                    : productItem.purchaseToken,
              ),
            );
            break;
          default:
            break;
        }
      }
    }
  }

  void refreshProduct() {
    products.add(products.value);
  }

  @override
  Widget build(BuildContext context) {
    print("TOKEN " + token);
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(375, 723),
    );

    double statusBarHeight = MediaQuery.of(context).padding.top;
    print("status bar height" + "here" + statusBarHeight.toString());

    return MultiBlocListener(
      listeners: [
        _creditPackageListener,
        _purchaseValidateListener,
        _balanceListener
      ],
      child: WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(top: statusBarHeight),
            child: SafeArea(
              bottom: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setHeight(8),
                      ),
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "TOP-UP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: ColorConstants.textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      height: ScreenUtil().setHeight(16),
                                      child: Text(
                                        "Bevis v",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstants.textColor,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setHeight(10)),
                                      child: Icon(
                                        Icons.arrow_back,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                      thickness: 2.5,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: <Widget>[
                                  Text(
                                    "Your current",
                                    style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: Image.asset(
                                      "assets/credits.png",
                                      height: 20,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Text(
                                    "Unit Balance",
                                    style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: StreamBuilder<String>(
                                      stream: balance,
                                      initialData: "",
                                      builder: (context, snapshot) {
                                        return Text(
                                          snapshot.data,
                                          style: TextStyle(
                                            color: ColorConstants.textColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  _showPaymentHistory();
                                },
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorConstants.borderColor),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Check your payment history",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              indent: 50,
                              thickness: 1,
                              endIndent: 50,
                            ),
                            Container(
                              height: 20,
                              alignment: Alignment.center,
                              child: Row(
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: <Widget>[
                                  Text(
                                    "Buy more",
                                    style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 5, right: 5),
                                    child: Image.asset(
                                      "assets/credits.png",
                                      height: 15,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  Text(
                                    "Units via in-app purchase:",
                                    style: TextStyle(
                                      color: ColorConstants.textColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: StreamBuilder<List<IAPItem>>(
                                stream: products.stream,
                                initialData: null,
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return snapshot.data.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return StreamBuilder<String>(
                                                stream:
                                                    currentPurchasingPackage,
                                                initialData: "",
                                                builder: (context, productId) {
                                                  return getPackageViewPlayProduct(
                                                    snapshot.data[index],
                                                    isPurchasing:
                                                        productId.data ==
                                                            snapshot.data[index]
                                                                .productId,
                                                  );
                                                },
                                              );
                                            },
                                          )
                                        : Center(
                                            child: Text(
                                              "no packages available",
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.textColor,
                                                  fontSize: 16),
                                            ),
                                          );
                                  } else {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            "Loading packages",
                                            style: TextStyle(
                                                color: ColorConstants.textColor,
                                                fontSize: 16),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(25),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          isLogIn = false;
          token = "";
          return true;
        },
      ),
    );
  }

  Widget getPackageView(CreditPackage creditPackage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: 15,
              left: ScreenUtil().setWidth(50),
              right: ScreenUtil().setWidth(50)),
          child: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    creditPackage.amountInUnits.toString(),
                    style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
                    child: Image.asset(
                      "assets/credits.png",
                      height: 15,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    "Units",
                    style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "\$" + creditPackage.packagePrice.toString(),
                      style: TextStyle(
                          color: ColorConstants.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    RedBevisButton(
                      title: 'Buy',
                      onPressed: () {},
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 1,
          indent: ScreenUtil().setWidth(48),
          endIndent: ScreenUtil().setWidth(48),
        ),
      ],
    );
  }

  Widget getPackageViewPlayProduct(IAPItem productDetails,
      {bool isPurchasing = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: 15,
              left: ScreenUtil().setWidth(50),
              right: ScreenUtil().setWidth(50)),
          child: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    productDetails.title.split(" ")[0],
                    style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
                    child: Image.asset(
                      "assets/credits.png",
                      height: 15,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    "Units",
                    style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      productDetails.price,
                      style: TextStyle(
                          color: ColorConstants.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RedBevisButton(
                      title: getDisplayBtnLabel(productDetails),
                      isLoading: isPurchasing,
                      spinkitColor: Colors.white,
                      onPressed: () {
                        if (!isPurchasing) {
                          FlutterInappPurchase.instance
                              .requestPurchase(productDetails.productId);
                          currentPurchasingPackage
                              .add(productDetails.productId);
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 1,
          indent: ScreenUtil().setWidth(48),
          endIndent: ScreenUtil().setWidth(48),
        ),
      ],
    );
  }

  String getDisplayBtnLabel(IAPItem product) {
    bool isContain = false;
    pendingItems.forEach((element) {
      if (element.productId == product.productId) {
        isContain = true;
      }
    });
    return isContain ? "Pending" : "Buy";
  }

  void _showPaymentHistory() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: PaymentHistoryPage()));
  }
}
