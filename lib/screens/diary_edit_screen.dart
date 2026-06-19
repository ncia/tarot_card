import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../data/tarot_data.dart';
import '../data/tarot_diary.dart';
import '../services/diary_service.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';

class DiaryEditScreen extends StatefulWidget {
  final List<TarotCardData> cards;
  final List<bool> cardReversals;
  final List<String> positionLabels;
  final List<String> cardMeanings;
  final String spreadType;

  const DiaryEditScreen({
    super.key,
    required this.cards,
    required this.cardReversals,
    required this.positionLabels,
    required this.cardMeanings,
    required this.spreadType,
  });

  @override
  State<DiaryEditScreen> createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  final _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveDiary() async {
    setState(() => _isSaving = true);
    try {
      final diary = TarotDiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardId: widget.cards.isNotEmpty ? widget.cards[0].id : '',
        spreadType: widget.spreadType,
        myNote: _noteController.text,
        resultText: widget.cardMeanings.isNotEmpty ? widget.cardMeanings[0] : '',
        date: DateTime.now(),
        cardIds: widget.cards.map((c) => c.id).toList(),
        cardReversals: widget.cardReversals,
        positionLabels: widget.positionLabels,
        cardMeanings: widget.cardMeanings,
      );

      await DiaryService.instance.saveDiary(diary);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('일기가 저장되었습니다!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('저장에 실패했습니다.')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildPremiumMeanings() {
    return Column(
      children: List.generate(widget.cards.length, (index) {
        final card = widget.cards[index];
        final label = widget.positionLabels.length > index ? widget.positionLabels[index] : '포지션 $index';
        final meaning = widget.cardMeanings.length > index ? widget.cardMeanings[index] : '';
        final isRev = widget.cardReversals.length > index ? widget.cardReversals[index] : false;
        final revText = isRev ? AppLocalizations.of(context)!.spreadReversed : AppLocalizations.of(context)!.spreadUpright;

        return GlassContainer(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽: 카드 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 125,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(card.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: isRev ? Transform.rotate(angle: 3.14159, child: Container()) : null,
                ),
              ),
              const SizedBox(width: 16),
              // 오른쪽: 텍스트 설명
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${TarotLocalizations.getName(context, card.id)} ($revText)',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meaning,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('일기 쓰기', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPremiumMeanings(),
                const SizedBox(height: 24),
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: TextField(
                    controller: _noteController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: '오늘의 점괘에 대한 나의 생각이나 느낌을 자유롭게 적어보세요.',
                      hintStyle: TextStyle(color: Colors.white30),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_isSaving)
                  const Center(child: CircularProgressIndicator(color: Colors.amberAccent))
                else
                  ElevatedButton(
                    onPressed: _saveDiary,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('일기에 저장하기', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
