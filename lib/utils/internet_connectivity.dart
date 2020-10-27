import 'package:data_connection_checker/data_connection_checker.dart';

class InternetConnectivity {
  static Future<bool> isConnectedToInternet () async{
    return await DataConnectionChecker().hasConnection;
  }
}