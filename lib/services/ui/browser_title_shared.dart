import '../../config/config.dart';

String formatBrowserTabTitle([String? contextTitle]) {
  final normalizedContextTitle = contextTitle?.trim();
  if (normalizedContextTitle == null || normalizedContextTitle.isEmpty) {
    return appConfig.appName;
  }
  return '$normalizedContextTitle | ${appConfig.appName}';
}
