import 'package:audio_playground/controller/TTS_notifier.dart';
import 'package:audio_playground/model/custom_service.dart';
import 'package:audio_playground/view/widgets/TTS/tts_audio_player_widget.dart';
import 'package:audio_playground/view/widgets/TTS/tts_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TTSPage extends StatefulWidget {
  const TTSPage({super.key});

  @override
  State<TTSPage> createState() => _TTSPageState();
}

class _TTSPageState extends State<TTSPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TextToSpeechNotifier>(
      builder: (context, TextToSpeechNotifier TTSnotifier, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Text To Speech Page"),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  PopupMenuItem(
                    value: 'ru',
                    child: Text('Russian'),
                  ),
                  PopupMenuItem(
                    value: 'es',
                    child: Text('Spanish'),
                  ),
                  PopupMenuItem(
                    value: 'fr',
                    child: Text('French'),
                  ),
                  PopupMenuItem(
                    value: 'de',
                    child: Text('German'),
                  ),
                ],
                onSelected: (value) {
                  TTSnotifier.TTSlanguage = value;
                },
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const SizedBox(
                height: 36,
              ),
              SizedBox(
                height: 250,
                child: TTSTextWidget(),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              SizedBox(
                height: 200,
                child: TTSnotifier.isLoading
                    ? Container(
                        padding: const EdgeInsets.all(4.0),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : TTSAudioPlayerWidget(),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              TTSnotifier.isWaveFileReady
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: TTSnotifier.getWaveImageWidget(),
                    )
                  : TTSnotifier.isImageLoading
                      ? Container(
                          height: 200,
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
              TTSnotifier.isWaveFileReady
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: TTSnotifier.getMelImageWidget(),
                    )
                  : TTSnotifier.isImageLoading
                      ? Container(
                          height: 200,
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
