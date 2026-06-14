import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import 'reading_screen.dart';
import '../services/tarot_ai_service.dart';
import '../services/tts_service.dart';
import '../services/economy_service.dart';
import '../data/witch_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isButton;

  ChatMessage({required this.text, required this.isUser, this.isButton = false});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  late final List<ChatMessage> _messages;
  late final TarotAiService _aiService;
  late final TtsService _ttsService;
  
  bool _isWaitingForCards = false;
  bool _isTyping = false;
  String _currentQuestion = '';
  late List<Witch> _witches;
  late Witch _selectedWitch;
  bool _isInit = false;
  
  String? _initError;

  @override
  void initState() {
    super.initState();
    try {
      _textController = TextEditingController();
      _scrollController = ScrollController();
      _messages = [];
      _aiService = TarotAiService();
      _ttsService = TtsService();
    } catch (e, st) {
      _initError = '$e\n$st';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _witches = getLocalizedWitches(context);
    if (!_isInit) {
      _selectedWitch = _witches.first;
      _messages.add(ChatMessage(
        text: AppLocalizations.of(context)!.chatWitchGreeting(_selectedWitch.name),
        isUser: false,
      ));
      _isInit = true;
    } else {
      _selectedWitch = _witches.firstWhere((w) => w.id == _selectedWitch.id);
    }
  }

  void _changeWitch(Witch witch) {
    _ttsService.stop();
    setState(() {
      _selectedWitch = witch;
      _messages.add(ChatMessage(
        text: AppLocalizations.of(context)!.chatWitchChanged(witch.name),
        isUser: false,
      ));
    });
    _scrollToBottom();
  }

  void _showWitchProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent,
                    image: DecorationImage(
                      image: AssetImage(_selectedWitch.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedWitch.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  _selectedWitch.title,
                  style: const TextStyle(fontSize: 14, color: Colors.pinkAccent),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProfileInfo(AppLocalizations.of(context)!.chatProfileAge, '${_selectedWitch.age}'),
                    _buildProfileInfo(AppLocalizations.of(context)!.chatProfileBloodType, _selectedWitch.bloodType),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProfileInfo(AppLocalizations.of(context)!.chatProfileHeight, _selectedWitch.height),
                    _buildProfileInfo(AppLocalizations.of(context)!.chatProfileWeight, _selectedWitch.weight),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.chatProfileBackground,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      _selectedWitch.backgroundStory,
                      style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(AppLocalizations.of(context)!.chatProfileClose, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  @override
  void dispose() {
    _ttsService.stop();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_textController.text.trim().isEmpty) return;
    
    final economy = EconomyService();
    if (economy.coins < 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.deepPurple.shade900,
          title: const Text('코인 부족', style: TextStyle(color: Colors.white)),
          content: const Text('코인이 부족합니다. 타로 상담에는 코인 1개가 필요합니다.', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('확인', style: TextStyle(color: Colors.amberAccent)),
            ),
          ],
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade900,
        title: const Text('타로 상담 진행', style: TextStyle(color: Colors.white)),
        content: const Text('코인 1개를 소모하여 상담을 진행하시겠습니까?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
            child: const Text('진행', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await economy.deductCoin(1);
    if (!success) return;

    final question = _textController.text.trim();
    setState(() {
      _messages.add(ChatMessage(text: question, isUser: true));
      _currentQuestion = question;
      _textController.clear();
      _isWaitingForCards = true;
      
      // AI의 카드 뽑기 안내 메시지
      _messages.add(ChatMessage(
        text: AppLocalizations.of(context)!.chatAskPickCards,
        isUser: false,
      ));
    });
    _scrollToBottom();
    
    // 약간의 지연 후 바로 카드 뽑기 화면으로 자동 진입
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _navigateToPicking();
      }
    });
  }

  void _navigateToPicking() {
    setState(() {
      _isWaitingForCards = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingScreen(
          isForChat: true,
          onCardsPicked: _handleCardsPicked,
        ),
      ),
    );
  }

  void _handleCardsPicked(List<String> cards) async {
    setState(() {
      _messages.add(ChatMessage(
        text: AppLocalizations.of(context)!.chatReadingCards,
        isUser: false,
      ));
      _isTyping = true;
      _messages.add(ChatMessage(text: "", isUser: false)); // 스트리밍 결과를 담을 빈 메시지
    });
    _scrollToBottom();

    final stream = _aiService.getTarotReadingStream(_currentQuestion, cards, _selectedWitch.personalityPrompt, Localizations.localeOf(context).languageCode);
    
    await for (final chunk in stream) {
      if (mounted) {
        setState(() {
          final lastMsg = _messages.last;
          _messages[_messages.length - 1] = ChatMessage(
            text: lastMsg.text + chunk,
            isUser: false,
          );
        });
        _scrollToBottom();
      }
    }

    if (mounted) {
      setState(() {
        _isTyping = false;
      });
      _scrollToBottom();
      
      final cleanText = _messages.last.text.replaceAll(RegExp(r'\*+'), '');
      _ttsService.speak(_selectedWitch, cleanText, Localizations.localeOf(context).languageCode);

      // 다이어리 자동 저장
      _autoSaveDiary(cards, cleanText);

      // 마력의 가루 지급
      await EconomyService().addMagicDust(10);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('마력의 가루 +10 획득! ✨', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.purple,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _autoSaveDiary(List<String> pickedCards, String cleanText) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('diaries')
            .add({
          'cardId': pickedCards.isNotEmpty ? pickedCards[0] : '',
          'spreadType': '타로 상담',
          'myNote': _currentQuestion,
          'resultText': cleanText,
          'date': FieldValue.serverTimestamp(),
          'cardIds': pickedCards,
          'cardReversals': List.generate(pickedCards.length, (_) => false), // 현재 채팅에서는 역방향 지원 미구현이므로 전부 false
          'positionLabels': List.generate(pickedCards.length, (i) => '포지션 ${i + 1}'),
          'cardMeanings': List.generate(pickedCards.length, (_) => ''), // 의미는 상담 내용 안에 포함됨
          'witchId': _selectedWitch.id,
        });
      }
    } catch (e) {
      debugPrint('Error auto-saving diary: $e');
    }
  }

  Widget _buildMessage(ChatMessage message) {
    if (message.isButton) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: _navigateToPicking,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(AppLocalizations.of(context)!.chatPickCardsButton, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ),
      );
    }

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.purple.withOpacity(0.6) : Colors.white12,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isUser ? const Radius.circular(0) : null,
            bottomLeft: !message.isUser ? const Radius.circular(0) : null,
          ),
        ),
        // constraints removed so it can expand to full width of the parent
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '초기화 오류 발생:\n$_initError',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }
    
    try {
      return GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  borderRadius: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _showWitchProfile,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purpleAccent,
                                image: DecorationImage(
                                  image: AssetImage(_selectedWitch.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _selectedWitch.name,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedWitch.title,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.pinkAccent),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.chatProfileTapHint,
                                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Witch>(
                            value: _selectedWitch,
                            dropdownColor: Colors.deepPurple.shade900,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                            isExpanded: true,
                            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            onChanged: (Witch? newValue) {
                              if (newValue != null && newValue != _selectedWitch) {
                                _changeWitch(newValue);
                              }
                            },
                            items: _witches.map<DropdownMenuItem<Witch>>((Witch witch) {
                              return DropdownMenuItem<Witch>(
                                value: witch,
                                child: Text('${witch.name} - ${witch.title}'),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Message List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),
              
              // Typing Indicator
              if (_isTyping && _messages.isNotEmpty && _messages.last.text.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.purpleAccent),
                ),

              // Input Area
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassContainer(
                  borderRadius: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: _isWaitingForCards ? AppLocalizations.of(context)!.chatHintPickCardsFirst : AppLocalizations.of(context)!.chatHintWriteConcern,
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          enabled: !_isWaitingForCards && !_isTyping,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.pinkAccent),
                        onPressed: (_isWaitingForCards || _isTyping) ? null : _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e, stackTrace) {
      return Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '오류 발생:\n$e\n\n$stackTrace',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }
  }
}
