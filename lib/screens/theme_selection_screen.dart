import 'package:flutter/material.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import '../services/theme_manager.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          title: const Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text('테마 설정', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
              child: const TabBar(
                indicatorColor: Colors.amberAccent,
                indicatorWeight: 3.0,
                labelColor: Colors.amberAccent,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.card_giftcard, size: 18),
                        SizedBox(width: 8),
                        Text('무료 테마', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.diamond, size: 18),
                        SizedBox(width: 8),
                        Text('유료 테마', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: GradientBackground(
          child: SafeArea(
            child: ValueListenableBuilder<String>(
            valueListenable: ThemeManager.instance.themeNotifier,
            builder: (context, currentTheme, _) {
              return ValueListenableBuilder<List<String>>(
                valueListenable: ThemeManager.instance.unlockedThemesNotifier,
                builder: (context, unlockedThemes, _) {
                  // Free themes: indices 0 to 3
                  final freeIndices = [0, 1, 2, 3];
                  
                  // Paid themes: index 4 onwards, ONLY IF unlocked
                  final allPaidIndices = List.generate(
                    ThemeManager.instance.availableThemes.length > 4 ? ThemeManager.instance.availableThemes.length - 4 : 0,
                    (i) => i + 4,
                  );
                  
                  final unlockedPaidIndices = allPaidIndices.where((index) {
                    final themePath = ThemeManager.instance.availableThemes[index];
                    return unlockedThemes.contains(themePath);
                  }).toList();
                  
                  return TabBarView(
                    children: [
                      // 무료 테마 탭
                      _buildThemeGrid(freeIndices, currentTheme, context),
                      // 유료 테마 탭
                      unlockedPaidIndices.isEmpty
                          ? const Center(
                              child: Text(
                                '상점에서 테마를 구매하여\n이곳을 채워보세요!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            )
                          : _buildThemeGrid(unlockedPaidIndices, currentTheme, context),
                    ],
                  );
                },
              );
            },
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeGrid(List<int> indices, String currentTheme, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: indices.length,
      itemBuilder: (context, gridIndex) {
        final originalIndex = indices[gridIndex];
        if (originalIndex >= ThemeManager.instance.availableThemes.length) return const SizedBox();
        
        final themePath = ThemeManager.instance.availableThemes[originalIndex];
        final isSelected = themePath == currentTheme;
        final themeName = _getThemeName(originalIndex);

        return GestureDetector(
          onTap: () {
            ThemeManager.instance.setTheme(themePath);
          },
          child: Stack(
            children: [
              GlassContainer(
                padding: const EdgeInsets.all(8),
                borderRadius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          themePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      themeName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.amberAccent : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amberAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _getThemeName(int index) {
    switch (index) {
      case 0:
        return '기본 테마';
      case 1:
        return '테마 1';
      case 2:
        return '테마 2';
      case 3:
        return '테마 3';
      case 4:
        return '마법책';
      case 5:
        return '검은 고양이';
      default:
        return '테마 $index';
    }
  }
}
