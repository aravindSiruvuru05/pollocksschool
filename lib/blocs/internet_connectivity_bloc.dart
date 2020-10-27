//_connectionSubscription =
//_connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
//setState(() {
//_connectionStatus = result.toString();
//});

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:pollocksschool/blocs/bloc.dart';

class InternetConnectivityBloc extends Bloc {

  ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = new Connectivity();
  ConnectivityResult get status => _connectionStatus;

  //For subscription to the ConnectivityResult stream
  StreamSubscription<ConnectivityResult> _connectionSubscription;

  InternetConnectivityBloc(){
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
            _connectionStatus = result;
            print("Initstate : $_connectionStatus");
        });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
  }

}