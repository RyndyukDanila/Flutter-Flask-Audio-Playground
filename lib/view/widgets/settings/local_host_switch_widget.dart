import 'package:audio_playground/controller/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalHostSwitchWidget extends StatefulWidget {
  const LocalHostSwitchWidget({super.key});

  @override
  State<LocalHostSwitchWidget> createState() => _LocalHostSwitchWidgetState();
}

class _LocalHostSwitchWidgetState extends State<LocalHostSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, SettingsNotifier settingsNotifier, child) {
        return Switch(
          value: SettingsNotifier.isLocalHost,
          onChanged: (bool value) {
            settingsNotifier.setLocalHost(value);
          },
        );
      },
    );
  }
}
