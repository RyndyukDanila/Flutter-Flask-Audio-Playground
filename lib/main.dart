import 'package:audio_playground/controller/STT_notifier.dart';
import 'package:audio_playground/controller/TTS_notifier.dart';
import 'package:audio_playground/controller/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:audio_playground/model/custom_service.dart';

import 'package:provider/provider.dart';
import 'view/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final CustomService service = CustomService();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsNotifier>(create: (_) => SettingsNotifier()),
        ChangeNotifierProvider<SpeechToTextNotifier>(create: (_) => SpeechToTextNotifier()),
        ChangeNotifierProvider<TextToSpeechNotifier>(create: (_) => TextToSpeechNotifier()),
      ],
      child: Consumer<SettingsNotifier>(
        builder: (context, SettingsNotifier settingsNotifier, child) {
          return MaterialApp(
            title: 'Audio Playground',
            theme: settingsNotifier.isDark ? ThemeData.dark() : ThemeData(primarySwatch: Colors.purple),
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
