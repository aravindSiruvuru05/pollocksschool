import 'dart:async';
import 'bloc.dart';

enum LoadingState {
  NORMAL,
  LOADING,
  DONE,
}

class LoadingBloc extends Bloc {
  // login button --------------
  final _loginButtonStateController =
      StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get loginButtonState =>
      _loginButtonStateController.stream;
  StreamSink get loginButtonStateSink => _loginButtonStateController.sink;

  // otp cancel button --------------
  final _otpCancelButtonStateController =
      StreamController<LoadingState>.broadcast();
  Stream<LoadingState> get otpCancelButtonState =>
      _otpCancelButtonStateController.stream;
  StreamSink get otpCancelButtonStateSink =>
      _otpCancelButtonStateController.sink;

  @override
  void dispose() {
    _loginButtonStateController.close();
    _otpCancelButtonStateController.close();
    // TODO: implement dispose
  }
}
