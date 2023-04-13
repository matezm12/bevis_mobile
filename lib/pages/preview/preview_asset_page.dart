import 'package:bevis/app/app_config.dart';
import 'package:bevis/blocs/blocs/preview/preview_asset_bloc.dart';
import 'package:bevis/blocs/blocs/preview/preview_asset_events.dart';
import 'package:bevis/blocs/blocs/preview/preview_asset_states.dart';
import 'package:bevis/data/models/image_asset.dart';
import 'package:bevis/data/repositories/network_repositories/asset_network_repository.dart';
import 'package:bevis/data/repositories/network_repositories/clients/http_rest_client.dart';
import 'package:bevis/data/repositories/network_repositories/http/asset_network_repository_imp.dart';
import 'package:bevis/helpers/asset_file_encoder/implementations/zip_asset_file_encoder.dart';
import 'package:bevis/pages/preview/file_asset_detail_preview_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bevis/widgets/buttons/rounded_corner_button_with_border.dart';
import 'package:bevis/widgets/checkboxes/circular_checkbox.dart';
import 'package:bevis/widgets/dialogs/bevis_choice_dialog.dart';
import 'package:bevis/widgets/dialogs/bevis_dialog_with_description.dart';
import 'package:bevis/widgets/dialogs/bevis_info_dialog.dart';
import 'package:bevis/widgets/dialogs/protect_asset/edit_asset_password_dialog.dart';
import 'package:bevis/widgets/dialogs/protect_asset/protect_asset_dialog.dart';
import 'package:bevis/widgets/preview/asset_protection_widget.dart';
import 'package:bevis/widgets/scaffolds/bevis_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewAssetPage extends StatefulWidget {
  final BevisUploadAssets imageAssets;

  const PreviewAssetPage({Key key, this.imageAssets}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PreviewAssetPageState();
  }
}

