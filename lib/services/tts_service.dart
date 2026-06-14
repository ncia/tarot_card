import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../data/witch_data.dart';
import 'audio_service.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _apiKey = 'sk_ka15z2n9phv842hw1fvt0b634fb8cesaj1czhfm4cv0';
  final String _baseUrl = 'https://api.speechify.ai/v1/audio/speech';
  
  final List<String> _textQueue = [];
  bool _isPlaying = false;
  Witch? _currentWitch;

  TtsService._internal() {
    _audioPlayer.onPlayerComplete.listen((event) {
      _playNextInQueue();
    });
  }

  Future<void> speak(Witch witch, String text, String localeCode) async {
    stop();
    _currentWitch = witch;
    _textQueue.add(text);
    _playNextInQueue();
  }

  Future<void> speakLongText(Witch witch, String text, String localeCode) async {
    stop();
    _currentWitch = witch;
    
    // Split into paragraphs to respect API limits and provide natural pauses
    final paragraphs = text.split('\n');
    for (var p in paragraphs) {
      final clean = p.trim();
      if (clean.isNotEmpty) {
        if (clean.length > 300) {
           final sentences = clean.split(RegExp(r'(?<=[.!?])\s+'));
           for (var s in sentences) {
             if (s.trim().isNotEmpty) _textQueue.add(s.trim());
           }
        } else {
           _textQueue.add(clean);
        }
      }
    }
    
    _playNextInQueue();
  }

  Future<void> _playNextInQueue() async {
    if (AudioService().isMuted || AudioService().volume == 0) {
      _textQueue.clear();
      _isPlaying = false;
      AudioService().resumeBgm();
      return;
    }

    if (_textQueue.isEmpty) {
      _isPlaying = false;
      AudioService().resumeBgm();
      return;
    }

    _isPlaying = true;
    final text = _textQueue.removeAt(0);

    try {
      final requestBody = jsonEncode({
        'input': text,
        'voice_id': _currentWitch!.speechifyVoiceId,
        'audio_format': 'mp3',
        'model': 'simba-multilingual'
      });

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String base64Audio = responseData['audio_data'] ?? '';
        
        if (base64Audio.isEmpty) {
          print('Speechify API Error: No audio_data found in response');
          return;
        }

        final Uint8List audioBytes = base64Decode(base64Audio);
        
        if (kIsWeb) {
          await AudioService().pauseBgm();
          final double ttsVolume = AudioService().isMuted ? 0.0 : 0.5;
          await _audioPlayer.play(BytesSource(audioBytes), volume: ttsVolume);
        } else {
          // Save to temp file to avoid BytesSource crash on Windows
          final tempDir = await getTemporaryDirectory();
          // Use Platform.pathSeparator for cross-platform compatibility
          final String safePath = '${tempDir.path}${Platform.pathSeparator}tts_temp_${DateTime.now().millisecondsSinceEpoch}.mp3';
          final tempFile = File(safePath);
          await tempFile.writeAsBytes(audioBytes);
          
          print('Saved TTS MP3 to: $safePath, Size: ${audioBytes.length} bytes');

          await AudioService().pauseBgm();
          final double ttsVolume = AudioService().isMuted ? 0.0 : 0.5;
          await _audioPlayer.play(DeviceFileSource(safePath), volume: ttsVolume);
        }
      } else {
        print('Speechify API Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        _playNextInQueue();
      }
    } catch (e) {
      print('Error during Speechify TTS synthesis: $e');
      _playNextInQueue();
    }
  }

  void stop() {
    _textQueue.clear();
    _isPlaying = false;
    _audioPlayer.stop();
    AudioService().resumeBgm();
  }
}
