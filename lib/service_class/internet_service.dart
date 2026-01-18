import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  final StreamController<bool> _controller =
  StreamController<bool>.broadcast();

  Stream<bool> get internetStatusStream => _controller.stream;

  void initialize() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      final hasInternet = result != ConnectivityResult.none;
      _controller.add(hasInternet);
    }) as StreamSubscription<ConnectivityResult>?;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
