class AuthApiException implements Exception {
  final String message;
  final int statusCode;
  final String code;
  AuthApiException({
    required this.message,
    required this.statusCode,
    required this.code,
  });
}
