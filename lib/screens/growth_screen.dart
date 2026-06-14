import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../services/economy_service.dart';

class GrowthScreen extends StatefulWidget {
  const GrowthScreen({super.key});

  @override
  State<GrowthScreen> createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
                    child: Column(
                      children: [
                        const Text(
                          '성장',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
                        ),
                        const SizedBox(height: 24),
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.amberAccent,
                          labelColor: Colors.amberAccent,
                          unselectedLabelColor: Colors.white54,
                          tabs: const [
                            Tab(text: '세계수 키우기', icon: Icon(Icons.park)),
                            Tab(text: '수정구 강화', icon: Icon(Icons.lens_blur)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        _WorldTreeTab(),
                        _CrystalBallTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldTreeTab extends StatefulWidget {
  const _WorldTreeTab();

  @override
  State<_WorldTreeTab> createState() => _WorldTreeTabState();
}

class _WorldTreeTabState extends State<_WorldTreeTab> {
  bool _isWatering = false;

  void _waterTree() async {
    setState(() {
      _isWatering = true;
    });
    await EconomyService().addWorldTreeExp(10);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('세계수에 물을 주어 경험치가 10 상승했습니다! 💧')),
      );
      setState(() {
        _isWatering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EconomyService(),
      builder: (context, _) {
        final exp = EconomyService().worldTreeExp;
        final level = (exp / 50).floor() + 1;
        final progress = (exp % 50) / 50.0;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('세계수 레벨 $level', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 20),
              // 세계수 이미지 (레벨에 따라 다른 이미지 등을 보여줄 수 있음)
              Icon(
                Icons.park,
                size: 150 + (level * 10).clamp(0, 100).toDouble(),
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      color: Colors.greenAccent,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 8),
                    Text('경험치: ${exp % 50} / 50', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isWatering ? null : _waterTree,
                icon: const Icon(Icons.water_drop),
                label: const Text('무료로 물 주기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CrystalBallTab extends StatefulWidget {
  const _CrystalBallTab();

  @override
  State<_CrystalBallTab> createState() => _CrystalBallTabState();
}

class _CrystalBallTabState extends State<_CrystalBallTab> {
  bool _isUpgrading = false;

  void _upgradeBall() async {
    final success = await EconomyService().upgradeCrystalBall(10);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수정구 강화 성공! ✨')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('마력의 가루가 부족합니다. (필요: 10개)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EconomyService(),
      builder: (context, _) {
        final level = EconomyService().crystalBallExp + 1;
        final dust = EconomyService().magicDust;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: 20,
                child: Text(
                  '보유 마력의 가루: $dust 개',
                  style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              Text('신비의 수정구 레벨 $level', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.purpleAccent.withOpacity(0.5 + (level * 0.05).clamp(0.0, 0.5)),
                      Colors.deepPurple.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.4 + (level * 0.05).clamp(0.0, 0.6)),
                      blurRadius: 40 + (level * 5).toDouble(),
                      spreadRadius: 10 + (level * 2).toDouble(),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.lens_blur,
                    size: 120,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                onPressed: _isUpgrading ? null : _upgradeBall,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('강화하기 (가루 10개)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
