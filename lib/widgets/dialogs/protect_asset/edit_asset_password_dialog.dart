import 'package:bevis/widgets/dialogs/bevis_choice_dialog.dart';
import 'package:bevis/widgets/dialogs/dialog_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef _EditAssetPasswordInputCallback = void Function(String oldPasswordInput,
    String newPasswordInput, String repeatPasswordInput);

class EditAssetPasswordDialog extends StatefulWidget {
  EditAssetPasswordDialog({
    @required this.dialogInputDidChange,
    @required this.onSubmit,
    @required this.isSubmitButtonEnabled,
    @required this.onRemovePassword,
    this.formValidationErrorMessage,
  });

  final _EditAssetPasswordInputCallback dialogInputDidChange;
  final _EditAssetPasswordInputCallback onSubmit;
  final VoidCallback onRemovePassword;

  final bool isSubmitButtonEnabled;
  final String formValidationErrorMessage;

  @override
  State<StatefulWidget> createState() => _EditAssetPasswordDialogState();
}

class _EditAssetPasswordDialogState extends State<EditAssetPasswordDialog> {
  final TextEditingController _oldPasswordTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _repeatPasswordTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _oldPasswordTextController.addListener(() {
      widget.dialogInputDidChange(
        _oldPasswordTextController.text,
        _passwordTextController.text,
        _repeatPasswordTextController.text,
      );
    });

    _passwordTextController.addListener(() {
      widget.dialogInputDidChange(
        _oldPasswordTextController.text,
        _passwordTextController.text,
        _repeatPasswordTextController.text,
      );
    });

    _repeatPasswordTextController.addListener(() {
      widget.dialogInputDidChange(
        _oldPasswordTextController.text,
        _passwordTextController.text,
        _repeatPasswordTextController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BevisChoiceDialog(
      title: 'Edit your Encrypted file password',
      onOkPressed: widget.isSubmitButtonEnabled
          ? () => widget.onSubmit(
                _oldPasswordTextController.text,
                _passwordTextController.text,
                _repeatPasswordTextController.text,
              )
          : null,
      dialogBody: _editAssetPasswordForm(),
    );
  }

  Widget _editAssetPasswordForm() {
    final formValidationErrorDescription =
        widget.formValidationErrorMessage != null
            ? Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  widget.formValidationErrorMessage,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              )
            : Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DialogTextfield(
          obscureText: true,
          textEditingController: _oldPasswordTextController,
          placeholder: 'Old Password',
        ),
        DialogTextfield(
          obscureText: true,
          textEditingController: _passwordTextController,
          placeholder: 'Password',
        ),
        DialogTextfield(
          obscureText: true,
          textEditingController: _repeatPasswordTextController,
          placeholder: 'Repeat Password',
        ),
        formValidationErrorDescription,
        SizedBox(
          height: 40,
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            foregroundColor: MaterialStateProperty.all<Color>(
              Color(0xFFE71527),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.white,
            ),
          ),
          onPressed: widget.onRemovePassword,
          child: Row(
            children: [
              SvgPicture.asset('assets/asset_preview_page/trash_bin_icon.svg'),
              SizedBox(
                width: 30,
              ),
              Text(
                'Remove Password',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
