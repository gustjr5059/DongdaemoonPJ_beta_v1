
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


Future<String> loadApiKey() async {
  final jsonString = await rootBundle.loadString('config.json');
  final jsonMap = json.decode(jsonString);
  final apiKey = jsonMap['kakao_api_key'];
  print('Loaded API Key: $apiKey'); // API 키 출력
  return apiKey;
}
