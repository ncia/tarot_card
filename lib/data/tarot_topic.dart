import 'package:flutter/material.dart';

enum TarotTopicGroup {
  love,
  wealth,
  academic,
  time,
  inner,
}

class TarotTopic {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final TarotTopicGroup group;

  const TarotTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.group,
  });
}

const List<TarotTopic> tarotTopics = [
  // 💕 사랑과 인연 (Love)
  TarotTopic(id: 'love', title: '연애운', description: '나의 연애 흐름과 다가올 인연', icon: Icons.favorite, group: TarotTopicGroup.love),
  TarotTopic(id: 'inner_feelings', title: '속마음', description: '그 사람의 진짜 속마음은?', icon: Icons.psychology, group: TarotTopicGroup.love),
  TarotTopic(id: 'marriage', title: '결혼운', description: '결혼 시기와 앞으로의 가정', icon: Icons.diversity_1, group: TarotTopicGroup.love),

  // 💰 재물과 성취 (Wealth)
  TarotTopic(id: 'wealth', title: '금전운', description: '나의 재물 흐름과 투자운', icon: Icons.monetization_on, group: TarotTopicGroup.wealth),
  TarotTopic(id: 'business', title: '사업운', description: '사업의 성공과 앞으로의 방향', icon: Icons.store, group: TarotTopicGroup.wealth),
  TarotTopic(id: 'employment', title: '취업운', description: '합격 소식과 직장 인연', icon: Icons.work, group: TarotTopicGroup.wealth),

  // 📚 배움과 나아감 (Academic/Career)
  TarotTopic(id: 'academic', title: '학업운', description: '시험 합격과 성적 향상', icon: Icons.school, group: TarotTopicGroup.academic),
  TarotTopic(id: 'career', title: '진로운', description: '나에게 맞는 길과 적성', icon: Icons.explore, group: TarotTopicGroup.academic),
  TarotTopic(id: 'health', title: '건강운', description: '건강 상태와 주의할 점', icon: Icons.health_and_safety, group: TarotTopicGroup.academic),

  // ⏳ 시간의 흐름 (Time)
  TarotTopic(id: 'today', title: '오늘운', description: '오늘 하루 나에게 일어날 일', icon: Icons.today, group: TarotTopicGroup.time),
  TarotTopic(id: 'weekly', title: '한주운', description: '이번 주간의 전반적인 흐름', icon: Icons.calendar_view_week, group: TarotTopicGroup.time),
  TarotTopic(id: 'new_year', title: '신년운', description: '올 한 해의 종합적인 운세', icon: Icons.event, group: TarotTopicGroup.time),

  // 🧠 깊은 내면 (Inner)
  TarotTopic(id: 'advice', title: '심리조언', description: '지친 마음을 위한 따뜻한 조언', icon: Icons.self_improvement, group: TarotTopicGroup.inner),
  TarotTopic(id: 'choice', title: '고민선택', description: 'A와 B, 두 가지 선택지 사이에서', icon: Icons.call_split, group: TarotTopicGroup.inner),
];
