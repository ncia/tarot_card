import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final response = await http.post(
    Uri.parse('https://api.speechify.ai/v1/audio/speech'),
    headers: {
      'Authorization': 'Bearer sk_ka15z2n9phv842hw1fvt0b634fb8cesaj1czhfm4cv0',
      'Content-Type': 'application/json'
    },
    body: jsonEncode({
      'input': 'Hello there, my name is Morgan. Nice to meet you.',
      'voice_id': 'min-seo',
      'audio_format': 'mp3',
      'model': 'simba-multilingual'
    })
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
      print('SUCCESS, size: ${response.bodyBytes.length}');
  } else {
      print(response.body);
  }
}
