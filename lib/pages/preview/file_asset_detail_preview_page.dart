import 'package:bevis/data/models/image_asset.dart';
import 'package:bevis/pages/preview/photo_preview.dart';
import 'package:bevis/pages/preview/widgets/asset_icon_preview_widget.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class FileAssetDetailPage extends StatelessWidget {
  final BevisUploadAssets imageAssets;

  const FileAssetDetailPage({
    Key key,
    this.imageAssets,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: 300),
                          alignment: Alignment.center,
                          child: PhotoPreviewScreen(
                            imageFile: imageAssets.pickedFile.file,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: "imageHero",
                      child: Container(
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                        height: 160,
                        width: 160,
                        alignment: Alignment.centerLeft,
                        child: AssetIconPreviewWidget(
                          assetFile: imageAssets,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  width: ScreenUtil().setWidth(80),
                                  child: Text(
                                    "File size  ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    imageAssets.fileSize,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width: ScreenUtil().setWidth(80),
                                  child: Text(
                                    "File Type",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    imageAssets.fileType,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width: ScreenUtil().setWidth(80),
                                  child: Text(
                                    "Resolution  ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    imageAssets.resolution ?? 'N/A',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(15),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width: ScreenUtil().setWidth(80),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    imageAssets.date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorConstants.textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "Document Id  ",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Expanded(
                      child: Container(
                        child: Text(
                          imageAssets.documentId,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "IP address",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Expanded(
                        child: Text(
                      imageAssets.ipAddress,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    ))
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "Country",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Expanded(
                        child: Text(
                      imageAssets.country,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    ))
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "GPS Location",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Expanded(
                        child: Text(
                      imageAssets.gps,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    ))
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "Device Id",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Expanded(
                        child: Text(
                      imageAssets.deviceID,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    ))
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "Brand",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Text(
                      imageAssets.brand,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "Model",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Text(
                      imageAssets.model,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(140),
                        child: Text(
                          "Operating System",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.textColor,
                          ),
                        )),
                    Text(
                      imageAssets.operatingSystem,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
