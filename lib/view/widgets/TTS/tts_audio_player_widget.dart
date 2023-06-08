import 'package:audio_playground/controller/TTS_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../STT/audio_player_widget.dart';

class TTSAudioPlayerWidget extends StatefulWidget {
  const TTSAudioPlayerWidget({Key? key}) : super(key: key);

  @override
  State<TTSAudioPlayerWidget> createState() => _TTSAudioPlayerWidgetState();
}

class _TTSAudioPlayerWidgetState extends State<TTSAudioPlayerWidget> {
  bool showPlayer = false;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextToSpeechNotifier>(
      builder: (context, TextToSpeechNotifier TTSnotifier, child) {
        return Center(
          child: TTSnotifier.TTSpath != ''
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayerWidget(
                    deleteButton: false,
                    source: TTSnotifier.TTSpath,
                    onDelete: () {
                      setState(() {
                        showPlayer = false;
                      });
                    },
                  ),
                )
              : Text(
                  'Waiting for text to voice!',
                  style: TextStyle(fontSize: 20),
                ),
        );
      },
    );
  }
}
