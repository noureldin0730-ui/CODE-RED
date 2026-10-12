import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/patients_data.dart';

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

class ResultScreen extends StatefulWidget {
  final Patient patient;
  final int stars;

  const ResultScreen({
    super.key,
    required this.patient,
    required this.stars,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _back() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _ctrl,
          child: Row(
            children: [
              // ────── العمود الأيسر: النتيجة ──────
              Expanded(
                flex: 2,
                child: Container(
                  color: P.card,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: P.green,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          'PATIENT STABLE',
                          style: TextStyle(
                            color: P.white,
                            fontSize: 12,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'المريض استقر',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: P.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.patient.name,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: P.dim,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: List.generate(3, (i) {
                          final filled = i < widget.stars;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(
                              filled ? Icons.star : Icons.star_border,
                              color: filled ? P.yellow : P.dim,
                              size: 42,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: _back,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: P.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'المريض التالي',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: P.white,
                              fontSize: 15,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ────── العمود الأيمن: القرار الصح ──────
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: P.green,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'القرار الصح',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: P.green,
                              fontSize: 18,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: Color(0xFF1E2A36), height: 1),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _answerLine(
                                'الأولوية',
                                widget.patient.correctPriority,
                                P.red,
                              ),
                              const SizedBox(height: 14),
                              _answerLine(
                                'التشخيص',
                                widget.patient.correctDiagnosis,
                                P.yellow,
                              ),
                              const SizedBox(height: 14),
                              _answerLine(
                                'العلاج',
                                widget.patient.correctTreatment,
                                P.blue,
                              ),
                              const SizedBox(height: 24),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: P.card,
                                  border: Border.all(
                                    color: P.green.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'النتيجة:',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        color: P.green,
                                        fontSize: 13,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.patient.outcome,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        color: P.white,
                                        fontSize: 13,
                                        height: 1.9,
                                      ),
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerLine(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: P.white,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}