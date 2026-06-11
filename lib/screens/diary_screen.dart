import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../data/tarot_diary.dart';
import '../data/tarot_data.dart';
import 'package:flutter_tarot/l10n/tarot_localizations.dart';
import 'package:intl/intl.dart';
import 'auth_screen.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFirebaseInitialized = false;
    try {
      isFirebaseInitialized = Firebase.apps.isNotEmpty;
    } catch (e) {
      // Ignore
    }

    if (!isFirebaseInitialized) {
      return _buildMockDiaryList(context);
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const GradientBackground(child: Center(child: CircularProgressIndicator()));
        }

        final user = authSnapshot.data;
        if (user == null) {
          return _buildLoginRequired(context);
        }

        if (!user.emailVerified) {
          return _buildEmailVerificationRequired(context, user);
        }

        return _buildDiaryList(context, user);
      },
    );
  }

  Widget _buildMockDiaryList(BuildContext context) {
    final mockDiaries = [
      TarotDiary(
        id: 'mock1',
        cardId: 'the_fool',
        spreadType: 'one_card',
        date: DateTime.now().subtract(const Duration(days: 1)),
        resultText: '오늘 나의 하루는 어떨까?',
        myNote: '새로운 시작을 의미하는 바보 카드가 나왔다. 무언가 새로운 도전을 하기에 좋은 날인 것 같다! 기분이 설렌다.',
      ),
      TarotDiary(
        id: 'mock2',
        cardId: 'the_magician',
        spreadType: 'one_card',
        date: DateTime.now().subtract(const Duration(days: 3)),
        resultText: '진행 중인 프로젝트의 결과는?',
        myNote: '마법사 카드! 내게 필요한 모든 능력이 이미 갖춰져 있다는 뜻이다. 자신감을 가지고 추진해보자.',
      ),
      TarotDiary(
        id: 'mock3',
        cardId: 'the_high_priestess',
        spreadType: 'one_card',
        date: DateTime.now().subtract(const Duration(days: 5)),
        resultText: '요즘 내 마음이 복잡한 이유',
        myNote: '고위 여사제. 직관에 귀를 기울이라고 한다. 겉으로 드러난 상황보다 내면의 소리에 집중할 필요가 있다.',
      ),
    ];

    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('나의 타로 일기', style: Theme.of(context).textTheme.displayLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                    ),
                    child: const Text('파이어베이스 미연결 (미리보기)', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mockDiaries.length,
                itemBuilder: (context, index) {
                  final diary = mockDiaries[index];
                  final card = tarotDeck.firstWhere((c) => c.id == diary.cardId, orElse: () => tarotDeck.first);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 16,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDiaryThumbnails(diary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('yyyy.MM.dd HH:mm').format(diary.date),
                                  style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      TarotLocalizations.getName(context, card.id),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Q: ${diary.resultText}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  diary.myNote,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context) {
    return GradientBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.white70),
            const SizedBox(height: 24),
            Text('타로 일기장은 로그인 후 이용할 수 있습니다.', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              child: const Text('로그인 또는 회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailVerificationRequired(BuildContext context, User user) {
    return GradientBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 80, color: Colors.amberAccent),
            const SizedBox(height: 24),
            Text('이메일 인증이 필요합니다.', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Text('가입하신 이메일(${user.email})로\n발송된 인증 링크를 클릭해주세요.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await user.sendEmailVerification();
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증 메일이 재발송되었습니다.')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              child: const Text('인증 메일 재발송'),
            ),
            TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('로그아웃', style: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaryList(BuildContext context, User user) {
    return GradientBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('나의 타로 일기', style: Theme.of(context).textTheme.displayLarge),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('diaries')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('아직 작성된 일기가 없습니다.\\n오늘의 점괘를 확인하고 일기를 남겨보세요!', 
                        textAlign: TextAlign.center, 
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  final diaries = snapshot.data!.docs.map((doc) => TarotDiary.fromFirestore(doc)).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: diaries.length,
                    itemBuilder: (context, index) {
                      final diary = diaries[index];
                      final card = tarotDeck.firstWhere((c) => c.id == diary.cardId, orElse: () => tarotDeck.first);
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GlassContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: 16,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _buildDiaryThumbnails(diary),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('yyyy.MM.dd HH:mm').format(diary.date),
                                      style: const TextStyle(color: Colors.amberAccent, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      TarotLocalizations.getName(context, card.id),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      diary.myNote,
                                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDiaryThumbnails(TarotDiary diary) {
    if (diary.cardIds.length <= 1) {
      final cardId = diary.cardIds.isNotEmpty ? diary.cardIds.first : diary.cardId;
      final card = tarotDeck.firstWhere((c) => c.id == cardId, orElse: () => tarotDeck.first);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(card.imagePath, width: 60, height: 90, fit: BoxFit.cover),
      );
    }

    final displayCount = diary.cardIds.length > 4 ? 4 : diary.cardIds.length;
    return SizedBox(
      width: 60.0 + (displayCount - 1) * 15.0,
      height: 90,
      child: Stack(
        children: List.generate(displayCount, (index) {
          final cardId = diary.cardIds[index];
          final card = tarotDeck.firstWhere((c) => c.id == cardId, orElse: () => tarotDeck.first);
          return Positioned(
            left: index * 15.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 0))
                ]
              ),
              child:
                          _buildDiaryThumbnails(diary),
            ),
          );
        }),
      ),
    );
  }
}
