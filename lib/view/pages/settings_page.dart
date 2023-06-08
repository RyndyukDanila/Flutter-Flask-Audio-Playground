import 'package:audio_playground/view/widgets/settings/language_menu_widget.dart';
import 'package:audio_playground/view/widgets/settings/local_host_switch_widget.dart';
import 'package:audio_playground/view/widgets/settings/theme_switch_widget.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings Page"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          ListTile(
            title: Text('Use dark theme'),
            trailing: ThemeSwitchWidget(),
          ),
          ListTile(
            title: Text('Use local host'),
            trailing: LocalHostSwitchWidget(),
          ),
          // ListTile(
          //   title: Text('Text to speech language'),
          //   trailing: LanguageMenuWidget(),
          // )
        ],
      ),
    );
  }
}
