import '../../config/app_config.dart';

class InitialWebAppUriCapture {
  const InitialWebAppUriCapture({
    required this.appUri,
    required this.usedRecoveredPath,
  });

  final Uri appUri;
  final bool usedRecoveredPath;
}

InitialWebAppUriCapture deriveInitialWebAppUriCapture(
  Uri browserUri, {
  required AppConfig config,
  String? recoveredPath,
}) {
  if (!config.enableStaticWebDeepLinkRecovery ||
      recoveredPath == null ||
      recoveredPath.isEmpty) {
    return InitialWebAppUriCapture(
      appUri: browserUri,
      usedRecoveredPath: false,
    );
  }

  final normalizedRecoveredPath = recoveredPath.startsWith('/')
      ? recoveredPath
      : '/$recoveredPath';

  return InitialWebAppUriCapture(
    appUri: browserUri.resolveUri(Uri.parse(normalizedRecoveredPath)),
    usedRecoveredPath: true,
  );
}

Uri webAppUriFromRoute(String route, {required AppConfig config}) {
  final baseUri = Uri.parse(config.webappRoot);
  final routeUri = Uri.parse(route);
  final baseSegments = baseUri.pathSegments
      .where((segment) => segment.isNotEmpty)
      .toList();

  return baseUri.replace(
    pathSegments: [
      ...baseSegments,
      ...routeUri.pathSegments.where((segment) => segment.isNotEmpty),
    ],
    query: routeUri.hasQuery ? routeUri.query : null,
    fragment: routeUri.fragment.isNotEmpty ? routeUri.fragment : null,
  );
}
