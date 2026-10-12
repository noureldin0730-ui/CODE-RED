import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/patients_data.dart';
import '../data/save_manager.dart';
import 'result_screen.dart';

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

class PatientScreen extends StatefulWidget {
  final int patientId;
  const PatientScreen({super.key, required this.patientId});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late Patient _patient;
  int _attemptsLeft = 3;
  int _wrongAnswers = 0;

  @override
  void initState() {
    super.initState();
    _patient = kPatients.firstWhere((p) => p.id == widget.patientId);
  }

  void _wrongChoice() {
    HapticFeedback.heavyImpact();
    setState(() {
      _attemptsLeft--;
      _wrongAnswers++;
    });
    if (_attemptsLeft <= 0) {
      _showGameOver();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'غلط. باقي $_attemptsLeft محاولات',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: P.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: P.card,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: P.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        title: const Text(
          'GAME OVER',
          style: TextStyle(
            color: P.red,
            letterSpacing: 6,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const Text(
          'خلصت المحاولات. رجّع اقرأ الملف تاني.',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: P.white, height: 1.8),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'للخريطة',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: P.dim),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _attemptsLeft = 3;
                _wrongAnswers = 0;
              });
            },
            child: const Text(
              'من جديد',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: P.red),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════ الأولوية ═══════
  Future<void> _checkPriority(String choice) async {
    if (choice == _patient.correctPriority) {
      HapticFeedback.mediumImpact();
      await _finish();
    } else {
      _wrongChoice();
    }
  }

  // ═══════ التشخيص ═══════
  Future<void> _checkDiagnosis(String choice) async {
    if (choice == _patient.correctDiagnosis) {
      HapticFeedback.mediumImpact();
      await _finish();
    } else {
      _wrongChoice();
    }
  }

  // ═══════ العلاج ═══════
  Future<void> _checkTreatment(String choice) async {
    if (choice == _patient.correctTreatment) {
      HapticFeedback.mediumImpact();
      await _finish();
    } else {
      _wrongChoice();
    }
  }

  Future<void> _finish() async {
    int stars;
    if (_wrongAnswers == 0) {
      stars = 3;
    } else if (_wrongAnswers <= 2) {
      stars = 2;
    } else {
      stars = 1;
    }
    await SaveManager.setStars(_patient.id, stars);
    if (_patient.id < kPatients.length) {
      await SaveManager.unlock(_patient.id + 1);
      await SaveManager.setCurrentPatient(_patient.id + 1);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(patient: _patient, stars: stars),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ────── الشريط العلوي ──────
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: P.card,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: P.dim,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: P.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'CASE ${_patient.id}',
                      style: const TextStyle(
                        color: P.white,
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _patient.name,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: P.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'محاولات: $_attemptsLeft',
                    style: TextStyle(
                      color: _attemptsLeft <= 1 ? P.red : P.dim,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ────── المحتوى: 3 أعمدة ──────
            Expanded(
              child: Row(
                children: [
                  // ────── العمود 1: الأعراض ──────
                  Expanded(
                    child: _ColumnPanel(
                      title: 'الأعراض',
                      children: _patient.symptoms
                          .map((s) => _BulletLine(text: s, color: P.red))
                          .toList(),
                    ),
                  ),
                  // ────── العمود 2: العلامات + الفحوصات ──────
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _ColumnPanel(
                            title: 'العلامات الحيوية',
                            children: _patient.vitals
                                .map(
                                  (s) => _BulletLine(
                                    text: s,
                                    color: P.yellow,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: _ColumnPanel(
                            title: 'الفحوصات',
                            children: _patient.tests
                                .map(
                                  (s) => _BulletLine(
                                    text: s,
                                    color: P.blue,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ────── العمود 3: القرارات ──────
                  Expanded(
                    flex: 2,
                    child: _DecisionPanel(
                      patient: _patient,
                      onPriority: _checkPriority,
                      onDiagnosis: _checkDiagnosis,
                      onTreatment: _checkTreatment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════ لوحة عمودية ═══════════════
class _ColumnPanel extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _ColumnPanel({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: P.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: P.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: P.white,
              fontSize: 13,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF1E2A36), height: 1),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════ سطر نقطة ═══════════════
class _BulletLine extends StatelessWidget {
  final String text;
  final Color color;
  const _BulletLine({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: P.white,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════ لوحة القرارات ═══════════════
class _DecisionPanel extends StatefulWidget {
  final Patient patient;
  final void Function(String) onPriority;
  final void Function(String) onDiagnosis;
  final void Function(String) onTreatment;

  const _DecisionPanel({
    required this.patient,
    required this.onPriority,
    required this.onDiagnosis,
    required this.onTreatment,
  });

  @override
  State<_DecisionPanel> createState() => _DecisionPanelState();
}

class _DecisionPanelState extends State<_DecisionPanel> {
  int _step = 0; // 0 = priority, 1 = diagnosis, 2 = treatment

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: P.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: P.red.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services, color: P.red, size: 16),
              const SizedBox(width: 8),
              Text(
                _step == 0
                    ? 'الخطوة 1: الأولوية'
                    : _step == 1
                        ? 'الخطوة 2: التشخيص'
                        : 'الخطوة 3: العلاج',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: P.white,
                  fontSize: 13,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF1E2A36), height: 1),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _buildOptions(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOptions() {
    if (_step == 0) {
      return widget.patient.priorityOptions
          .map((o) => _optionButton(o, () {
                widget.onPriority(o);
                // لو صح، الاتنين هيمشوا للخطوة اللي بعدها
                if (o == widget.patient.correctPriority) {
                  setState(() => _step = 1);
                }
              }))
          .toList();
    }
    if (_step == 1) {
      return widget.patient.diagnosisOptions
          .map((o) => _optionButton(o, () {
                widget.onDiagnosis(o);
                if (o == widget.patient.correctDiagnosis) {
                  setState(() => _step = 2);
                }
              }))
          .toList();
    }
    return widget.patient.treatmentOptions
        .map((o) => _optionButton(o, () {
              widget.onTreatment(o);
            }))
        .toList();
  }

  Widget _optionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: P.bg,
          border: Border.all(color: P.red.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: P.white,
            fontSize: 13,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}