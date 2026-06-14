import 'package:flutter/material.dart';
import '../screens/shop_screen.dart';
import '../screens/growth_screen.dart';
import 'animated_volume_control.dart';
import 'magic_dust_widget.dart';
import 'coin_widget.dart';

class TopFloatingIcons extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onShop;
  final VoidCallback? onGrowth;

  const TopFloatingIcons({
    super.key,
    this.showBackButton = false,
    this.onBack,
    this.onShop,
    this.onGrowth,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 좌측 상단 플로팅 아이콘들 (상점, 성장, 그리고 그 아래 뒤로가기)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 상점 아이콘
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(19),
                        onTap: onShop ?? () {
                          if (ModalRoute.of(context)?.settings.name == '/shop') return;
                          
                          final route = MaterialPageRoute(
                            builder: (context) => const ShopScreen(),
                            settings: const RouteSettings(name: '/shop'),
                          );
                          
                          if (showBackButton) {
                            Navigator.pushReplacement(context, route);
                          } else {
                            Navigator.push(context, route);
                          }
                        },
                        child: const Icon(Icons.storefront_outlined, color: Colors.amberAccent, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 성장 아이콘
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(19),
                        onTap: onGrowth ?? () {
                          if (ModalRoute.of(context)?.settings.name == '/growth') return;

                          final route = MaterialPageRoute(
                            builder: (context) => const GrowthScreen(),
                            settings: const RouteSettings(name: '/growth'),
                          );

                          if (showBackButton) {
                            Navigator.pushReplacement(context, route);
                          } else {
                            Navigator.push(context, route);
                          }
                        },
                        child: const Icon(Icons.spa_outlined, color: Colors.lightGreenAccent, size: 20),
                      ),
                    ),
                  ],
                ),
                if (showBackButton) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(19),
                      onTap: onBack ?? () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ],
            ),
            // 우측 상단 플로팅 아이콘들 (스피커, 마력, 코인)
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedVolumeControl(),
                MagicDustWidget(),
                CoinWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
