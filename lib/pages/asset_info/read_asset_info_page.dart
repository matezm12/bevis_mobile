import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/blocs/asset_info_bloc.dart';
import 'package:bevis/blocs/events/asset_info_events.dart';
import 'package:bevis/blocs/states/asset_info_states.dart';
import 'package:bevis/data/models/asset.dart';
import 'package:bevis/data/repositories/database_repositories/asset_sqlite_db_repository.dart';
import 'package:bevis/data/repositories/database_repositories/db_provider.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/asset_network_repository_imp.dart';
import 'package:bevis/pages/preview/photo_preview.dart';
import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/activity_indicators/bevis_activity_indicator.dart';
import 'package:bevis/widgets/dialogs/bevis_dialog_with_description.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:bevis/widgets/scaffolds/bevis_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';

import 'package:progress_dialog/progress_dialog.dart';

class ReadAssetInfoPage extends StatefulWidget {
  final String walletAddress;

  ReadAssetInfoPage({@required this.walletAddress});

  @override
  State<StatefulWidget> createState() {
    return _ReadAssetInfoPageState();
  }
}

class _ReadAssetInfoPageState extends State<ReadAssetInfoPage> {
  AssetInfoBloc _assetInfoBloc;
  String fileType;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();

    _progressDialog = ProgressDialog(context);

    _assetInfoBloc = AssetInfoBloc(
      networkRepo: AssetNetworkRepositoryImp(
        networkConfig: AppConfig.getInstance().networkConfig,
        client: HttpRestClient(
          httpClient: Client(),
        ),
      ),
      databaseRepo: AssetSqliteDatabaseRepositoryImpl(DBProvider.db),
    );

    _assetInfoBloc.add(LoadAssetInfo(widget.walletAddress));
  }

  @override
  void dispose() {
    _assetInfoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetInfoBlocListener = BlocListener(
      bloc: _assetInfoBloc,
      listener: (context, state) {
        if (state is FailedToLoadAssetInfo) {
          showDialog(
            context: context,
            builder: (context) {
              return BevisDialogWithDescription(
                title: AlertConstants.ErrorTitle,
                description: state.error.errorMsg,
                okButtonTitle: 'Try again',
                onOkPressed: () {
                  Navigator.of(context).pop();
                  _assetInfoBloc.add(LoadAssetInfo(widget.walletAddress));
                },
                onCancelPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              );
            },
          );
        } else if (state is SuccessAddedAsset) {
          print("IN Success");
          _progressDialog.hide();
          Navigator.of(context).pop();
        } else if (state is FailedToAddAsset) {
          _progressDialog.hide();
          showDialog(
            context: context,
            builder: (context) {
              return BevisInfoDialog(
                title: AlertConstants.ErrorTitle,
                message: state.errorMsg,
              );
            },
          );
        }
      },
    );

    return MultiBlocListener(
      listeners: [
        assetInfoBlocListener,
      ],
      child: BlocBuilder(
        bloc: _assetInfoBloc,
        builder: (context, state) {
          if (state is AssetInfoState) {
            final asset = state.asset;
            final isLoading = state.isLoading;
            final scaffold = _buildScaffold(
                asset: asset,
                body: asset != null ? getDisplayValues(asset) : Container());
            if (isLoading) {
              return Stack(
                children: <Widget>[
                  scaffold,
                  Center(
                    child: BevisActivityIndicator(),
                  ),
                ],
              );
            } else {
              return scaffold;
            }
          }

          return _buildScaffold(body: Container());
        },
      ),
    );
  }

  Widget _buildScaffold({Asset asset, @required Widget body}) {
    final fileUrl = asset?.product?.img;

    return BevisScaffold(
      title: 'Asset Info',
      appBarActions: [
        Container(
          height: 30,
          padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(16),
          ),
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _progressDialog.show();
                _progressDialog.update(
                  message: "Adding to your list",
                  messageTextStyle:
                      TextStyle(fontSize: 12, color: ColorConstants.textColor),
                );
                _assetInfoBloc.add(AddAsset(asset: asset));
              },
              child: Text(
                "ADD",
                style: TextStyle(color: ColorConstants.textColor),
              ),
            ),
          ),
        ),
      ],
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                duration: Duration(milliseconds: 300),
                                alignment: Alignment.center,
                                child: PhotoPreviewScreen(
                                  imagePath: fileUrl == null ? "ss" : fileUrl,
                                  netWork: true,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'imageHero',
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: fileUrl != null
                                  ? SingleChildScrollView(
                                      child: Image.network(
                                        fileUrl == null ? "ss" : fileUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      "assets/placeholder-vertical.jpg",
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      asset != null
                          ? Container(
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(right: 15),
                                      width: 80,
                                      child: Text(
                                        "Asset Type",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ColorConstants.textColor,
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          asset.assetType != null &&
                                                  asset.assetType.name != null
                                              ? asset.assetType.name
                                              : "N/A",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: ColorConstants.textColor,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      Divider(),
                      body,
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getDisplayValues(Asset asset) {
    var detailValues = <Widget>[];

    asset.displayValues.forEach((element) {
      if (element.fieldName.contains("documentFormat")) {
        fileType = element.fieldValue;
        print("file type" + fileType);
      }
      var row = Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 15),
              width: 80,
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
        ],
      );
      var divider = Divider();
      detailValues.add(row);
      detailValues.add(divider);
    });

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: detailValues,
      ),
    );
  }
}
