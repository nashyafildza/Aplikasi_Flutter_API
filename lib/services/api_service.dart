// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_api/models/jadwal_sholat.dart';

class ApiService {
  Future<List<JadwalSholat>> fetchJadwalSholat(String kota) async {
    final url =
        'https://raw.githubusercontent.com/lakuapik/jadwalsholatorg/master/adzan/$kota/2024/10.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Pastikan respons body adalah List
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .map((data) => JadwalSholat.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load jadwal sholat');
    }
  }

  Future<List<String>> fetchKota() async {
    const url =
        'https://raw.githubusercontent.com/lakuapik/jadwalsholatorg/master/kota.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData
          .cast<String>(); // Mengonversi List<dynamic> ke List<String>
    } else {
      throw Exception('Failed to load kota');
    }
  }
}
