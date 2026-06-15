import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 65),
          child: Column(
            children: [
              const SizedBox(height: 65),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            GradientBackground(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 80, 16, 10),
                      child: Column(
                        children: [
                          Text(
                            '상점',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '코인과 스킨을 구매하세요',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                          const TabBar(
                            indicatorColor: Colors.amberAccent,
                            labelColor: Colors.amberAccent,
                            unselectedLabelColor: Colors.white54,
                            tabs: [
                              Tab(text: '코인'),
                              Tab(text: '스킨'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildCoinGrid(context),
                          _buildSkinGrid(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinGrid(BuildContext context) {
    final List<Map<String, dynamic>> coinPackages = [
      {'coins': 5, 'price': '₩5,000', 'bonus': '보너스 1개'},
      {'coins': 10, 'price': '₩10,000', 'bonus': '보너스 2개'},
      {'coins': 50, 'price': '₩50,000', 'bonus': '보너스 15개'},
      {'coins': 100, 'price': '₩100,000', 'bonus': '보너스 50개'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.82,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: coinPackages.length,
      itemBuilder: (context, index) {
        final pkg = coinPackages[index];
        return GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCoinImage(pkg['coins']),
              const SizedBox(height: 12),
              Text(
                '${pkg['coins']} 코인',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (pkg['bonus'] != null) ...[
                const SizedBox(height: 4),
                Text(
                  pkg['bonus'],
                  style: const TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                const SizedBox(height: 18), // 보너스가 없을 때의 여백 맞춤
              ],
              const Spacer(),
              Text(
                pkg['price'],
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${pkg['coins']} 코인 결제 기능은 준비 중입니다.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('결제', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCoinImage(int amount) {
    if (amount <= 5) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 0, child: _buildCoinCylinder(4, topCoin: true)),
          ],
        ),
      );
    } else if (amount <= 10) {
      return SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 0, left: 0, child: _buildCoinCylinder(4, topCoin: true)),
            Positioned(bottom: 0, right: 0, child: _buildCoinCylinder(6, topCoin: true)),
          ],
        ),
      );
    } else if (amount <= 50) {
      return SizedBox(
        height: 60,
        width: 70,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 5, left: 0, child: _buildCoinCylinder(6, topCoin: false)),
            Positioned(bottom: 5, right: 0, child: _buildCoinCylinder(8, topCoin: true)),
            Positioned(bottom: 0, left: 20, child: _buildCoinCylinder(5, topCoin: true)),
          ],
        ),
      );
    } else {
      // 100 coins
      return SizedBox(
        height: 60,
        width: 80,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(bottom: 10, left: 5, child: _buildCoinCylinder(8, topCoin: false)),
            Positioned(bottom: 10, right: 5, child: _buildCoinCylinder(10, topCoin: true)),
            Positioned(bottom: 5, left: 25, child: _buildCoinCylinder(12, topCoin: true)),
            Positioned(bottom: 0, left: 0, child: _buildCoinCylinder(6, topCoin: true)),
            Positioned(bottom: 0, right: 0, child: _buildCoinCylinder(5, topCoin: true)),
          ],
        ),
      );
    }
  }

  Widget _buildCoinCylinder(int count, {bool topCoin = false}) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: 26,
          height: (count * 4.0) + 8,
          child: Stack(
            children: List.generate(count, (index) {
              return Positioned(
                bottom: index * 4.0,
                left: 0,
                right: 0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber.shade900, width: 1),
                  ),
                ),
              );
            }),
          ),
        ),
        if (topCoin)
          Positioned(
            bottom: (count * 4.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 2, spreadRadius: -1)],
              ),
              child: const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
            ),
          ),
      ],
    );
  }

  Widget _buildSkinGrid(BuildContext context) {
    final List<Map<String, dynamic>> skinPackages = [
      {'name': '원조 클래식 덱', 'price': '보유중', 'color': Colors.blueGrey},
      {'name': '황금 태양 덱', 'price': '100 코인', 'color': Colors.amber},
      {'name': '칠흑의 심연 덱', 'price': '150 코인', 'color': Colors.deepPurple},
      {'name': '봄의 정령 덱', 'price': '120 코인', 'color': Colors.lightGreen},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: skinPackages.length,
      itemBuilder: (context, index) {
        final skin = skinPackages[index];
        return GlassContainer(
          padding: const EdgeInsets.all(12),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: skin['color'].withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: skin['color'], width: 2),
                  ),
                  child: Center(
                    child: Icon(Icons.style, color: skin['color'], size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                skin['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${skin['name']} 구매/적용 기능은 준비 중입니다.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: skin['price'] == '보유중' ? Colors.white24 : Colors.amber.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(skin['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }
}
