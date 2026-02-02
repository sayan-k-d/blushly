import 'dart:async';
import 'dart:math';
import 'package:blushly/core/widgets/main_shell.dart';
import 'package:blushly/screens/dashboard/dashboard_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_balloons/flutter_balloons.dart';

class BirthdaySplash extends StatefulWidget {
  const BirthdaySplash({super.key});

  @override
  State<BirthdaySplash> createState() => _BirthdaySplashState();
}

class _BirthdaySplashState extends State<BirthdaySplash> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 3));
    _controller.play();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final List<Color> _basePartyColors = [
      // Color(0xFFFF0033), // Crimson Red (celebration)
      Color(0xFFFF6D00), // Sunset Orange
      // Color(0xFFFFD600), // Golden Yellow
      // Color(0xFF00E676), // Neon Green
      // Color(0xFF1DE9B6), // Aqua Mint
      // Color(0xFF2979FF), // Royal Blue
      Color(0xFFDDFF00), // Deep Purple
      Color(0xFF00F9BF), // Party Magenta
      Color(0xFFFF4081), // Candy Pink
      // Color(0xFF76FF03), // Lime Pop
      Color(0xFFFFC107), // Champagne Gold (premium touch)
      Color(0xFFC4C4C4),
    ];
    final List<Color> premiumBalloonColors = List.generate(12, (_) {
      final base = _basePartyColors[random.nextInt(_basePartyColors.length)];
      final opacity = 0.7 + random.nextDouble() * 0.25;
      return base.withValues(alpha: opacity);
    });

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: -pi / 4,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                shouldLoop: false,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: -3 * pi / 4,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                shouldLoop: false,
              ),
            ),
            BalloonOverlay(
              spawnInterval: const Duration(milliseconds: 500),
              colors: premiumBalloonColors,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Column(
                  children: [
                    Text(
                      "🎉 Happy Birthday 🎉",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "✨ Shibangi ✨",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("May your sales shine even brighter ✨"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
