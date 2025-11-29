import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdaptiveScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool isFullScreen;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.isFullScreen = false,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  void _applySystemUI() {
    if (widget.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _applySystemUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.appBar,
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
