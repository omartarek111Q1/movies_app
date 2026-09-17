import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:movies_app/network/check_network/network_info.dart';

class NetworkInfoImpl extends NetworkInfo{
  final InternetConnection connectionChecker;
  NetworkInfoImpl(this.connectionChecker);
  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async => await connectionChecker.hasInternetAccess;
}