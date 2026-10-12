import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // قفل الشاشة على الوضع الأفقي (Landscape)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // وضع ملء الشاشة
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const CodeRedApp());
}

class CodeRedApp extends StatelessWidget {
  const CodeRedApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CODE RED',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
      ),
      home: const StartScreen(),
    );
  }
}

// ═══════════ الألوان ═══════════
class P {
  static const bg = Color(0xFF0B0F14);
  static const card = Color(0xFF131A22);
  static const dim = Color(0xFF6B7A8C);
  static const line = Color(0xFF1E2A36);
  static const white = Color(0xFFE8EEF4);
  static const blue = Color(0xFF3D8BCC);
  static const red = Color(0xFFE63946);
  static const yellow = Color(0xFFE9B44C);
  static const green = Color(0xFF4A9B6F);
}

// ═══════════ شاشة البداية — Landscape ═══════════
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _start() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: Row(
          children: [
            // ────── النص على الشمال ──────
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity:
                          Tween<double>(begin: 0.4, end: 1.0).animate(_pulse),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: P.red, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'CODE RED',
                          style: TextStyle(
                            color: P.red,
                            fontSize: 44,
                            letterSpacing: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'كل قرار... حياة أو موت',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: P.dim,
                        fontSize: 16,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _start,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: P.red,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: P.red.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Text(
                          'دخول الطوارئ',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: P.white,
                            fontSize: 18,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ────── أيقونة النبض على اليمين ──────
            Expanded(
              flex: 2,
              child: Center(
                child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.3, end: 1.0).animate(_pulse),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: P.red, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: P.red.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.monitor_heart,
                      color: P.red,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Nour Developer',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: P.dim,
            fontSize: 11,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}