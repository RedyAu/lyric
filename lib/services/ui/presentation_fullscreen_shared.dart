import 'package:flutter/services.dart';

abstract class NativeFullscreenDriver {
  Future<void> setFullScreen(bool enabled, {SystemUiMode? systemUiMode});
}

abstract class PresentationFullscreenController {
  bool get isFullscreen;

  Stream<bool> get changes;

  Future<void> prepareForNavigation();

  Future<void> enter();

  Future<void> exit();
}
