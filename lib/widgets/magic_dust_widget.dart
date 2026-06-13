import 'package:flutter/material.dart';
import '../services/economy_service.dart';

class MagicDustWidget extends StatefulWidget {
  const MagicDustWidget({super.key});

  @override
  State<MagicDustWidget> createState() => _MagicDustWidgetState();
}

class _MagicDustWidgetState extends State<MagicDustWidget> {
  final EconomyService _economyService = EconomyService();

  @override
  void initState() {
    super.initState();
    _economyService.addListener(_onEconomyChanged);
  }

  @override
  void dispose() {
    _economyService.removeListener(_onEconomyChanged);
    super.dispose();
  }

  void _onEconomyChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.blur_on, color: Colors.purpleAccent, size: 20),
          const SizedBox(width: 4),
          Text(
            '${_economyService.magicDust}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
