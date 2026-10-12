import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/patients_data.dart';
import '../data/save_manager.dart';
import 'patient_screen.dart';

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

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<int, int> _stars = {};
  int _currentPatient = 1;
  int _totalStars = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stars = await SaveManager.getStars();
    final current = await SaveManager.getCurrentPatient();
    final total = await SaveManager.getTotalStars();
    if (!mounted) return;
    setState(() {
      _stars = stars;
      _currentPatient = current;
      _totalStars = total;
      _loading = false;
    });
  }

  Future<void> _openPatient(int id) async {
    final unlocked = await SaveManager.isUnlocked(id);
    if (!unlocked) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'عالج المريض اللي قبله الأول',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: P.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PatientScreen(patientId: id)),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: P.bg,
        body: Center(child: CircularProgressIndicator(color: P.red)),
      );
    }

    return Scaffold(
      backgroundColor: P.bg,
      body: SafeArea(
        child: Row(
          children: [
            // ────── العمود الأيسر: العنوان + النجوم ──────
            Container(
              width: 200,
              color: P.card,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios_new, color: P.dim, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'رجوع',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: P.dim, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: P.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'CODE RED',
                      style: TextStyle(
                        color: P.white,
                        fontSize: 14,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'الطوارئ',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: P.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_totalStars / ${kPatients.length * 3} نجمة',
                    style: const TextStyle(
                      color: P.yellow,
                      fontSize: 13,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'الحالات: ${kPatients.length}',
                    style: const TextStyle(
                      color: P.dim,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            // ────── المنطقة اليمنى: قائمة المرضى ──────
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                itemCount: kPatients.length,
                itemBuilder: (context, index) {
                  final p = kPatients[index];
                  final stars = _stars[p.id] ?? 0;
                  final isCurrent = p.id == _currentPatient;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _PatientCard(
                      patient: p,
                      stars: stars,
                      isCurrent: isCurrent,
                      onTap: () => _openPatient(p.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════ كارت المريض ═══════════════
class _PatientCard extends StatelessWidget {
  final Patient patient;
  final int stars;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PatientCard({
    required this.patient,
    required this.stars,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: P.card,
          border: Border.all(
            color: isCurrent ? P.red : P.line,
            width: isCurrent ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: P.red.withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── رقم الحالة ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent ? P.red : P.line,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'CASE ${patient.id}',
                    style: const TextStyle(
                      color: P.white,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.monitor_heart,
                  color: isCurrent ? P.red : P.dim,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ───── اسم المريض ─────
            Text(
              patient.name,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: P.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${patient.age} سنة • ${patient.gender}',
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: P.dim, fontSize: 12),
            ),
            const SizedBox(height: 14),
            // ───── الأعراض ─────
            const Text(
              'الشكوى:',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: P.blue,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                patient.complaint,
                textDirection: TextDirection.rtl,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: P.white,
                  fontSize: 12,
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // ───── النجوم ─────
            Row(
              children: List.generate(3, (i) {
                final filled = i < stars;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: filled ? P.yellow : P.dim,
                    size: 16,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}