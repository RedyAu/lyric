import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:lyric/elements/nonClickablePaneItem.dart';
import 'package:path/path.dart';

import 'package:lyric/data/data.dart';

import 'data/data.dart';
import 'data/context.dart';
import 'pages/manage.dart';
import 'pages/songs/page.dart';
import 'pages/sets.dart';
import 'pages/present.dart';
import 'pages/settings.dart';
import 'data/song.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  lyricInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Lyric',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [ClearFocusOnPush()],
      initialRoute: '/',
      routes: {
        '/': (_) => MyHomePage(),
      },
      darkTheme:
          ThemeData(accentColor: Colors.teal, brightness: Brightness.dark),
    );
  }
}

class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}

class MyHomePage extends StatefulWidget with GetItStatefulWidgetMixin {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with GetItStateMixin {
  bool value = false;

  bool ready = false;

  int index = 0;

  @override
  void initState() {
    data<Data>().sync().then((value) => setState(() {
          ready = true;
        }));
    super.initState();
  }

  @override
  int built = 0;
  Widget build(BuildContext context) {
    final Song? selectedSong = watchX((Lyric x) => x.selectedSong);

    built++;

    return Stack(
      children: [
        !ready
            ? Center(
                child: ProgressRing(),
              )
            : NavigationView(
                useAcrylic: false,
                pane: NavigationPane(
                  displayMode: PaneDisplayMode.open,
                  selected: index,
                  onChanged: (i) => setState(() => index = i),
                  header: Stack(
                    children: [
                      Center(
                        child: Text('Lyric',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      MoveWindow(),
                    ],
                  ),
                  items: [
                    PaneItem(
                      icon: Icon(FeatherIcons.folder),
                      title: Text('Manage'),
                    ),
                    PaneItem(
                      icon: Icon(FeatherIcons.music),
                      title: Text(
                          'Songs' /*  +
                            ((lyric.selectedSong == null)
                                ? ""
                                : "\nSelected: " +
                                    basenameWithoutExtension(
                                        lyric.selectedSong!.fileEntity.path)) */
                          ),
                    ),
                    NonClickablePaneItem(Text(
                        /*
                        (selectedSong ?? Song(fileEntity: File("No Song")))
                            .fileEntity!
                            .path*/
                        "helloka")),
                    NonClickablePaneItem(Text(built.toString())),
                    PaneItem(
                      icon: Icon(FeatherIcons.columns),
                      title: Text('Sets'),
                    ),
                    PaneItemSeparator(),
                    PaneItem(
                      icon: Icon(FeatherIcons.monitor),
                      title: Text('Present'),
                    )
                  ],
                  footerItems: [
                    PaneItem(
                      icon: Icon(FeatherIcons.settings),
                      title: Text('Settings'),
                    ),
                  ],
                ),
                content: NavigationBody(index: index, children: [
                  ManagePage(),
                  SongsPage(),
                  SetsPage(),
                  PresentPage(),
                  SettingsPage()
                ]),
              ),
        Container(
          child: Container(
            height: 40,
            child: Row(
              children: [
                Spacer(),
                Align(
                  child: WindowButtons(),
                  alignment: Alignment.topRight,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        MaximizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(
              iconNormal: Colors.white,
              mouseOver: Colors.red,
              mouseDown: Colors.red.withAlpha(100)),
        )
      ],
    );
  }
}
