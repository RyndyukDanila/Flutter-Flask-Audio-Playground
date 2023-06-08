import 'package:audio_playground/controller/STT_notifier.dart';
import 'package:audio_playground/controller/TTS_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TTSTextWidget extends StatefulWidget {
  const TTSTextWidget({super.key});

  @override
  State<TTSTextWidget> createState() => _TTSTextWidgetState();
}

class _TTSTextWidgetState extends State<TTSTextWidget> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<TextToSpeechNotifier>(builder: (context, TextToSpeechNotifier TTSnotifier, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              maxLines: 5,
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Text to speech',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _buildVoice(),
          ],
        ),
      );
    });
  }

  Widget _buildVoice() {
    const double controlSize = 74;
    Icon icon;
    Color color;

    final theme = Theme.of(context);
    icon = Icon(Icons.voice_chat, color: theme.primaryColor, size: 40);
    color = theme.primaryColor.withOpacity(0.1);

    return Consumer<TextToSpeechNotifier>(
      builder: (context, TextToSpeechNotifier TTSnotifier, child) {
        return ClipOval(
          child: Material(
            color: color,
            child: InkWell(
              child: SizedBox(width: controlSize, height: controlSize, child: icon),
              onTap: () {
                TTSnotifier.reloadFileBools();
                TTSnotifier.getPredict(textController.text);
              },
            ),
          ),
        );
      },
    );
  }
}
