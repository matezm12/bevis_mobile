import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/blocs/balance_bloc.dart';
import 'package:bevis/blocs/blocs/payment_history_bloc/payment_history_bloc.dart';
import 'package:bevis/blocs/events/balance_event_bloc.dart';
import 'package:bevis/blocs/states/balance_state.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/balance_network_repositoryImpl.dart';
import 'package:bevis/data/repositories/network_repositories/http/top_up_repository_imp.dart';
import 'package:bevis/data/repositories/network_repositories/top_up_repository.dart';
import 'package:bevis/data/top_up/payment_history.dart';
import 'package:bevis/main.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/MLoadMoreDelegate.dart';
import 'package:bevis/widgets/buttons/rounded_corner_button_with_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loadmore/loadmore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentHistoryPageState();
  }
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  PaymentHistoryBloc _paymentHistoryBloc;
  BalanceInfoBloc _balanceInfoBloc;
  final BehaviorSubject<String> versionController = BehaviorSubject<String>();
  BlocListener _paymentHistoryListener;
  Pagination pagination;
  TopUpNetworkRepository _topUpNetworkRepository;
  final BehaviorSubject<List<PaymentHistory>> paymentHistories =
      BehaviorSubject<List<PaymentHistory>>();

  @override
  void dispose() {
    super.dispose();
    paymentHistories.close();
    versionController.close();
  }

  @override
  void initState() {
    super.initState();
    _topUpNetworkRepository = TopUpNetworkRepositoryImpl(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    );
    _paymentHistoryBloc =
        PaymentHistoryBloc(networkRepo: _topUpNetworkRepository);
    _balanceInfoBloc = BalanceInfoBloc(
        balanceNetworkRepository: BalanceNetworkRepositoryImpl(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    ));

    _paymentHistoryListener =
        BlocListener<PaymentHistoryBloc, PaymentHistoryState>(
            bloc: _paymentHistoryBloc,
            listener: (context, state) {
              // do stuff here based on BlocA's state
              if (state is SuccessLoadPaymentHistoryState) {
                paymentHistories.add(state.histories.paymentHistories);
                pagination = state.histories.pagination;
              }
            });
    _paymentHistoryBloc.add(LoadPaymentHistoryEvent());
    _balanceInfoBloc.add(LoadBalanceInfo());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(375, 723),
    );

    double statusBarHeight = MediaQuery.of(context).padding.top;

    return MultiBlocListener(
      listeners: [
        _paymentHistoryListener,
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
                                            "PAYMENT HISTORY",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: ColorConstants.textColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                            alignment: Alignment.bottomCenter,
                                            height: ScreenUtil().setHeight(16),
                                            child: StreamBuilder<String>(
                                                initialData: "",
                                                stream: versionController,
                                                builder: (context, snapshot) {
                                                  return Text(
                                                      "Bevis v" + snapshot.data,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorConstants
                                                              .textColor));
                                                }))
                                      ],
                                    )),
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
                                          child: Icon(Icons.arrow_back)
//                        Icon(
//                          Icons.dehaze,
//                          size: 35,
//                        )
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
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
                                      child: BlocBuilder<BalanceInfoBloc,
                                          BalanceInfoState>(
                                        bloc: _balanceInfoBloc,
                                        builder: (context, state) {
                                          return Text(
                                            state.balance,
                                            style: TextStyle(
                                                color: ColorConstants.textColor,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: <Widget>[
                                    Text(
                                      "Your",
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
                                      "Units purchase history:",
                                      style: TextStyle(
                                          color: ColorConstants.textColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: StreamBuilder<List<PaymentHistory>>(
                                      stream: paymentHistories.stream,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData
                                            ? LoadMore(
                                                delegate: MLoadMoreDelegate(),
                                                isFinish:
                                                    snapshot.data.length ==
                                                        pagination.totalCount,
                                                textBuilder: (status) {
                                                  print("in status");
                                                  return status.toString();
                                                },
                                                onLoadMore: () async {
                                                  var result =
                                                      await _topUpNetworkRepository
                                                          .getPaymentHistory(
                                                              page: paymentHistories
                                                                      .value
                                                                      .length ~/
                                                                  10);

                                                  var payments = result
                                                          .resultValue
                                                      as PaymentHistoryPagination;

                                                  paymentHistories.add(
                                                      paymentHistories.value
                                                        ..addAll(payments
                                                            .paymentHistories));

                                                  return true;
                                                },
                                                child: ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return getPackageView(
                                                          snapshot.data[index]);
                                                    }))
                                            : Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      "Loading payment history",
                                                      style: TextStyle(
                                                          color: ColorConstants
                                                              .textColor,
                                                          fontSize: 16),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  ],
                                                ),
                                              );
                                      })),
                              Material(
                                elevation: 1,
                                child: Container(
                                  height: 1,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(6),
                                    top: ScreenUtil().setHeight(33)),
                                alignment: Alignment.center,
                                child: Text(
                                  "Go Back to",
                                  style: TextStyle(
                                      color: ColorConstants.textColor),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(20)),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: RoundedCornerButtonWithBorder(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: 'Top-up',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(35),
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
          }),
    );
  }

  Widget getPackageView(PaymentHistory paymentHistory) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    paymentHistory.dateTime.split("T")[0],
                    style: TextStyle(
                        color: ColorConstants.hintTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        paymentHistory.valueInUnits.toString(),
                        style: TextStyle(
                            color: getTextColor(paymentHistory),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 5, right: 5),
                        child: Image.asset(
                          "assets/credits.png",
                          height: 15,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(
                        paymentHistory.getDisplayString(),
                        style: TextStyle(
                            color: getTextColor(paymentHistory),
                            fontSize: 12,
                            fontWeight: getFontWeight(paymentHistory)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      "assets/credits.png",
                      width: 13,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      paymentHistory.balanceInUnits.toString(),
                      style: TextStyle(
                          color: ColorConstants.hintTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
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

  FontWeight getFontWeight(PaymentHistory paymentHistory) {
    if (paymentHistory.isGift()) {
      return FontWeight.w900;
    }
    if (paymentHistory.isPurchase()) {
      return FontWeight.w600;
    }
    if (paymentHistory.isSpent()) {
      return FontWeight.w500;
    }

    return FontWeight.w500;
  }

  Color getTextColor(PaymentHistory paymentHistory) {
    if (paymentHistory.isSpent()) {
      return ColorConstants.hintTextColor;
    } else {
      return ColorConstants.textColor;
    }
  }
}
