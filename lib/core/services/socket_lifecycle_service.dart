import 'dart:developer';
import 'package:flutter/widgets.dart';
import '../repos/socket_repo/socket_repo.dart';
import '../helpers/get_initial_route.dart';

class SocketLifecycleService {
  SocketLifecycleService(this._socketRepo);

  final SocketRepo _socketRepo;

  AppLifecycleListener? _listener;

  void start() {
    if (checkLoginState()) {
      log("SocketLifecycleService -> connect");
      _socketRepo.connect();
    }

    _listener ??= AppLifecycleListener(
      onResume: () {
        if (!checkLoginState()) return;

        log("App resumed -> connect socket");
        _socketRepo.connect();
      },
      onPause: () {
        log("App paused -> disconnect socket");
        _socketRepo.disconnect();
      },
      onDetach: () {
        log("App detached -> disconnect socket");
        _socketRepo.disconnect();
      },
    );
  }

  void onLogin() {
    _socketRepo.connect();
  }

  void onLogout() {
    _socketRepo.disconnect();
  }

  void dispose() {
    _listener?.dispose();
    _socketRepo.dispose();
  }
}
