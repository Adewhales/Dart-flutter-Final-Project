// lib/utils/internet_utils.dart

import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks if the device has an active internet connection.
Future<bool> hasInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  return connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}
