import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity _connectivity;
  NetworkInfo(this._connectivity);

  Future<bool> get isOnline async {
    final res = await _connectivity.checkConnectivity();
    return res != ConnectivityResult.none;
  }
}
