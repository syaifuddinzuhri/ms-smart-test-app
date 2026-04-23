import 'dart:convert';

import 'package:flutter/cupertino.dart';

class CommonHelper {
  /// Format gender dari API
  static String formatGender(String? gender) {
    switch (gender) {
      case 'male':
        return 'Laki-laki';
      case 'female':
        return 'Perempuan';
      default:
        return '-';
    }
  }

  /// Format tempat & tanggal lahir
  static String formatBirth(String? pob, String? dob) {
    if ((pob == null || pob.isEmpty) && (dob == null || dob.isEmpty)) {
      return '-';
    }

    if (pob != null && dob != null) {
      return "$pob, ${formatDate(dob)}";
    }

    if (pob != null) return pob;
    return formatDate(dob!);
  }

  /// Format tanggal (YYYY-MM-DD → 01 Jan 2000)
  static String formatDate(String date) {
    try {
      final d = DateTime.parse(date);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      return "${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}";
    } catch (e) {
      return date; // fallback kalau format aneh
    }
  }

  /// Format kelas + jurusan
  static String formatClassroom(String? className, String? majorName) {
    if (className == null && majorName == null) return '-';

    return "${className ?? ''}${className != null && majorName != null ? ' - ' : ''}${majorName ?? ''}";
  }

  static void printPretty(dynamic data) {
    try {
      final encoder = const JsonEncoder.withIndent('  ');
      final pretty = encoder.convert(data);

      for (var i = 0; i < pretty.length; i += 800) {
        debugPrint(
          pretty.substring(
            i,
            i + 800 > pretty.length ? pretty.length : i + 800,
          ),
        );
      }
    } catch (e) {
      debugPrint(data.toString());
    }
  }
}
