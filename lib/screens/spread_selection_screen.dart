import 'package:flutter/material.dart';
import 'package:flutter_tarot/l10n/app_localizations.dart';
import '../data/spread_type.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_container.dart';
import 'reading_screen.dart';

class SpreadSelectionScreen extends StatelessWidget {
  final bool showBackButton;
  const SpreadSelectionScreen({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    // Scaffold without AppBar so it blends nicely as a tab, or with a simple title.
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.spreadSelectionTitle,
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (showBackButton) const SizedBox(width: 48), // Balance for centering
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.spreadSelectionSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadOneCardName,
                        description: AppLocalizations.of(context)!.spreadOneCardDesc,
                        icon: Icons.filter_1,
                        type: SpreadType.oneCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadTwoCardName,
                        description: AppLocalizations.of(context)!.spreadTwoCardDesc,
                        icon: Icons.filter_2,
                        type: SpreadType.twoCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadThreeCardName,
                        description: AppLocalizations.of(context)!.spreadThreeCardDesc,
                        icon: Icons.filter_3,
                        type: SpreadType.threeCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadFourCardName,
                        description: AppLocalizations.of(context)!.spreadFourCardDesc,
                        icon: Icons.filter_4,
                        type: SpreadType.fourCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadFiveCardName,
                        description: AppLocalizations.of(context)!.spreadFiveCardDesc,
                        icon: Icons.filter_5,
                        type: SpreadType.fiveCard,
                      ),
                      const SizedBox(height: 16),
                      _buildSpreadCard(
                        context,
                        title: AppLocalizations.of(context)!.spreadCelticCrossName,
                        description: AppLocalizations.of(context)!.spreadCelticCrossDesc,
                        icon: Icons.grid_view,
                        type: SpreadType.celticCross,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpreadCard(BuildContext context, {required String title, required String description, required IconData icon, required SpreadType type}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadingScreen(spreadType: type),
          ),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.amberAccent, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
