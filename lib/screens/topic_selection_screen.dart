import 'package:flutter/material.dart';
import '../data/tarot_topic.dart';
import '../data/witch_data.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class TopicSelectionScreen extends StatefulWidget {
  final bool showBackButton;
  final Witch? selectedWitch;

  const TopicSelectionScreen({
    super.key,
    this.showBackButton = false,
    this.selectedWitch,
  });

  @override
  State<TopicSelectionScreen> createState() => _TopicSelectionScreenState();
}

class _TopicSelectionScreenState extends State<TopicSelectionScreen> {
  void _openTopicForm(TarotTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _TopicFormBottomSheet(
          topic: topic,
          onSubmit: (String promptData) {
            Navigator.pop(ctx);
            // 다음 화면(스프레드 선택)으로 이동하며 데이터 전달
            Navigator.pushNamed(
              context,
              '/selection',
              arguments: {
                'witch': widget.selectedWitch,
                'topicPrompt': promptData,
              },
            );
          },
        );
      },
    );
  }

  Color _getGroupColor(TarotTopicGroup group) {
    switch (group) {
      case TarotTopicGroup.love:
        return Colors.pinkAccent;
      case TarotTopicGroup.wealth:
        return Colors.amberAccent;
      case TarotTopicGroup.academic:
        return Colors.lightBlueAccent;
      case TarotTopicGroup.time:
        return Colors.deepPurpleAccent;
      case TarotTopicGroup.inner:
        return Colors.purpleAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (widget.showBackButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Expanded(
                      child: Text(
                        '어떤 고민이 있으신가요?',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (widget.showBackButton) const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '정확한 리딩을 위해 타로 주제를 선택해주세요.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: tarotTopics.length,
                    itemBuilder: (context, index) {
                      final topic = tarotTopics[index];
                      final color = _getGroupColor(topic.group);
                      
                      return GestureDetector(
                        onTap: () => _openTopicForm(topic),
                        child: GlassContainer(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(topic.icon, color: color, size: 36),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                topic.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                topic.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }
}

class _TopicFormBottomSheet extends StatefulWidget {
  final TarotTopic topic;
  final Function(String) onSubmit;

  const _TopicFormBottomSheet({required this.topic, required this.onSubmit});

  @override
  State<_TopicFormBottomSheet> createState() => _TopicFormBottomSheetState();
}

class _TopicFormBottomSheetState extends State<_TopicFormBottomSheet> {
  // 공통 폼 컨트롤러 및 상태
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();
  String _dropdownValue1 = '';
  String _dropdownValue2 = '';

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  void _submit() {
    // 주제별 프롬프트 구성
    String prompt = '주제: ${widget.topic.title}\n';
    
    switch (widget.topic.id) {
      case 'love':
        prompt += '현재 상태: $_dropdownValue1\n';
        if (_field1Controller.text.isNotEmpty) {
          prompt += '궁금한 점: ${_field1Controller.text}\n';
        }
        break;
      case 'inner_feelings':
        prompt += '상대방 이름(애칭): ${_field1Controller.text}\n';
        prompt += '나와의 관계: $_dropdownValue1\n';
        break;
      case 'marriage':
        prompt += '현재 상태: $_dropdownValue1\n';
        if (_field1Controller.text.isNotEmpty) {
          prompt += '결혼에 대한 고민: ${_field1Controller.text}\n';
        }
        break;
      case 'wealth':
        prompt += '주요 관심사: $_dropdownValue1\n';
        if (_field1Controller.text.isNotEmpty) {
          prompt += '구체적인 금전 상황: ${_field1Controller.text}\n';
        }
        break;
      case 'business':
        prompt += '사업 단계: $_dropdownValue1\n';
        if (_field1Controller.text.isNotEmpty) {
          prompt += '업종 및 구체적 고민: ${_field1Controller.text}\n';
        }
        break;
      case 'employment':
        prompt += '현재 상태: $_dropdownValue1\n';
        prompt += '희망 직무/회사: ${_field1Controller.text}\n';
        break;
      case 'academic':
        prompt += '준비 중인 시험/전공: ${_field1Controller.text}\n';
        if (_field2Controller.text.isNotEmpty) {
          prompt += '학업 고민: ${_field2Controller.text}\n';
        }
        break;
      case 'career':
        prompt += '고민 분야: $_dropdownValue1\n';
        prompt += '현재 가장 큰 고민: ${_field1Controller.text}\n';
        break;
      case 'health':
        prompt += '신경 쓰이는 증상: ${_field1Controller.text}\n';
        break;
      case 'today':
        if (_field1Controller.text.isNotEmpty) {
          prompt += '오늘 앞두고 있는 일: ${_field1Controller.text}\n';
        }
        break;
      case 'weekly':
        if (_field1Controller.text.isNotEmpty) {
          prompt += '이번 주 바라는 점/일정: ${_field1Controller.text}\n';
        }
        break;
      case 'new_year':
        prompt += '궁금한 연도: $_dropdownValue1\n';
        if (_dropdownValue2.isNotEmpty) {
          prompt += '관심 분야: $_dropdownValue2\n';
        }
        break;
      case 'advice':
        prompt += '오늘의 기분 상태: $_dropdownValue1\n';
        prompt += '무거운 고민: ${_field1Controller.text}\n';
        break;
      case 'choice':
        prompt += '선택지 A: ${_field1Controller.text}\n';
        prompt += '선택지 B: ${_field2Controller.text}\n';
        break;
    }
    
    widget.onSubmit(prompt.trim());
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isLong = false, bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: isLong ? 3 : 1,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint + (isRequired ? ' (필수)' : ' (선택)'),
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> options, String value, Function(String?) onChanged) {
    // 초기값이 비어있고 옵션이 있으면 첫 번째 옵션으로 설정
    if (value.isEmpty && options.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChanged(options.first);
      });
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.isEmpty && options.isNotEmpty ? options.first : value,
                isExpanded: true,
                dropdownColor: Colors.deepPurple.shade900,
                style: const TextStyle(color: Colors.white),
                items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicForm() {
    switch (widget.topic.id) {
      case 'love':
        return Column(
          children: [
            _buildDropdown('현재 상태', ['싱글', '썸 타는 중', '연애 중', '이별'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '상대방과의 관계나 궁금한 점 (예: 언제쯤 연인이 생길까요?)'),
          ],
        );
      case 'inner_feelings':
        return Column(
          children: [
            _buildTextField(_field1Controller, '상대방의 이름 또는 애칭', isRequired: true),
            _buildDropdown('나와의 관계', ['직장동료', '친구', '전연인', '썸', '기타'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
          ],
        );
      case 'marriage':
        return Column(
          children: [
            _buildDropdown('현재 상태', ['미혼(연인 없음)', '미혼(연인 있음)', '기혼'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '결혼에 대한 구체적인 고민'),
          ],
        );
      case 'wealth':
        return Column(
          children: [
            _buildDropdown('주요 관심사', ['투자', '수입 증가', '지출 관리', '빚 청산'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '구체적인 금전 상황이나 목표'),
          ],
        );
      case 'business':
        return Column(
          children: [
            _buildDropdown('사업 단계', ['구상 중', '창업 초기', '안정기', '확장기', '위기'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '업종 및 구체적인 고민'),
          ],
        );
      case 'employment':
        return Column(
          children: [
            _buildDropdown('현재 상태', ['취준생', '이직 준비', '프리랜서'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '희망 직무 또는 회사', isRequired: true),
          ],
        );
      case 'academic':
        return Column(
          children: [
            _buildTextField(_field1Controller, '준비 중인 시험이나 전공 (예: 수능, 토익)', isRequired: true),
            _buildTextField(_field2Controller, '학업에 대한 고민', isLong: true),
          ],
        );
      case 'career':
        return Column(
          children: [
            _buildDropdown('고민 분야', ['적성 찾기', '직업 변경', '진학', '유학'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '현재 가장 큰 고민거리', isRequired: true, isLong: true),
          ],
        );
      case 'health':
        return Column(
          children: [
            _buildTextField(_field1Controller, '신경 쓰이는 부위나 증상', isRequired: true),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '*안내: 타로는 의학적 진단을 대신할 수 없습니다.',
                style: TextStyle(color: Colors.amberAccent, fontSize: 12),
              ),
            ),
          ],
        );
      case 'today':
        return _buildTextField(_field1Controller, '오늘 특별히 앞두고 있는 일', isLong: true);
      case 'weekly':
        return _buildTextField(_field1Controller, '이번 주에 바라는 점이나 주요 일정', isLong: true);
      case 'new_year':
        return Column(
          children: [
            _buildDropdown('알아보고 싶은 연도', ['2026년', '2027년', '2028년'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildDropdown('가장 궁금한 분야', ['종합', '연애', '금전', '건강'], _dropdownValue2, (v) => setState(() => _dropdownValue2 = v!)),
          ],
        );
      case 'advice':
        return Column(
          children: [
            _buildDropdown('오늘의 기분 상태', ['😡 화남', '😢 슬픔', '😐 그저그럼', '🙂 좋음', '😍 행복함'], _dropdownValue1, (v) => setState(() => _dropdownValue1 = v!)),
            _buildTextField(_field1Controller, '마음을 무겁게 하는 고민', isRequired: true, isLong: true),
          ],
        );
      case 'choice':
        return Column(
          children: [
            _buildTextField(_field1Controller, '선택지 A (예: 지금 회사에 남는다)', isRequired: true),
            _buildTextField(_field2Controller, '선택지 B (예: 이직한다)', isRequired: true),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 키보드 올라올 때 공간 확보를 위한 bottom padding
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), // 진한 네이비/퍼플 배경
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(widget.topic.icon, color: Colors.amberAccent, size: 28),
                const SizedBox(width: 12),
                Text(
                  widget.topic.title,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.topic.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 24),
            
            _buildDynamicForm(),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                '타로 보기',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
