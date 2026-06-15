import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../data/tarot_data.dart';
import '../data/tarot_detail_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';

class CardDetailScreen extends StatefulWidget {
  final TarotCardData card;
  final bool initialIsReversed;
  final String? heroTag;

  const CardDetailScreen({
    super.key, 
    required this.card,
    this.initialIsReversed = false,
    this.heroTag,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  TarotDetailData? _detailData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/tarot_details_ko.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      final data = jsonList.firstWhere(
        (element) => element['id'] == widget.card.id,
        orElse: () => null,
      );

      if (data != null) {
        setState(() {
          _detailData = TarotDetailData.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = '상세 해석 데이터가 아직 준비되지 않았습니다.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = '데이터를 불러오는 중 오류가 발생했습니다.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 65),
        child: Column(
          children: [
            const SizedBox(height: 65),
            AppBar(
              title: Text(widget.card.name),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ],
        ),
      ),
      body: GradientBackground(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : DefaultTabController(
              length: 2,
              initialIndex: widget.initialIsReversed ? 1 : 0,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 20),
                  // Card Image with Hero
                  Hero(
                    tag: widget.heroTag ?? 'card_\${widget.card.id}',
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(widget.card.imagePath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    tabs: [
                      Tab(text: '정방향 (Upright)'),
                      Tab(text: '역방향 (Reversed)'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildDetailContent(_detailData?.upright, isUpright: true),
                        _buildDetailContent(_detailData?.reversed, isUpright: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildDetailContent(TarotDirectionDetail? detail, {required bool isUpright}) {
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.white)));
    }
    if (detail == null) {
      return const Center(child: Text('데이터가 없습니다.', style: TextStyle(color: Colors.white)));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        _buildSection('핵심 키워드', detail.keyMeanings),
        _buildSection('일반 해석', detail.general),
        _buildSection('연애 및 관계', detail.love),
        _buildSection('금전 및 커리어', detail.career),
        _buildSection('건강', detail.health),
        _buildSection('영성 및 내면', detail.spirituality),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
