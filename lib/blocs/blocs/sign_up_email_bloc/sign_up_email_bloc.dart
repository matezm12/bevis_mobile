import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/repositories/network_repositories/sign_up_network_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_repository/flutter_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_states.dart';

class SignUpEmailBloc extends Bloc<SignUpEvent, SingUpState> {
  SignUpNetworkRepository _signUpNetworkRepository;

  SignUpEmailBloc({@required SignUpNetworkRepository networkRepo})
      : _signUpNetworkRepository = networkRepo,
        super(
          SingUpState(
            isLoading: false,
          ),
        );

  @override
  Stream<SingUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    print("event in bloc ");
    yield (SingUpState(isLoading: true));
    if (event is SignUpEmailEvent) {
      final res = await _signUpNetworkRepository.singUp(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password);

      if (res.error == null) {
        yield SignUpSuccessState();
      } else {
        if (res.error is NetworkError) {
          var error = res.error as NetworkError;
          if (error.errorTitle.contains("UserNotActivatedException")) {
            yield SignUpSuccessState();
          } else {
            yield SignUpFailState(error.errorMsg);
          }
        } else {
          yield SignUpFailState("Unknown Error");
        }
      }
    }
    if (event is SignUpActivateCodeEvent) {
      final res = await _signUpNetworkRepository.activateAccount(
          code: event.activationCode);
      if (res.error == null) {
        yield SignUpActivateSuccessState();
      } else {
        yield SignUpActivateFailState();
      }
    }
    if (event is ResetPasswordEvent) {
      final res = await _signUpNetworkRepository.resetPasswordAccount(
          email: event.email);
      if (res.error == null) {
        yield ResetPasswordFoundState();
      } else {
        yield ResetPasswordNotFoundState();
      }
    }
    if (event is MakeNewPasswordEvent) {
      final res = await _signUpNetworkRepository.newPasswordAccount(
          code: event.key, newPassword: event.password);
      if (res.error == null) {
        yield ResetPasswordSuccessState();
      } else {
        yield ResetPasswordFailState();
      }
    }
  }
}
