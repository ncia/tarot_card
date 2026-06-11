import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

class ReadingIntroScreen extends StatefulWidget {
  final void Function(BuildContext) onStart;

  const ReadingIntroScreen({super.key, required this.onStart});

  @override
  State<ReadingIntroScreen> createState() => _ReadingIntroScreenState();
}

class _ReadingIntroScreenState extends State<ReadingIntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _purpleAnimController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // 1. 보라색 오라 애니메이션 (천천히 숨쉬기)
    _purpleAnimController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 3)
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(begin: 0.1, end: 0.6).animate(
      CurvedAnimation(parent: _purpleAnimController, curve: Curves.easeInOutSine)
    );
  }

  @override
  void dispose() {
    _purpleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 배경 이미지 전체 덮기
          Image.asset(
            'assets/images/fortune_teller.jpg',
            fit: BoxFit.cover,
          ),
          
          // 2. 마녀(중앙)를 제외하고 배경 쪽에만 보라색 불빛이 숨쉬듯 빛나는 효과
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.2), // 마녀의 상단 중심 위치
                    radius: 1.2,
                    colors: [
                      Colors.transparent, // 중앙(마녀)은 투명하게 유지
                      Colors.purple.withOpacity(_glowAnimation.value), // 주변은 보라색 빛
                      Colors.deepPurple.withOpacity(_glowAnimation.value * 0.8),
                    ],
                    stops: const [0.35, 0.8, 1.0], // 0.35까지는 투명해서 마녀가 보임
                  ),
                ),
              );
            },
          ),
          
          // 3. 텍스트 가독성을 위한 아주 옅은 어두운 오버레이
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3), // 텍스트를 수정구슬 위치(중앙)로 내리기 위한 여백
                
                // 중앙 텍스트
                Text(
                  AppLocalizations.of(context)?.readingIntroTitle ?? '운명의\n속삭임',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 36,
                    height: 1.2,
                    shadows: [
                      const Shadow(
                        color: Colors.black87,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)?.readingIntroSubtitle ?? '신비로운 힘이 당신을 기다립니다...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(flex: 2), // 하단 버튼과의 여백
                
                // 하단 버튼 (전체 너비 둥근 직사각형)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
                  child: InkWell(
                    onTap: () => widget.onStart(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6), // 어둡고 투명한 배경
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ]
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)?.readingIntroButton ?? '운명 확인하기',
                        style: const TextStyle(
                          fontSize: 18, 
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
