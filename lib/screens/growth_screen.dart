import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../services/economy_service.dart';
import '../widgets/shared_bottom_nav_bar.dart';
import '../widgets/top_floating_icons.dart';
import 'main_screen.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';

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
                        Text(
                          AppLocalizations.of(context)!.growthTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.growthSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.amberAccent,
                          labelColor: Colors.amberAccent,
                          unselectedLabelColor: Colors.white54,
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.lens_blur),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)!.growthTabCrystalBall),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.park),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)!.growthTabWorldTree),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        _CrystalBallTab(),
                        _WorldTreeTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: TopFloatingIcons(
                onGrowth: () {}, // 이미 성장 화면이므로 동작 안 함
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(
        currentIndex: mainScreenKey.currentState?.currentIndex ?? 0,
        onTap: (index) {
          mainScreenKey.currentState?.switchTab(index);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
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
        SnackBar(content: Text(AppLocalizations.of(context)!.growthWaterSuccess)),
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

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.growthWorldTreeLevel(level), style: Theme.of(context).textTheme.displayLarge),
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
                    Text('${AppLocalizations.of(context)!.growthExp}${exp % 50} / 50', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isWatering ? null : _waterTree,
                icon: const Icon(Icons.water_drop),
                label: Text(AppLocalizations.of(context)!.growthWaterFree),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
                  ),
                ),
              ),
            );
          },
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
          SnackBar(content: Text(AppLocalizations.of(context)!.growthUpgradeSuccess)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.growthUpgradeNotEnough)),
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

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: 20,
                child: Text(
                  AppLocalizations.of(context)!.growthDustOwned(dust),
                  style: const TextStyle(color: Colors.purpleAccent, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              Text(AppLocalizations.of(context)!.growthCrystalBallLevel(level), style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/crystal_ball.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                onPressed: _isUpgrading ? null : _upgradeBall,
                icon: const Icon(Icons.auto_awesome),
                label: Text(AppLocalizations.of(context)!.growthUpgradeButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
