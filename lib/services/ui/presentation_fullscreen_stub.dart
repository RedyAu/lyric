import 'package:flutter/services.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';

import 'presentation_fullscreen_shared.dart';

class FlutterNativeFullscreenDriver implements NativeFullscreenDriver {
  @override
  Future<void> setFullScreen(bool enabled, {SystemUiMode? systemUiMode}) async {
    FullScreen.setFullScreen(enabled, systemUiMode: systemUiMode);
  }
}

class PlatformPresentationFullscreenController
    implements PresentationFullscreenController {
  PlatformPresentationFullscreenController({NativeFullscreenDriver? driver})
    : _driver = driver ?? FlutterNativeFullscreenDriver();

  final NativeFullscreenDriver _driver;

  @override
  Future<void> prepareForNavigation() async {}

  @override
  Future<void> enter() {
    return _driver.setFullScreen(true, systemUiMode: SystemUiMode.edgeToEdge);
  }

  @override
  Future<void> exit() {
    return _driver.setFullScreen(false);
  }
}

PresentationFullscreenController createPresentationFullscreenController() {
  return PlatformPresentationFullscreenController();
}