class _PreviewAssetPageState extends State<PreviewAssetPage> {
  ProgressDialog _progressDialog;
  String bitcoin;
  AssetNetworkRepository assetNetworkRepository;
  PreviewAssetBloc _previewAssetBloc;

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context);

    return BlocListener<PreviewAssetBloc, PreviewAssetState>(
      bloc: _previewAssetBloc,
      listener: (context, state) async {
        _progressDialog.hide();

        if (state is ShowProtectAssetWithPasswordPopup) {
          showDialog<String>(
            context: context,
            builder: (context) {
              return BlocBuilder<PreviewAssetBloc, PreviewAssetState>(
                bloc: _previewAssetBloc,
                builder: (context, state) {
                  String formValidationError;

                  if (state.protectAssetFormState
                          .protectAssetFormValidationFailureReason !=
                      null) {
                    switch (state.protectAssetFormState
                        .protectAssetFormValidationFailureReason) {
                      case ProtectAssetFormValidationFailureReason
                          .passwordsDoNotMatch:
                        formValidationError =
                            'Password and Repeat password values should match';
                        break;
                    }
                  }

                  return ProtectAssetDialog(
                    dialogInputDidChange: (password, repeatPassword) {
                      _previewAssetBloc.add(
                        ProtectAssetFormInputHasChanged(
                            password, repeatPassword),
                      );
                    },
                    formValidationErrorMessage: formValidationError,
                    onSubmitDialog:
                        (submittedPassword, submittedRepeatPassword) {
                      _previewAssetBloc.add(
                        PasswordProtectAsset(
                            submittedPassword, submittedRepeatPassword),
                      );
                    },
                    okEnabled:
                        state.protectAssetFormState.isSubmitButtonEnabled,
                  );
                },
              );
            },
          );
        } else if (state is PasswordProtectSuccess) {
          Navigator.of(context).pop();
        } else if (state is ShowEditAssetPasswordDialog) {
          showDialog<String>(
            context: context,
            builder: (context) {
              return BlocBuilder<PreviewAssetBloc, PreviewAssetState>(
                bloc: _previewAssetBloc,
                builder: (context, state) {
                  String formValidationError;

                  if (state.editAssetPasswordFormState
                          .editAssetPasswordFromValidationFailureReason !=
                      null) {
                    switch (state.editAssetPasswordFormState
                        .editAssetPasswordFromValidationFailureReason) {
                      case EditAssetPasswordFromValidationFailureReason
                          .wrongOldPassword:
                        formValidationError = 'Old Password value is incorrect';
                        break;
                      case EditAssetPasswordFromValidationFailureReason
                          .passwordsDoNotMatch:
                        formValidationError =
                            'Password and Repeat password values should match';
                        break;
                      case EditAssetPasswordFromValidationFailureReason
                          .newPasswordEqualsOld:
                        formValidationError =
                            'New Password should be different from the Old Password';
                    }
                  }

                  return EditAssetPasswordDialog(
                    dialogInputDidChange:
                        (oldPassword, password, repeatPassword) {
                      _previewAssetBloc.add(
                        EditAssetProtectionPasswordInputChanged(
                            oldPassword, password, repeatPassword),
                      );
                    },
                    formValidationErrorMessage: formValidationError,
                    onSubmit: (oldPassword, submittedPassword,
                        submittedRepeatPassword) {
                      _previewAssetBloc.add(
                        ChangeAssetProtectionPassword(
                          oldPassword,
                          submittedPassword,
                          submittedRepeatPassword,
                        ),
                      );
                    },
                    isSubmitButtonEnabled:
                        state.editAssetPasswordFormState.isSubmitButtonEnabled,
                    onRemovePassword: () {
                      _previewAssetBloc.add(UnprotectAsset());
                    },
                  );
                },
              );
            },
          );
        } else if (state is EditAssetPasswordSuccess) {
          Navigator.of(context).pop();
        } else if (state is EncodingAssetState) {
          _progressDialog.show();
          _progressDialog.update(
              message: "Encoding your asset...",
              messageTextStyle:
                  TextStyle(fontSize: 12, color: ColorConstants.textColor));
        } else if (state is FailedToEncodeAssetState) {
          _progressDialog.hide();
          showDialog(
              context: context,
              builder: (context) {
                return BevisChoiceDialog(
                  title: 'Error',
                  dialogBody: Text('Failed to encode asset'),
                  onOkPressed: () => Navigator.of(context).pop(),
                );
              });
        } else if (state is WritingToBlockchainState) {
          //Temp hack to workaround the issue with Progress Dialog where it awaits 200 millisecods before setting _isShown to true
          await Future.delayed(Duration(milliseconds: 200));
          _progressDialog.show();
          _progressDialog.update(
              message: "Writing to the blockchain",
              messageTextStyle:
                  TextStyle(fontSize: 12, color: ColorConstants.textColor));
        } else if (state is WriteToBlockchainSuccess) {
          _progressDialog.hide();
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is WriteToBlockchainFailure) {
          _progressDialog.hide();

          showDialog(
            context: context,
            builder: (context) {
              return BevisInfoDialog(
                title: 'Error',
                message:
                    'Could not write your asset to the blockchain. Please try again',
              );
            },
          );
        }
      },
      child: BlocBuilder(
        bloc: _previewAssetBloc,
        builder: (context, PreviewAssetState state) {
          final filePreviewPageScaffold = BevisScaffold(
            title: 'WRITE',
            subtitle: 'to the blockchain',
            body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  FileAssetDetailPage(
                    imageAssets: state.uploadAssets,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AssetProtectionWidget(
                    isAssetProtected: state.assetProtected,
                    onPasswordActionButtonPressed: () async {
                      if (state.assetProtected) {
                        _previewAssetBloc
                            .add(EditAssetProtectionPasswordButtonTapped());
                      } else {
                        _previewAssetBloc.add(ProtectAssetButtonTapped());
                      }
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RedBevisButton(
                    title: 'Send to server',
                    onPressed: () {
                      if (state.isNewAsset) {
                        _settingModalBottomSheet(context);
                      } else {
                        postToBlockChain();
                      }
                    },
                  )
                ],
              ),
            ),
          );

          return filePreviewPageScaffold;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    assetNetworkRepository = AssetNetworkRepositoryImp(
      networkConfig: AppConfig.getInstance().networkConfig,
      client: HttpRestClient(
        httpClient: Client(),
      ),
    );

    _previewAssetBloc = PreviewAssetBloc(
      uploadAssets: widget.imageAssets,
      assetNetworkRepository: assetNetworkRepository,
      assetEncoder: ZipAssetFileEncoder(),
    );

    initDefaultBlockchain();
  }

  void initDefaultBlockchain() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final defaultBlockchain = sharedPreferences.getString("bit_coin") ?? "BCH";
    _previewAssetBloc.add(ChangeBlockchain(defaultBlockchain));
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return BlocBuilder(
            bloc: _previewAssetBloc,
            builder: (context, PreviewAssetState state) {
              final String selectedBlockchain = state.selectedBlockchain;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SafeArea(
                    top: false,
                    bottom: true,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil().setHeight(30),
                          ),
                          Text(
                            "ARE YOU READY TO POST ?",
                            style: TextStyle(
                                color: ColorConstants.textColor, fontSize: 16),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Text(
                            "Choose the Blockchain you want to post on",
                            style: TextStyle(
                                color: ColorConstants.textColor, fontSize: 12),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 50),
                            child: Column(
                              children: <Widget>[
                                Material(
                                  child: InkWell(
                                    onTap: () {
                                      _previewAssetBloc
                                          .add(ChangeBlockchain("BCH"));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        CircularCheckBox(
                                          onChanged: (isActive) {
                                            if (isActive) {
                                              _previewAssetBloc
                                                  .add(ChangeBlockchain("BCH"));
                                            }
                                          },
                                          isActive: selectedBlockchain == "BCH"
                                              ? true
                                              : false,
                                        ),
                                        Text("BCH")
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        _previewAssetBloc
                                            .add(ChangeBlockchain("ETH"));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          CircularCheckBox(
                                            onChanged: (isActive) {
                                              if (isActive) {
                                                _previewAssetBloc.add(
                                                    ChangeBlockchain("ETH"));
                                              }
                                            },
                                            isActive:
                                                selectedBlockchain == "ETH"
                                                    ? true
                                                    : false,
                                          ),
                                          Text("ETH")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        _previewAssetBloc
                                            .add(ChangeBlockchain("BTC"));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          CircularCheckBox(
                                            onChanged: (isActive) {
                                              if (isActive) {
                                                _previewAssetBloc.add(
                                                    ChangeBlockchain("BTC"));
                                              }
                                            },
                                            isActive:
                                                selectedBlockchain == "BTC"
                                                    ? true
                                                    : false,
                                          ),
                                          Text("BTC")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        _previewAssetBloc
                                            .add(ChangeBlockchain("LTC"));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          CircularCheckBox(
                                            onChanged: (isActive) {
                                              if (isActive) {
                                                _previewAssetBloc.add(
                                                    ChangeBlockchain("LTC"));
                                              }
                                            },
                                            isActive:
                                                selectedBlockchain == "LTC"
                                                    ? true
                                                    : false,
                                          ),
                                          Text("LTC")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20),
                                  ),
                                  child: RoundedCornerButtonWithBorder(
                                    onPressed: () {
                                      postToBlockChain();
                                    },
                                    title: 'Post Now',
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  void postToBlockChain() {
    showDialog(
        context: context,
        builder: (cxt) {
          return BevisDialogWithDescription(
            title: 'CAUTION',
            description: 'You are about to save this file ' +
                'to the blockchain and permanent web. It will be public and visible to anyone. This action is permanent and irreversible.',
            onOkPressed: () {
              Navigator.of(context).pop();
              _previewAssetBloc.add(WriteToBlockchain());
            },
            onCancelPressed: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  void dispose() {
    super.dispose();

    _previewAssetBloc.close();
  }

  void onProgress(int sent, int total) {
    print("IN progrees $sent");
  }
}
