import 'dart:io';
import 'package:audio_playground/controller/settings_notifier.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:audio_playground/model/custom_model.dart';
import 'package:path_provider/path_provider.dart';

class CustomService {
  static String _localHostUrl = 'https://0b80-92-124-162-106.ngrok-free.app/';
  static const _url = 'http://ryndyukdanila.pythonanywhere.com/';
  static String STTAudioPath = '';
  static String TTSAudioPath = '';
  static String STTImageWavePath = '';
  static String TTSImageWavePath = '';
  static String STTImageMelPath = '';
  static String TTSImageMelPath = '';
  final dio = Dio();

  Future<Response> getResponse() async {
    return await dio.get(_url);
  }

  Future<String> getCustomModel() async {
    Response response = await getResponse();
    CustomModel customModel = CustomModel.fromJson(response.data);
    return customModel.main ?? '';
  }

  static predictSTT(String filePath, String language) async {
    STTAudioPath = filePath;
    final dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    Map<String, List<String>>? headers = {
      'Content-type': ['application/json'],
      'Accept': ['application/json']
    };

    final STTFormData = FormData.fromMap({
      'name': 'dio',
      'date': DateTime.now().toIso8601String(),
      'speech-language': language,
      'file': await MultipartFile.fromFile(STTAudioPath, contentType: MediaType('audio', 'm4a'), headers: headers),
    });
    try {
      final response = !SettingsNotifier.isLocalHost
          ? await dio.post('$_url/STT', data: STTFormData)
          : await dio.post('$_localHostUrl/STT', data: STTFormData);
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }

  static predictTTS(String text, String language) async {
    final dio = Dio();
    final Directory tempDir = await getTemporaryDirectory();
    final TTSFormData = FormData.fromMap({
      'name': 'dio',
      'date': DateTime.now().toIso8601String(),
      'tts-slow': 'false',
      'text-language': language,
      'tts-text': text,
    });
    final File file = File('${tempDir.path}/tts.wav');
    try {
      final response = !SettingsNotifier.isLocalHost
          ? await dio.post(
              '$_url/TTS',
              data: TTSFormData,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            )
          : await dio.post(
              '$_localHostUrl/TTS',
              data: TTSFormData,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            );
      print(response.data.length);
      await file.writeAsBytes(response.data).then((value) => TTSAudioPath = value.path);
      return TTSAudioPath;
    } catch (e) {
      print(e);
    }
  }

  static downloadImage(String name, String imageType) async {
    assert(name == 'STT' || name == 'TTS');
    assert(imageType == 'Wave' || imageType == 'Mel');

    final filename = '$name$imageType';
    String path = '';
    final dio = Dio();
    final formData = FormData.fromMap({
      'name': 'dio',
      'date': DateTime.now().toIso8601String(),
      'filename': filename,
    });
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/$filename.png');
    try {
      final response = !SettingsNotifier.isLocalHost
          ? await dio.post(
              '$_url/download',
              data: formData,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            )
          : await dio.post(
              '$_localHostUrl/download',
              data: formData,
              options: Options(
                responseType: ResponseType.bytes,
              ),
            );
      print(response.data.length);
      await file.writeAsBytes(response.data).then((value) {
        path = value.path;
      });
      return path;
    } catch (e) {
      print(e);
    }
  }
}
