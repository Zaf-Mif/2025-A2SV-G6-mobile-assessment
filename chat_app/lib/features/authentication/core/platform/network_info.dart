import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Contract to check network connectivity status.
abstract class NetworkInfo {
  /// Returns `true` if device is connected to the internet.
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using [InternetConnectionChecker].
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  /// Returns true if there is an internet connection.
  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
// to run in web 
class NetworkInfoFake implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    if (kIsWeb) {
      // Assume always connected on web or implement your own logic
      return true;
    }
    return false; // or whatever default you want for other platforms
  }
}