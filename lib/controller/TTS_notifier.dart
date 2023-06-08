import 'dart:io';

import 'package:audio_playground/model/custom_service.dart';
import 'package:flutter/material.dart';

class TextToSpeechNotifier extends ChangeNotifier {
  String TTStext = '';
  String TTSpath = '';
  String TTSlanguage = 'en';

  File? imageWaveFile;
  bool isWaveFileReady = false;
  File? imageMelFile;
  bool isMelFileReady = false;

  bool isLoading = false;
  bool isImageLoading = false;

  getPredict(String text) async {
    isLoading = true;
    isImageLoading = true;
    notifyListeners();

    TTStext = text;
    TTSpath = await CustomService.predictTTS(text, TTSlanguage) ?? '';

    isLoading = false;

    getImages();

    notifyListeners();
  }

  getImages() async {
    try {
      String path = await CustomService.downloadImage('TTS', 'Wave');
      File file = File('$path');
      imageWaveFile = file;

      path = await CustomService.downloadImage('TTS', 'Mel');
      file = File('$path');
      imageMelFile = file;
    } catch (e) {
      print(e);
    }
    isWaveFileReady = true;
    isMelFileReady = true;
    isImageLoading = false;
    notifyListeners();
  }

  getWaveImageWidget() {
    var img = Image.file(imageWaveFile!);
    img.image.evict();
    return img;
  }

  getMelImageWidget() {
    var img = Image.file(imageMelFile!);
    img.image.evict();
    return img;
  }

  reloadFileBools() {
    isWaveFileReady = false;
    isMelFileReady = false;
    notifyListeners();
  }
}
