class TranslationModel {
  final bool status;
  final String message;
  final String data;

  TranslationModel({required this.status, required this.message, required this.data});

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? '',
    );
  }
}
