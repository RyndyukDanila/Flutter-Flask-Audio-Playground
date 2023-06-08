import 'dart:async';

import 'package:audio_playground/controller/STT_notifier.dart';
import 'package:audio_playground/model/custom_model.dart';
import 'package:audio_playground/model/custom_service.dart';
import 'package:audio_playground/view/widgets/STT/audio_player_widget.dart';
import 'package:audio_playground/view/widgets/STT/audio_recorder_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class AudioRecAndPlayWidget extends StatefulWidget {
  const AudioRecAndPlayWidget({Key? key}) : super(key: key);

  @override
  State<AudioRecAndPlayWidget> createState() => _AudioRecAndPlayWidgetState();
}

class _AudioRecAndPlayWidgetState extends State<AudioRecAndPlayWidget> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechToTextNotifier>(
      builder: (context, SpeechToTextNotifier STTnotifier, child) {
        return Center(
          child: showPlayer
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayerWidget(
                    deleteButton: true,
                    source: audioPath!,
                    onDelete: () {
                      setState(() {
                        showPlayer = false;
                        STTnotifier.reloadFileBools();
                      });
                    },
                  ),
                )
              : AudioRecorderWidget(
                  onStop: (path) {
                    if (kDebugMode) print('Recorded file path: $path');
                    setState(() {
                      audioPath = path;
                      showPlayer = true;
                      STTnotifier.getPredict(path);
                    });
                  },
                ),
        );
      },
    );
  }
}
