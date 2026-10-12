import 'package:shared_preferences/shared_preferences.dart';

class SaveManager {
  static Future<Map<int, int>> getStars() async {
    final p = await SharedPreferences.getInstance();
    final map = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      map[i] = p.getInt('stars_$i') ?? 0;
    }
    return map;
  }

  static Future<void> setStars(int patientId, int stars) async {
    final p = await SharedPreferences.getInstance();
    final current = p.getInt('stars_$patientId') ?? 0;
    if (stars > current) {
      await p.setInt('stars_$patientId', stars);
    }
  }

  static Future<bool> isUnlocked(int patientId) async {
    if (patientId == 1) return true;
    final p = await SharedPreferences.getInstance();
    return p.getBool('unlocked_$patientId') ?? false;
  }

  static Future<void> unlock(int patientId) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('unlocked_$patientId', true);
  }

  static Future<int> getCurrentPatient() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt('current_patient') ?? 1;
  }

  static Future<void> setCurrentPatient(int patientId) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('current_patient', patientId);
  }

  static Future<int> getTotalStars() async {
    final stars = await getStars();
    return stars.values.fold<int>(0, (a, b) => a + b);
  }

  static Future<void> resetAll() async {
    final p = await SharedPreferences.getInstance();
    for (int i = 1; i <= 5; i++) {
      await p.remove('stars_$i');
      await p.remove('unlocked_$i');
    }
    await p.remove('current_patient');
  }
}