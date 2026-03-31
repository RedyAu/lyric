import 'presentation_fullscreen_shared.dart';
import 'presentation_fullscreen_stub.dart'
    if (dart.library.html) 'presentation_fullscreen_web.dart'
    as platform;

export 'presentation_fullscreen_shared.dart';

final PresentationFullscreenController presentationFullscreenController =
    platform.createPresentationFullscreenController();
