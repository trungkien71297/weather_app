// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomException implements Exception {
  String message;
  CustomException(
    this.message,
  );
  @override
  String toString() {
    return message;
  }
}
