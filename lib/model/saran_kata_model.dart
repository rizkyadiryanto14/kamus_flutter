class SaranKataModel {
  final bool status;
  final String message;

  SaranKataModel({required this.status, required this.message});

  factory SaranKataModel.fromJson(Map<String, dynamic> json){
    return SaranKataModel(
      status: json['status'] ?? false,
      message: json['message'] ?? ''
    );
  }
}