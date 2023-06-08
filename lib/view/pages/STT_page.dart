import 'dart:io';

import 'package:audio_playground/controller/STT_notifier.dart';
import 'package:audio_playground/view/widgets/STT/audio_rec_and_play_widget.dart';
import 'package:audio_playground/view/widgets/STT/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class STTPage extends StatefulWidget {
  const STTPage({super.key});

  @override
  State<STTPage> createState() => _STTPageState();
}

class _STTPageState extends State<STTPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SpeechToTextNotifier>(
      builder: (context, SpeechToTextNotifier STTnotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Speech To Text Page"),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'en-US',
                    child: Text('English'),
                  ),
                  PopupMenuItem(
                    value: 'ru-RU',
                    child: Text('Russian'),
                  ),
                  PopupMenuItem(
                    value: 'es-ES',
                    child: Text('Spanish'),
                  ),
                  PopupMenuItem(
                    value: 'fr-FR',
                    child: Text('French'),
                  ),
                  PopupMenuItem(
                    value: 'de-DE',
                    child: Text('German'),
                  ),
                ],
                onSelected: (value) {
                  STTnotifier.STTlanguage = value;
                },
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(
                height: 250,
                child: TextWidget(),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const SizedBox(
                height: 200,
                child: AudioRecAndPlayWidget(),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              STTnotifier.isWaveFileReady
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: STTnotifier.getWaveImageWidget(),
                    )
                  : STTnotifier.isImageLoading
                      ? Container(
                          padding: const EdgeInsets.all(4.0),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox.shrink(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              STTnotifier.isMelFileReady
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: STTnotifier.getMelImageWidget(),
                    )
                  : STTnotifier.isImageLoading
                      ? Container(
                          padding: const EdgeInsets.all(4.0),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
