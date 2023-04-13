import 'package:bevis/utils/helpers/validators/asset_password_validator/password_validation_exceptions.dart';

class AssetPasswordValidator {
  void validatePasswordInput(String password, String repeatPassword) {
    if (password != repeatPassword) {
      throw PasswordsDoNotMatchException();
    }

    if(password?.length == 0 || repeatPassword?.length == 0) {
      throw PasswordIsEmptyException();
    }
  }
}
