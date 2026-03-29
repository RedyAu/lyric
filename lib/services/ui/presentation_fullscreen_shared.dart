import 'package:flutter/services.dart';

abstract class NativeFullscreenDriver {
  Future<void> setFullScreen(bool enabled, {SystemUiMode? systemUiMode});
}

abstract class PresentationFullscreenController {
  Future<void> prepareForNavigation();

  Future<void> enter();

  Future<void> exit();
}
