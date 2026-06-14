import 'package:cloud_firestore/cloud_firestore.dart';

class TarotDiary {
  final String id;
  // Legacy support
  final String cardId;
  final String resultText;
  
  // Premium multi-card support
  final List<String> cardIds;
  final List<bool> cardReversals;
  final List<String> positionLabels;
  final List<String> cardMeanings;
  
  final String spreadType;
  final String myNote;
  final DateTime date;
  final String? witchId;

  TarotDiary({
    required this.id,
    required this.cardId,
    required this.spreadType,
    required this.myNote,
    required this.resultText,
    required this.date,
    this.cardIds = const [],
    this.cardReversals = const [],
    this.positionLabels = const [],
    this.cardMeanings = const [],
    this.witchId,
  });

  factory TarotDiary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // 호환성 처리: 옛날 버전 데이터라면 첫 번째 카드 정보를 리스트로 변환
    final legacyCardId = data['cardId'] ?? '';
    final legacyResultText = data['resultText'] ?? '';
    
    return TarotDiary(
      id: doc.id,
      cardId: legacyCardId,
      spreadType: data['spreadType'] ?? 'one_card',
      myNote: data['myNote'] ?? '',
      resultText: legacyResultText,
      date: (data['date'] as Timestamp).toDate(),
      cardIds: data['cardIds'] != null ? List<String>.from(data['cardIds']) : (legacyCardId.isNotEmpty ? [legacyCardId] : []),
      cardReversals: data['cardReversals'] != null ? List<bool>.from(data['cardReversals']) : [false],
      positionLabels: data['positionLabels'] != null ? List<String>.from(data['positionLabels']) : ['현재 상황'],
      cardMeanings: data['cardMeanings'] != null ? List<String>.from(data['cardMeanings']) : [legacyResultText],
      witchId: data['witchId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'spreadType': spreadType,
      'myNote': myNote,
      'resultText': resultText,
      'date': Timestamp.fromDate(date),
      'cardIds': cardIds,
      'cardReversals': cardReversals,
      'positionLabels': positionLabels,
      'cardMeanings': cardMeanings,
      'witchId': witchId,
    };
  }
}
