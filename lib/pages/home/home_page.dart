import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/blocs/asset_list_bloc.dart';
import 'package:bevis/blocs/blocs/balance_bloc.dart';
import 'package:bevis/blocs/blocs/home_page/home_page_bloc.dart';
import 'package:bevis/blocs/blocs/home_page/states/home_page_states.dart';
import 'package:bevis/blocs/blocs/logout/logout_bloc.dart';
import 'package:bevis/blocs/events/asset_list_events.dart';
import 'package:bevis/blocs/events/balance_event_bloc.dart';
import 'package:bevis/blocs/states/asset_list_states.dart';
import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/models/bevis_asset.dart';
import 'package:bevis/data/repositories/database_repositories/asset_sqlite_db_repository.dart';
import 'package:bevis/data/repositories/database_repositories/db_provider.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/asset_network_repository_imp.dart';
import 'package:bevis/data/repositories/network_repositories/http/balance_network_repositoryImpl.dart';
import 'package:bevis/data/top_up/payment_history.dart';
import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/asset_detail/asset_detail_page.dart';
import 'package:bevis/pages/asset_info/read_asset_info_page.dart';
import 'package:bevis/pages/home/widgets/asset_preview_icon.dart';
import 'package:bevis/pages/home/widgets/bottom_menu/bottom_menu.dart';
import 'package:bevis/pages/home/widgets/menu/menu.dart';
import 'package:bevis/pages/home/widgets/sort_creteria_button.dart';
import 'package:bevis/pages/main_flow/scan_code_page.dart';
import 'package:bevis/pages/onboarding/tutorial_page.dart';
import 'package:bevis/pages/preview/photo_preview.dart';
import 'package:bevis/pages/setting/Setting.dart';
import 'package:bevis/pages/top_up/top_up_screen.dart';
import 'package:bevis/pages/write/write_page.dart';
import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/MLoadMoreDelegate.dart';
import 'package:bevis/widgets/activity_indicators/bevis_activity_indicator.dart';
import 'package:bevis/widgets/asset/asset_info.dart';
import 'package:bevis/widgets/dialogs/bevis_choice_dialog.dart';
import 'package:bevis/widgets/dialogs/bevis_dialog_with_description.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:bevis/widgets/providers/bevis_provider.dart';
import 'package:bevis/widgets/scaffolds/bevis_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:loadmore/loadmore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  final bool logInFirstTime;

  const HomePage({Key key, this.logInFirstTime = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  AssetListBloc _assetListBloc;

  LogoutBloc _logOutbloc;
  HomePageBloc _homePageBloc;
  BalanceInfoBloc _balanceInfoBloc;
  BehaviorSubject<Asset> _selectedAssetInfo = BehaviorSubject();
  AssetNetworkRepository _assetNetworkRepository;

  bool sortByDate = true;
  bool sortByName = false;
  bool sortByType = false;
  BlocListener _assetListener;
  BlocListener<LogoutBloc, LogOutState> _logoutListener;
  final BehaviorSubject<List<BevisAsset>> bevisAssetsController =
      BehaviorSubject<List<BevisAsset>>();
  final BehaviorSubject<Pagination> pagination = BehaviorSubject<Pagination>();

  @override
  void dispose() {
    super.dispose();

    _selectedAssetInfo?.close();
    bevisAssetsController?.close();
    pagination?.close();
  }

  @override
  void initState() {
    super.initState();

    _assetNetworkRepository = AssetNetworkRepositoryImp(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    );
    _logOutbloc = LogoutBloc(AssetSqliteDatabaseRepositoryImpl(DBProvider.db));
    _balanceInfoBloc = BalanceInfoBloc(
        balanceNetworkRepository: BalanceNetworkRepositoryImpl(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    ));
    _assetListBloc = AssetListBloc(
      coinDbRepo: AssetSqliteDatabaseRepositoryImpl(DBProvider.db),
      assetNetworkRepository: AssetNetworkRepositoryImp(
        networkConfig: AppConfig.getInstance().networkConfig,
        client: HttpRestClient(
          httpClient: Client(),
        ),
      ),
    );

    _assetListener = BlocListener<AssetListBloc, AssetListState>(
        bloc: _assetListBloc,
        listener: (context, state) {
          // do stuff here based on BlocA's state
          if (state is AssetListState) {
            bevisAssetsController.add(state.bevisAssetPagination.assets);
            pagination.add(state.bevisAssetPagination.pagination);
          }
        });

    _logoutListener = BlocListener(
        bloc: _logOutbloc,
        listener: (context, state) {
          if (state is LogOutSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.center,
                child: TutorialPage(),
              ),
              (route) => false,
            );
          }
        });

    _assetListBloc.add(LoadAssetList(widget.logInFirstTime));

    _balanceInfoBloc.add(LoadBalanceInfo());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final componentFactory = BevisProvider.of<BevisComponentsFactory>(context);

    _homePageBloc = HomePageBloc(
      appVersionProvider: componentFactory.createAppVersionProvider(),
    );
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
    print("status bar height" + "here" + statusBarHeight.toString());

    return BlocProvider<HomePageBloc>(
      create: (context) => _homePageBloc,
      child: MultiBlocListener(
        listeners: [
          _assetListener,
          _logoutListener,
        ],
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            return BevisScaffold(
              title: 'MY ASSETS',
              subtitle: 'Bevis v${state.appVersion ?? ''}',
              appBarLeading: Menu(
                biometricLoginEnabled: isEnableBiometri,
                onSelectedMenuItem: (selectedMenuItem) async {
                  switch (selectedMenuItem) {
                    case MenuItemType.myAssets:
                      break;
                    case MenuItemType.topUp:
                      _showTopUp();
                      break;
                    case MenuItemType.settings:
                      _showSetting();
                      break;
                    case MenuItemType.biometricLogin:
                      var localAuth = LocalAuthentication();

                      bool didAuthenticate = await localAuth.authenticate(
                        localizedReason:
                            'Please authenticate to login into your account',
                        biometricOnly: true,
                      );

                      if (didAuthenticate) {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        isEnableBiometri =
                            sharedPreferences.getBool("bio") ?? false;
                        if (isEnableBiometri) {
                          sharedPreferences.setBool("bio", !isEnableBiometri);
                          sharedPreferences.setString("email", "");
                          sharedPreferences.setString("pass", "");
                          sharedPreferences.setString("social", "");
                        } else {
                          sharedPreferences.setBool("bio", !isEnableBiometri);
                          sharedPreferences.setString("email", email);
                          sharedPreferences.setString("pass", password);
                          sharedPreferences.setString("social", socialType);
                        }
                        isEnableBiometri = !isEnableBiometri;
                        setState(() {});
                      }

                      break;
                    case MenuItemType.logout:
                      _logOutbloc.add(LogoutEvent());
                      break;
                  }
                },
              ),
              body: Column(
                children: <Widget>[
                  Divider(
                    height: 3,
                    thickness: 2.5,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 26),
                    child: StreamBuilder<Pagination>(
                      stream: pagination,
                      builder: (context, snapshot) {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'number of assets: ',
                            style: TextStyle(
                              color: ColorConstants.textColor,
                              fontSize: 12,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: snapshot.hasData
                                    ? snapshot.data.totalCount.toString()
                                    : "N/A",
                                style: TextStyle(
                                  color: ColorConstants.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 24,
                    margin: const EdgeInsets.only(
                      right: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(34),
                          ),
                          child: Text(
                            "Sort by:",
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.textColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SortCriteriaButton(
                          isActive: sortByName,
                          title: 'name',
                          onPressed: () {
                            bevisAssetsController.add(null);

                            _assetListBloc.add(SortAssetByName());

                            setState(() {
                              sortByDate = false;
                              sortByName = true;
                              sortByType = false;
                            });
                          },
                        ),
                        SortCriteriaButton(
                          isActive: sortByType,
                          title: "asset type",
                          onPressed: () {
                            bevisAssetsController.add(null);
                            _assetListBloc.add(SortAssetByType());

                            setState(() {
                              sortByDate = false;
                              sortByName = false;
                              sortByType = true;
                            });
                          },
                        ),
                        SortCriteriaButton(
                          isActive: sortByDate,
                          title: "date created",
                          onPressed: () {
                            bevisAssetsController.add(null);

                            _assetListBloc.add(SortAssetByDate());
                            setState(() {
                              sortByDate = true;
                              sortByName = false;
                              sortByType = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 26),
                      child: StreamBuilder<List<BevisAsset>>(
                          stream: bevisAssetsController.stream,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? snapshot.data.isNotEmpty
                                    ? LoadMore(
                                        isFinish: snapshot.data.length ==
                                            pagination.value.totalCount,
                                        delegate: MLoadMoreDelegate(),
                                        onLoadMore: () async {
                                          print("on load more");
                                          String sortBy = "masterGenDate,desc";
                                          if (sortByName) {
                                            sortBy = "name,asc";
                                          }
                                          if (sortByType) {
                                            sortBy = "masterAssetTypeKey,asc";
                                          }
                                          var result =
                                              await _assetNetworkRepository
                                                  .getAssets(
                                                      page:
                                                          bevisAssetsController
                                                                  .value
                                                                  .length ~/
                                                              10,
                                                      sortBy: sortBy);
                                          var bevisAsset = result.resultValue
                                              as BevisAssetPagination;
                                          bevisAssetsController.add(
                                              bevisAssetsController.value
                                                ..addAll(bevisAsset.assets));
                                          return true;
                                        },
                                        child: ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return assetItemView(
                                                  snapshot.data[index]);
                                            }),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(
                                                    bottom: ScreenUtil()
                                                        .setHeight(8)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Create your\nfirst Asset",
                                                  style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorConstants
                                                          .textColor),
                                                  textAlign: TextAlign.center,
                                                )),
                                            Container(
                                                height:
                                                    ScreenUtil().setHeight(27),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "use the buttons below",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: ColorConstants
                                                          .textColor),
                                                  textAlign: TextAlign.center,
                                                ))
                                          ],
                                        ),
                                      )
                                : Container(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Loading asset list from server"),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      BevisActivityIndicator(),
                                    ],
                                  ));
                          }),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      ScreenUtil().setHeight(20),
                    ),
                    child: BottomMenu(
                      onScanPressed: () async {
                        print("on presss");
                        PermissionStatus isShown =
                            await Permission.camera.status;

                        switch (isShown) {
                          case PermissionStatus.granted:
                            {
                              print("granted");
                              _showScanner();
                            }
                            break;
                          case PermissionStatus.denied:
                            {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BevisInfoDialog(
                                    title: AlertConstants.InfoTitle,
                                    message:
                                        'Please allow the app to access camera to scan QR code',
                                    onOkPressed: () {
                                      Navigator.of(context).pop();
                                      openAppSettings();
                                    },
                                  );
                                },
                              );
                            }
                            break;
                          case PermissionStatus.limited:
                            break;
                          case PermissionStatus.restricted:
                            break;
                          case PermissionStatus.permanentlyDenied:
                            break;
                        }
                      },
                      onWritePressed: () {
                        _showWrite();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget assetItemView(BevisAsset asset) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(31),
        right: ScreenUtil().setWidth(29),
        bottom: 12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _settingModalBottomSheet(context, asset);
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 14,
                margin: EdgeInsets.only(left: 12, top: 9, right: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        asset.assetTypeName != null
                            ? asset.assetTypeName
                            : "N/A",
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "created: " + asset.createdDate,
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorConstants.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 15, left: ScreenUtil().setWidth(22)),
                child: Row(
                  children: <Widget>[
                    AssetPreviewIcon(asset),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 27),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              asset.assetId,
                              style: TextStyle(
                                color: ColorConstants.textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              asset.name == null ? "" : asset.name,
                              style: TextStyle(
                                  color: ColorConstants.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    asset.coinInfo != null
                        ? Container(
                            padding: EdgeInsets.only(
                              right: 10,
                              left: 10,
                              top: 5,
                            ),
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  asset.coinInfo != null
                                      ? asset.coinInfo
                                              .destinationCurrencyBalance
                                              .toString() +
                                          " " +
                                          asset.coinInfo.destinationCurrency
                                      : "",
                                  style: TextStyle(
                                    color: ColorConstants.textColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  asset.coinInfo != null
                                      ? asset.coinInfo.sourceCurrencyBalance
                                              .toString() +
                                          " " +
                                          asset.coinInfo.currency
                                      : "",
                                  style: TextStyle(
                                    color: ColorConstants.textColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(
                          right: 10,
                          top: 5,
                        ),
                        height: 20,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipOval(
                              child: Container(
                                width: 4,
                                height: 4,
                                color: ColorConstants.textColor,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            ClipOval(
                              child: Container(
                                color: ColorConstants.textColor,
                                width: 4,
                                height: 4,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            ClipOval(
                              child: Container(
                                width: 4,
                                height: 4,
                                color: ColorConstants.textColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ColorConstants.borderColor,
        ),
      ),
    );
  }

  Widget buildAssetsList(AssetListState state) {
    return state.isLoading
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Loading asset list from server"),
                SizedBox(
                  height: 20,
                ),
                BevisActivityIndicator(),
              ],
            ),
          )
        : state.bevisAssetPagination.assets.isNotEmpty
            ? Container(
                child: ListView.builder(
                  itemCount: state.bevisAssetPagination.assets.length,
                  itemBuilder: (context, index) {
                    return assetItemView(
                        state.bevisAssetPagination.assets[index]);
                  },
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                      alignment: Alignment.center,
                      child: Text(
                        "Create your\nfirst Asset",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(27),
                      alignment: Alignment.center,
                      child: Text(
                        "use the buttons below",
                        style: TextStyle(
                            fontSize: 20, color: ColorConstants.textColor),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              );
  }

  void _showSetting() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: SettingPage()));
  }

  void _showTopUp() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        child: TopUpPage(),
      ),
    );
  }

  void _showScanner() async {
    final scannedWalletAddress = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: ScanCodePage()));

    if (scannedWalletAddress != null) {
      debugPrint('Did scan coin with address: $scannedWalletAddress');

      await Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              child: ReadAssetInfoPage(
                walletAddress: scannedWalletAddress,
              )));
    }
    _assetListBloc.add(LoadAssetList(false));
  }

  void _showWrite({String assetId}) async {
    await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        child: WritePage(
          assetId: assetId,
        ),
      ),
    );

    print("finish writing");
    _assetListBloc.add(LoadAssetList(widget.logInFirstTime));
    _balanceInfoBloc.add(LoadBalanceInfo());
  }

  void _settingModalBottomSheet(context, BevisAsset basset) {
    Asset asset;
    _selectedAssetInfo.add(null);
    print("bevis  asset" + basset.toString());
    _assetListBloc
        .getAssetInfo(basset.assetId)
        .then((value) => _selectedAssetInfo.add(value));
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.white,
          child: StreamBuilder<Asset>(
            stream: _selectedAssetInfo.stream,
            builder: (context, snapshot) {
              asset = snapshot.data;
              return snapshot.hasData
                  ? Container(
                      child: Wrap(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(25),
                                  left: ScreenUtil().setWidth(31),
                                  right: ScreenUtil().setHeight(31)),
                              child: new Wrap(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: AssetPreviewIcon(basset),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left:
                                                    ScreenUtil().setWidth(15)),
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    height: ScreenUtil()
                                                        .setHeight(16),
                                                    child: Text(
                                                      basset.assetId,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorConstants
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                basset.name != null
                                                    ? Container(
                                                        height: ScreenUtil()
                                                            .setHeight(16),
                                                        child: Text(basset.name,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: ColorConstants
                                                                  .hintTextColor,
                                                            )),
                                                      )
                                                    : Container(),
                                                Text(
                                                    asset.assetType != null
                                                        ? asset.assetType.name
                                                        : "N/A",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: ColorConstants
                                                          .hintTextColor,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text("created: " + basset.createdDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: ColorConstants.textColor,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(80),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                    ),
                                    child: Container(
                                      child: AssetInfo(
                                        asset: asset,
                                        onPublicKeyTapped: (publicKey) {
                                          Toast.show("Copied", context);
                                          Clipboard.setData(
                                              ClipboardData(text: publicKey));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              )),
                          Container(
                            color: Colors.black,
                            child: Material(
                              elevation: 5,
                              child: SafeArea(
                                top: false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20),
                                      right: ScreenUtil().setWidth(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .leftToRightWithFade,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  alignment: Alignment.center,
                                                  child: AssetDetailPage(
                                                      basset.assetId),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/bottom_sheet/view_asset.png"),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "View",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .textColor,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              _showWrite(
                                                  assetId: basset.assetId);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/bottom_sheet/add.png",
                                                  color:
                                                      ColorConstants.textColor,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .textColor,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              showRenameDialog(context, basset);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/bottom_sheet/rename.png"),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "Rename",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .textColor,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              deleteDialog(context, basset);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/bottom_sheet/delete.png"),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .colorAppRed,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Wrap(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(25),
                                  left: ScreenUtil().setWidth(31),
                                  right: ScreenUtil().setHeight(31)),
                              child: new Wrap(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 50,
                                          height: 50,
                                          child: basset.fileType
                                                  .toLowerCase()
                                                  .contains("pdf")
                                              ? Image.asset(
                                                  "assets/pdf.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    print("File url" +
                                                        basset.fileUrl
                                                            .toString());
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeftWithFade,
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            PhotoPreviewScreen(
                                                          imagePath:
                                                              basset.fileUrl,
                                                          netWork: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        basset.fileUrl != null
                                                            ? basset.fileUrl
                                                            : "",
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Image.asset(
                                                            "assets/placeholder-vertical.jpg"),
                                                    errorWidget: (context, url,
                                                            obj) =>
                                                        Image.asset(
                                                            "assets/placeholder-vertical.jpg"),
                                                  ),
                                                ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left:
                                                    ScreenUtil().setWidth(15)),
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    height: ScreenUtil()
                                                        .setHeight(16),
                                                    child: Text(
                                                      basset.assetId,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: ColorConstants
                                                              .textColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                basset.name != null
                                                    ? Container(
                                                        height: ScreenUtil()
                                                            .setHeight(16),
                                                        child: Text(basset.name,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: ColorConstants
                                                                  .hintTextColor,
                                                            )),
                                                      )
                                                    : Container(),
                                                Text(
                                                    basset.assetTypeName != null
                                                        ? basset.assetTypeName
                                                        : "N/A",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: ColorConstants
                                                          .hintTextColor,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text("created: " + basset.createdDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: ColorConstants.textColor,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(80),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                    ),
                                    child: Container(
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                                "Loading asset Info from server"),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: BevisActivityIndicator(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              )),
                          Container(
                            color: Colors.black,
                            child: Material(
                              elevation: 5,
                              child: SafeArea(
                                top: false,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20),
                                      right: ScreenUtil().setWidth(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .leftToRightWithFade,
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  alignment: Alignment.center,
                                                  child: AssetDetailPage(
                                                      basset.assetId),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/bottom_sheet/view_asset.png"),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "View",
                                                  style: TextStyle(
                                                    color: ColorConstants
                                                        .textColor,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {
                                              _showWrite(
                                                  assetId: basset.assetId);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/bottom_sheet/add.png",
                                                  color:
                                                      ColorConstants.textColor,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "Add",
                                                  style: TextStyle(
                                                    color: ColorConstants
                                                        .textColor,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              showRenameDialog(context, basset);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/bottom_sheet/rename.png"),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "Rename",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .textColor,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: ScreenUtil().setHeight(35),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              deleteDialog(context, basset);
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.asset(
                                                    "assets/bottom_sheet/delete.png"),
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .colorAppRed,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
            },
          ),
        );
      },
    );
  }

  void deleteDialog(BuildContext context, BevisAsset basset) {
    showDialog(
      context: context,
      builder: (context) {
        return BevisDialogWithDescription(
          title: 'Warning',
          description: 'Are you sure want to delete from your list',
          onOkPressed: () {
            _assetListBloc.add(DeleteAsset(asset: basset));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void showRenameDialog(BuildContext context, BevisAsset basset) {
    var assetCodeTextController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return BevisChoiceDialog(
            title: 'Please enter Asset ID',
            dialogBody: TextFormField(
              controller: assetCodeTextController,
              decoration: InputDecoration(
                labelText: "Nick Name",
                hintText: "Nick Name",
              ),
            ),
            onOkPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              if (assetCodeTextController.text.length > 0) {
                _assetListBloc.add(
                  RenameAsset(
                    asset: basset,
                    newName: assetCodeTextController.text,
                  ),
                );
              }
            },
          );
        });
  }

  String fileUrl = "";
}
