import 'package:flutter/material.dart';
import '../services/audio_service.dart';
import 'glass_container.dart'; // We have GlassContainer from before

class AnimatedVolumeControl extends StatefulWidget {
  const AnimatedVolumeControl({super.key});

  @override
  State<AnimatedVolumeControl> createState() => _AnimatedVolumeControlState();
}

class _AnimatedVolumeControlState extends State<AnimatedVolumeControl> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isMuted = AudioService().isMuted;
    final double volume = AudioService().volume;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 48,
        width: _isHovered ? 160 : 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_isHovered)
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                    activeTrackColor: Colors.amberAccent,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.amberAccent,
                  ),
                  child: Slider(
                    value: isMuted ? 0.0 : volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (val) {
                      setState(() {
                        if (isMuted && val > 0) {
                          AudioService().toggleMute(); // Unmute if dragging up
                        }
                        AudioService().setVolume(val);
                      });
                    },
                  ),
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  AudioService().toggleMute();
                });
              },
              child: Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Icon(
                  isMuted || volume == 0
                      ? Icons.volume_off
                      : (volume > 0.5 ? Icons.volume_up : Icons.volume_down),
                  color: Colors.amberAccent,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
