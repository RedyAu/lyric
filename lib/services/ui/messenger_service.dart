import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messenger_service.g.dart';

class MessengerService {
  MessengerService({GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey})
    : scaffoldMessengerKey =
          scaffoldMessengerKey ?? GlobalKey<ScaffoldMessengerState>();

  int _snackBarSerial = 0;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  ScaffoldMessengerState? get state => scaffoldMessengerKey.currentState;
  BuildContext? get context => scaffoldMessengerKey.currentContext;

  void showSnackBar(SnackBar snackBar) {
    state?.showSnackBar(snackBar);
  }

  void showSnackBarReplacingCurrent(
    SnackBar snackBar, {
    Duration? forceHideAfter,
  }) {
    _snackBarSerial++;
    final thisSnackBarSerial = _snackBarSerial;

    state?.removeCurrentSnackBar(reason: SnackBarClosedReason.remove);
    showSnackBar(snackBar);

    if (forceHideAfter != null) {
      Future<void>.delayed(forceHideAfter, () {
        if (thisSnackBarSerial != _snackBarSerial) {
          return;
        }
        state?.hideCurrentSnackBar(reason: SnackBarClosedReason.timeout);
      });
    }
  }

  void clearBanners() {
    state?.clearMaterialBanners();
  }

  void showBanner(MaterialBanner banner) {
    state?.showMaterialBanner(banner);
  }

  void hideCurrentBanner() {
    state?.hideCurrentMaterialBanner();
  }
}

// Allow tests to replace this with a fake implementation.
MessengerService messengerService = MessengerService();

@Riverpod(keepAlive: true)
MessengerService messengerServiceProvider(Ref ref) => messengerService;
