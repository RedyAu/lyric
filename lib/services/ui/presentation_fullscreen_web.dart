import 'package:web/web.dart' as web;

import 'presentation_fullscreen_shared.dart';

class PlatformPresentationFullscreenController
    implements PresentationFullscreenController {
  @override
  Future<void> prepareForNavigation() async {
    web.document.documentElement?.requestFullscreen();
  }

  @override
  Future<void> enter() async {}

  @override
  Future<void> exit() async {
    if (web.document.fullscreenElement != null) {
      web.document.exitFullscreen();
    }
  }
}

PresentationFullscreenController createPresentationFullscreenController() {
  return PlatformPresentationFullscreenController();
}
