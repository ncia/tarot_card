import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/spread_layouts.dart';
import '../widgets/witch_profile_dialog.dart';
import '../data/tarot_diary.dart';
import '../data/tarot_data.dart';
import '../data/witch_data.dart';
import '../data/spread_type.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends StatelessWidget {
  final TarotDiary diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    // SpreadType 복원
    SpreadType spreadType;
    if (diary.spreadType == '타로 상담') {
      // 타로 상담(채팅)인 경우, 카드 개수에 맞는 스프레드 레이아웃을 임시로 선택
      if (diary.cardIds.length == 1) spreadType = SpreadType.oneCard;
      else if (diary.cardIds.length == 2) spreadType = SpreadType.twoCard;
      else if (diary.cardIds.length == 3) spreadType = SpreadType.threeCard;
      else if (diary.cardIds.length == 4) spreadType = SpreadType.fourCard;
      else if (diary.cardIds.length == 5) spreadType = SpreadType.fiveCard;
      else if (diary.cardIds.length == 10) spreadType = SpreadType.celticCross;
      else spreadType = SpreadType.oneCard; // fallback
    } else {
      spreadType = SpreadType.values.firstWhere(
        (e) => e.name == diary.spreadType,
        orElse: () => SpreadType.oneCard,
      );
    }

    // SpreadLayoutBuilder에 전달할 데이터 구성
    final shuffledDeck = diary.cardIds.map((id) => tarotDeck.firstWhere((c) => c.id == id, orElse: () => tarotDeck.first)).toList();
    final selectedCardIndices = List.generate(shuffledDeck.length, (i) => i);
    
    // 만약 예전 데이터라 cardReversals가 비어있거나 모자라다면 false로 채움
    final shuffledReversed = List.generate(shuffledDeck.length, (i) {
      if (i < diary.cardReversals.length) return diary.cardReversals[i];
      return false;
    });

    final witches = getLocalizedWitches(context);
    final witch = witches.firstWhere((w) => w.id == diary.witchId, orElse: () => witches.first);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          DateFormat('yyyy년 MM월 dd일 HH:mm').format(diary.date),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (diary.myNote.isNotEmpty && diary.myNote != '타로 리딩') ...[
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('나의 질문', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(diary.myNote, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
                
                // 스프레드 레이아웃 렌더링
                SpreadLayoutBuilder(
                  spreadType: spreadType,
                  selectedCardIndices: selectedCardIndices,
                  shuffledDeck: shuffledDeck,
                  shuffledReversed: shuffledReversed,
                  isForChat: false,
                ),
                
                const SizedBox(height: 20),
                
                // 리딩 결과 영역 (타로점 볼 때와 동일한 스타일)
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showWitchProfileDialog(context, witch);
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(witch.imagePath),
                              radius: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${witch.name}의 타로점',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        diary.resultText.isNotEmpty ? diary.resultText : (diary.cardMeanings.isNotEmpty ? diary.cardMeanings.join('\n\n') : '결과가 없습니다.'),
                        style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
