import 'package:flutter/material.dart';

import '../../services/ui/browser_title.dart';

class BrowserTitle extends StatefulWidget {
  const BrowserTitle({required this.child, this.contextTitle, super.key});

  final String? contextTitle;
  final Widget child;

  @override
  State<BrowserTitle> createState() => _BrowserTitleState();
}

class _BrowserTitleState extends State<BrowserTitle> {
  @override
  void initState() {
    super.initState();
    _applyTitle();
  }

  @override
  void didUpdateWidget(covariant BrowserTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contextTitle != widget.contextTitle) {
      _applyTitle();
    }
  }

  @override
  void dispose() {
    setBrowserTabTitle(formatBrowserTabTitle());
    super.dispose();
  }

  void _applyTitle() {
    setBrowserTabTitle(formatBrowserTabTitle(widget.contextTitle));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
