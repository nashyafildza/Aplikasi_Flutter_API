import 'package:flutter/material.dart';
import 'models/jadwal_sholat.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Sholat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: JadwalSholatPage(),
    );
  }
}

class JadwalSholatPage extends StatefulWidget {
  const JadwalSholatPage({super.key});

  @override
  _JadwalSholatPageState createState() => _JadwalSholatPageState();
}

class _JadwalSholatPageState extends State<JadwalSholatPage> {
  late Future<List<JadwalSholat>> futureJadwal;
  late Future<List<String>> futureKota;
  String? selectedKota;

  @override
  void initState() {
    super.initState();
    futureKota = ApiService().fetchKota();
    selectedKota = 'semarang'; // Default kota
    fetchJadwal();
  }

  void fetchJadwal() {
    if (selectedKota != null && selectedKota!.isNotEmpty) {
      futureJadwal = ApiService().fetchJadwalSholat(selectedKota!);
    } else {
      print("selectedKota is null or empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Sholat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: futureKota,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                }

                final kotaList = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Kota',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedKota,
                          hint: const Text('Pilih Kota'),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedKota = newValue;
                              fetchJadwal();
                            });
                          },
                          items: kotaList
                              .map<DropdownMenuItem<String>>((String kota) {
                            return DropdownMenuItem<String>(
                              value: kota,
                              child: Text(kota),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<JadwalSholat>>(
                future: futureJadwal,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  final jadwalList = snapshot.data!;
                  return _buildScrollableJadwalTable(jadwalList);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableJadwalTable(List<JadwalSholat> jadwalList) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Tanggal')),
              DataColumn(label: Text('Imsyak')),
              DataColumn(label: Text('Shubuh')),
              DataColumn(label: Text('Terbit')),
              DataColumn(label: Text('Dzuhur')),
              DataColumn(label: Text('Ashr')),
              DataColumn(label: Text('Magrib')),
              DataColumn(label: Text('Isya')),
            ],
            rows: jadwalList.map((jadwal) {
              return DataRow(
                cells: [
                  DataCell(Text(jadwal.tanggal)),
                  DataCell(Text(jadwal.imsyak)),
                  DataCell(Text(jadwal.shubuh)),
                  DataCell(Text(jadwal.terbit)),
                  DataCell(Text(jadwal.dzuhur)),
                  DataCell(Text(jadwal.ashr)),
                  DataCell(Text(jadwal.magrib)),
                  DataCell(Text(jadwal.isya)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
