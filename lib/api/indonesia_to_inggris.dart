class TranslationModel {
  final String word;
  final String sourceLanguage;
  final String targetLanguage;

  TranslationModel({required this.word, required this.sourceLanguage, required this.targetLanguage});

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      word: json['word'] ?? '',
      sourceLanguage: json['source_language'] ?? '',
      targetLanguage: json['target_language'] ?? '',
    );
  }
}
