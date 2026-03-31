import 'dart:async';

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
  final _changes = StreamController<bool>.broadcast();
  bool _isFullscreen = false;

  @override
  bool get isFullscreen => _isFullscreen;

  @override
  Stream<bool> get changes => _changes.stream;

  @override
  Future<void> prepareForNavigation() async {}

  @override
  Future<void> enter() async {
    await _driver.setFullScreen(true, systemUiMode: SystemUiMode.edgeToEdge);
    _updateState(true);
  }

  @override
  Future<void> exit() async {
    await _driver.setFullScreen(false);
    _updateState(false);
  }

  void _updateState(bool isFullscreen) {
    if (_isFullscreen == isFullscreen) return;

    _isFullscreen = isFullscreen;
    _changes.add(isFullscreen);
  }
}

PresentationFullscreenController createPresentationFullscreenController() {
  return PlatformPresentationFullscreenController();
}
