class Translation {
  final String id;
  final String bahasaBima;
  final String bahasaIndonesia;
  final String bahasaInggris;

  Translation({required this.id, required this.bahasaBima, required this.bahasaIndonesia, required this.bahasaInggris});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      bahasaBima: json['bahasa_bima'],
      bahasaIndonesia: json['bahasa_indonesia'],
      bahasaInggris: json['bahasa_inggris'],
    );
  }
}
