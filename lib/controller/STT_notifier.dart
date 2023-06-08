import 'dart:io';

import 'package:audio_playground/model/custom_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SpeechToTextNotifier extends ChangeNotifier {
  String STTpath = '';
  String STTtext = '';
  File? imageWaveFile;
  bool isWaveFileReady = false;
  File? imageMelFile;
  bool isMelFileReady = false;

  String STTlanguage = 'en-US';

  bool isLoading = false;
  bool isImageLoading = false;

  SpeechToTextNotifier() {
    clearSTTtext();
  }

  getPredict(String path) async {
    isLoading = true;
    isImageLoading = true;
    notifyListeners();

    STTpath = path;
    try {
      Response response = await CustomService.predictSTT(path, STTlanguage);
      STTtext = response.data['STTtext'];
    } catch (e) {
      print(e);
      STTtext = 'Error';
    }

    isLoading = false;

    getImages();

    notifyListeners();
  }

  getImages() async {
    try {
      String path = await CustomService.downloadImage('STT', 'Wave');
      File file = File('$path');
      imageWaveFile = file;

      path = await CustomService.downloadImage('STT', 'Mel');
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

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  clearSTTtext() {
    STTtext = 'Today is ${_formatNumber(DateTime.now().day)}.${_formatNumber(DateTime.now().month)}.${DateTime.now().year}';
    notifyListeners();
  }

  reloadFileBools() {
    isWaveFileReady = false;
    isMelFileReady = false;
    notifyListeners();
  }
}
