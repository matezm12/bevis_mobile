import 'package:bevis/blocs/blocs/write/write_bloc.dart';
import 'package:bevis/blocs/states/write_asset_states.dart';
import 'package:bevis/factories/bevis_components_factory/bevis_components_factory.dart';
import 'package:bevis/pages/preview/preview_asset_page.dart';
import 'package:bevis/pages/write/widgets/write_page_content.dart';
import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/widgets/barriers/bevis_barrier.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:bevis/widgets/dialogs/bevis_no_action_dialog.dart';
import 'package:bevis/widgets/providers/bevis_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

class WritePage extends StatefulWidget {
  final String assetId;

  WritePage({this.assetId});

  @override
  State<StatefulWidget> createState() {
    return _WritePage(assetId: assetId);
  }
}

class _WritePage extends State<WritePage> {
  String assetId;
  String imageQuality;
  _WritePage({this.assetId});

  @override
  Widget build(BuildContext context) {
    final componentFactory = BevisProvider.of<BevisComponentsFactory>(context);

    return BlocProvider<WriteBloc>(
      create: (context) {
        return WriteBloc(
          mediaPicker: componentFactory.createMediaPicker(),
          filePicker: componentFactory.createFilePicker(),
          bevisAssetMetadataProvider:
              componentFactory.createAssetFileMetadataProvider(),
          assetId: assetId,
        );
      },
      child: BlocListener<WriteBloc, WriteAssetState>(
        listener: (context, state) async {
          if (state is FailedToPrepareFile) {
            showDialog(
              context: context,
              builder: (context) {
                return BevisInfoDialog(
                  title: AlertConstants.ErrorTitle,
                  message: 'Something went wrong. Please try again.',
                );
              },
            );
          }
          if (state is NeedToGrantLocationPermission) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BevisInfoDialog(
                  title: AlertConstants.InfoTitle,
                  message: 'Please allow the app to access location',
                  onOkPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                );
              },
            );
          }

          if (state is BevisFileAssetCreated) {
            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                duration: Duration(milliseconds: 300),
                alignment: Alignment.center,
                child: PreviewAssetPage(
                  imageAssets: state.uploadAsset,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<WriteBloc, WriteAssetState>(
          builder: (context, state) {
            final writePageContent = WritePageContent(
              assetId: state.assetId,
            );

            if (state is PreparingAssetFile) {
              return Stack(
                children: [
                  writePageContent,
                  BevisBarrier(),
                  BevisNoActionDialog(
                    message: 'Preparing file...',
                  ),
                ],
              );
            }

            return writePageContent;
          },
        ),
      ),
    );
  }
}
