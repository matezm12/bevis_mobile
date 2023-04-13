import 'package:bevis/blocs/blocs/scan_code_bloc.dart';
import 'package:bevis/blocs/states/scan_code_states.dart';
import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bevis/widgets/dialogs/bevis_choice_dialog.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  ScanCodeBloc _scanCodeBloc;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();

    _scanCodeBloc = ScanCodeBloc();
  }

  @override
  void dispose() {
    _scanCodeBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(375, 723),
    );

    return BlocListener(
      bloc: _scanCodeBloc,
      listener: (context, state) {
        if (state is ScanningFailed) {
          showDialog(
              context: context,
              builder: (context) {
                return BevisInfoDialog(
                  title: AlertConstants.ErrorTitle,
                  message: state.reason,
                  onOkPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              });
        } else if (state is ScannerDidScanAsset) {
          Navigator.of(context).pop(state.publicKey);
        }
      },
      child: _buildScaffoldWithBody(_buildScanCodeView()),
    );
  }

  Widget _buildScaffoldWithBody(Widget body) {
    return Scaffold(
      body: SafeArea(
        child: body,
      ),
    );
  }

  Widget _buildScanCodeView() {
    const buttonWidth = 300.0;

    final qrView = QRView(
      key: qrKey,
      onQRViewCreated: (qrScanController) {
        _scanCodeBloc.add(
          StartScanning(
            qrScanController.scannedDataStream.map((barcode) => barcode.code),
          ),
        );
      },
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
      ),
    );

    return Stack(
      children: <Widget>[
        Container(
          child: qrView,
        ),
        Positioned(
          height: ScreenUtil().setHeight(34),
          width: buttonWidth,
          left: MediaQuery.of(context).size.width / 2 - buttonWidth / 2,
          bottom: ScreenUtil().setHeight(105),
          child: Container(
            height: ScreenUtil().setHeight(34),
            child: RedBevisButton(
              title: 'Enter Asset ID manually',
              onPressed: () {
                final assetCodeTextController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (context) {
                    return BevisChoiceDialog(
                      title: 'Please enter Asset ID',
                      dialogBody: TextField(
                        controller: assetCodeTextController,
                      ),
                      onOkPressed: () {
                        Navigator.of(context).pop();
                        if (assetCodeTextController.text.length > 0) {
                          Navigator.of(context)
                              .pop(assetCodeTextController.text);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: ScreenUtil().setHeight(62),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Go back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: ScreenUtil().setHeight(12),
                      color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
