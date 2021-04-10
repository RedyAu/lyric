import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:lyric/data/data.dart';

import 'pages/manage.dart';
import 'pages/songs.dart';
import 'pages/sets.dart';
import 'pages/present.dart';
import 'pages/settings.dart';

//import 'utils/theme.dart';

late bool darkMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The platforms the plugin support (01/04/2021 - DD/MM/YYYY):
  //   - Windows
  //   - Web
  //   - Android
  darkMode = true;
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
      initialRoute: '/',
      routes: {
        '/': (_) => MyHomePage(),
      },
      //style: Style(accentColor: Colors.blue, brightness: Brightness.dark),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  @override
  void initState() {
    Data().sync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      left: NavigationPanel(
        menu: NavigationPanelMenuItem(
          icon: Icon(FeatherIcons.menu),
          label: Text('Lyric',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        currentIndex: index,
        items: [
          NavigationPanelItem(
            icon: Icon(FeatherIcons.folder),
            label: Text('Manage'),
            onTapped: () => setState(() => index = 0),
          ),
          NavigationPanelItem(
            icon: Icon(FeatherIcons.music),
            label: Text('Songs'),
            onTapped: () => setState(() => index = 1),
          ),
          NavigationPanelItem(
            icon: Icon(FeatherIcons.columns),
            label: Text('Sets'),
            onTapped: () => setState(() => index = 2),
          ),
          NavigationPanelTileSeparator(),
          NavigationPanelItem(
              icon: Icon(FeatherIcons.monitor),
              label: Text('Present'),
              onTapped: () => setState(() => index = 3)),
        ],
        bottom: NavigationPanelItem(
          // selected: index == 3,
          icon: Icon(FeatherIcons.settings),
          label: Text('Settings'),
          onTapped: () => setState(() => index = 4),
        ),
      ),
      body: Stack(
        children: [
          NavigationPanelBody(
              //transitionBuilder: (child, animation) {
              //  return EntrancePageTransition(
              //      child: child, animation: animation);
              //},
              index: index,
              children: [
                ManagePage(),
                SongsPage(),
                SetsPage(),
                PresentPage(),
                SettingsPage()
              ]),
          WindowTitleBarBox(
            child: Row(
              children: [Spacer(), WindowButtons()],
            ),
          ),
        ],
      ),
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
