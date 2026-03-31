import 'package:web/web.dart' as web;

import '../../config/app_config.dart';
import 'web_initial_app_uri_shared.dart';

Uri? captureInitialWebAppUri({required AppConfig config}) {
  final browserUri = Uri.parse(web.window.location.href);
  final recoveredPath = config.enableStaticWebDeepLinkRecovery
      ? web.window.sessionStorage.getItem('originalWebPath')
      : null;
  final capture = deriveInitialWebAppUriCapture(
    browserUri,
    config: config,
    recoveredPath: recoveredPath,
  );

  if (capture.usedRecoveredPath) {
    web.window.history.replaceState(null, '', _relativeUri(capture.appUri));
  }

  if (recoveredPath != null && recoveredPath.isNotEmpty) {
    web.window.sessionStorage.removeItem('originalWebPath');
  }

  return capture.appUri;
}

void syncWebBrowserUrlToAppRoute(String route, {required AppConfig config}) {
  final targetUri = webAppUriFromRoute(route, config: config);
  if (targetUri.toString() == web.window.location.href) {
    return;
  }

  web.window.history.replaceState(null, '', _relativeUri(targetUri));
}

String _relativeUri(Uri uri) {
  final buffer = StringBuffer(uri.path);
  if (uri.hasQuery) {
    buffer.write('?${uri.query}');
  }
  if (uri.fragment.isNotEmpty) {
    buffer.write('#${uri.fragment}');
  }
  return buffer.toString();
}
