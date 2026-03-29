import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sofar/services/ui/presentation_fullscreen_shared.dart';
import 'package:sofar/services/ui/presentation_fullscreen_stub.dart';

class _RecordingNativeFullscreenDriver implements NativeFullscreenDriver {
  final calls = <({bool enabled, SystemUiMode? systemUiMode})>[];

  @override
  Future<void> setFullScreen(bool enabled, {SystemUiMode? systemUiMode}) async {
    calls.add((enabled: enabled, systemUiMode: systemUiMode));
  }
}

void main() {
  group('PlatformPresentationFullscreenController', () {
    test('keeps native fullscreen entry behavior unchanged', () async {
      final driver = _RecordingNativeFullscreenDriver();
      final controller = PlatformPresentationFullscreenController(
        driver: driver,
      );

      await controller.enter();

      expect(driver.calls, [
        (enabled: true, systemUiMode: SystemUiMode.edgeToEdge),
      ]);
    });

    test('keeps native fullscreen exit behavior unchanged', () async {
      final driver = _RecordingNativeFullscreenDriver();
      final controller = PlatformPresentationFullscreenController(
        driver: driver,
      );

      await controller.exit();

      expect(driver.calls, [(enabled: false, systemUiMode: null)]);
    });
  });
}
