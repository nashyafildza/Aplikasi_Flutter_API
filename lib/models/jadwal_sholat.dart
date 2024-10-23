class JadwalSholat {
  final String tanggal;
  final String imsyak;
  final String shubuh;
  final String dzuhur;
  final String terbit;
  final String magrib;
  final String isya;
  final String dhuha;
  final String ashr;

  JadwalSholat({
    required this.tanggal,
    required this.imsyak,
    required this.shubuh,
    required this.dzuhur,
    required this.terbit,
    required this.magrib,
    required this.isya,
    required this.dhuha,
    required this.ashr,
  });

  factory JadwalSholat.fromJson(Map<String, dynamic> json) {
    return JadwalSholat(
      tanggal: json['tanggal'],
      imsyak: json['imsyak'],
      shubuh: json['shubuh'],
      dzuhur: json['dzuhur'],
      terbit: json['terbit'],
      magrib: json['magrib'],
      isya: json['isya'],
      dhuha: json['dhuha'],
      ashr: json['ashr'],
    );
  }
}
