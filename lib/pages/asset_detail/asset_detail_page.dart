import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/blocs/asset_detail_bloc.dart';
import 'package:bevis/blocs/events/asset_detail_bloc.dart';
import 'package:bevis/blocs/states/asset_detail_state.dart';
import 'package:bevis/data/asset_detail.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/asset_network_repository_imp.dart';
import 'package:bevis/pages/preview/photo_preview.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/scaffolds/bevis_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AssetDetailPage extends StatefulWidget {
  final String assetId;

  AssetDetailPage(this.assetId);

  @override
  State<StatefulWidget> createState() {
    return AssetDetailPageState();
  }
}

class AssetDetailPageState extends State<AssetDetailPage> {
  AssetDetailBloc _assetDetailBloc;
  SwiperControl _swiperControl = SwiperControl(
      disableColor: Colors.black, color: ColorConstants.colorAppRed);
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(375, 723),
    );

    return BlocBuilder(
      bloc: _assetDetailBloc,
      builder: (context, state) {
        List<AssetFile> list = <AssetFile>[];
        if (state is AssetFilesState) {
          list = state.files;
          print("Loading" + state.isLoading.toString());
        }

        return BevisScaffold(
          title: 'Asset Detail',
          appBarActions: [
            IconButton(
              padding: EdgeInsets.all(16),
              iconSize: 30,
              onPressed: () {
                Share.share(list[currentIndex].url,
                    subject: 'Share from bevis');
              },
              icon: Icon(
                Icons.share,
                color: ColorConstants.textColor,
              ),
            ),
          ],
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: list.isEmpty
                        ? state.isLoading
                            ? Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                child: Center(
                                  child: Text("Not avaiable"),
                                ),
                              )
                        : Swiper(
                            itemWidth: MediaQuery.of(context).size.width,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height -
                                    ScreenUtil().setHeight(110),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: getView(list[index]),
                              );
                            },
                            physics: CustomScrollPhysics(),
                            autoplay: false,
                            itemCount: list?.length ?? 0,
                            onIndexChanged: (index) {
                              currentIndex = index;
                            },
                            curve: Curves.easeInCirc,
                            indicatorLayout: PageIndicatorLayout.WARM,
                            loop: false,
                            pagination: new SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                    color: Colors.black38,
                                    activeColor: ColorConstants.colorAppRed,
                                    size: 10.0,
                                    activeSize: 15.0,
                                    space: 10.0)),
                            control: _swiperControl,
                          ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static const scale = 100.0 / 72.0;

  Widget getView(AssetFile file) {
    if (file.encrypted) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'This file is encrypted. Please tap on the icon below to download it',
            style: Theme.of(context).primaryTextTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              if (await canLaunch(file.url)) {
                launch(file.url);
              }
            },
            child: Container(
              child: SvgPicture.asset(
                'assets/asset_details/asset_file_encrypted_placeholder.svg',
                fit: BoxFit.contain,
                //width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ],
      );
    }
    if (file.fileType.contains("HTM")) {
      return WebView(
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: file.url);
    } else if (file.isImage()) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,
              child: PhotoPreviewScreen(
                imagePath: file.url,
                netWork: true,
              ),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: file.url,
          placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child: Container(
                  width: 50, height: 50, child: CircularProgressIndicator())),
        ),
      );
    } else if (file.isPDF()) {
      print("Here pdf" + file.url);
      return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl:
              "https://docs.google.com/gview?embedded=true&url=" + file.url);
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();

    _assetDetailBloc = AssetDetailBloc(
        assetNetworkRepository: AssetNetworkRepositoryImp(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    ));

    _assetDetailBloc.add(LoadAssetDetailEvent(widget.assetId));
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  final double itemDimension;

  CustomScrollPhysics({this.itemDimension, ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(
        itemDimension: itemDimension, parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    print("in shouldAcceptUserOffset");

    return (position.axisDirection == AxisDirection.right ||
            position.axisDirection == AxisDirection.left) &&
        position.atEdge;
  }

  @override
  bool get allowImplicitScrolling => true;
}
