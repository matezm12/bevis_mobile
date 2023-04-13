import 'dart:io';

import 'package:bevis/utils/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String imagePath;
  final File imageFile;
  final bool netWork;

  const PhotoPreviewScreen({Key key, this.imagePath, this.imageFile, this.netWork = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Hero(
                tag: 'imageHero',
                child: PhotoView(
                  imageProvider: netWork
                      ? NetworkImage(imagePath)
                      : FileImage(imageFile),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorConstants.colorAppRed,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
