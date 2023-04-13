import 'package:bevis/widgets/dialogs/bevis_choice_dialog.dart';
import 'package:bevis/widgets/dialogs/dialog_textfield.dart';
import 'package:flutter/material.dart';

class ProtectAssetDialog extends StatefulWidget {
  ProtectAssetDialog({
    @required this.dialogInputDidChange,
    @required this.onSubmitDialog,
    @required this.okEnabled,
    this.formValidationErrorMessage,
  });

  final void Function(String passwordInput, String passwordRepeatInput)
      dialogInputDidChange;
  final void Function(String passwordInput, String passwordRepeatInput) onSubmitDialog;
  final String formValidationErrorMessage;
  final bool okEnabled;

  @override
  State<StatefulWidget> createState() {
    return _ProtectAssetDialogState();
  }
}

class _ProtectAssetDialogState extends State<ProtectAssetDialog> {
  final _passwordTextController = TextEditingController();
  final _repeatPasswordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _passwordTextController.addListener(() {
      widget.dialogInputDidChange(
          _passwordTextController.text, _repeatPasswordTextController.text);
    });
    _repeatPasswordTextController.addListener(() {
      widget.dialogInputDidChange(
          _passwordTextController.text, _repeatPasswordTextController.text);
    });
  }

  Widget build(BuildContext context) {
    return BevisChoiceDialog(
      title: 'Encrypt the file with password',
      dialogBody: _protectAssetForm(),
      onOkPressed: widget.okEnabled ? () => widget.onSubmitDialog(_passwordTextController.text, _repeatPasswordTextController.text) : null,
    );
  }

  Widget _protectAssetForm() {
    Widget formValidationErrorDescription =
        widget.formValidationErrorMessage != null
            ? Text(
                widget.formValidationErrorMessage,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              )
            : Container();

    return Column(
      children: [
        DialogTextfield(
          obscureText: true,
          textEditingController: _passwordTextController,
          placeholder: 'Password',
        ),
        DialogTextfield(
          obscureText: true,
          textEditingController: _repeatPasswordTextController,
          placeholder: 'Repeat password',
        ),
        SizedBox(
          height: 4,
        ),
        formValidationErrorDescription,
      ],
    );
  }
}
