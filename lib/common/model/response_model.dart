class Response {
  final ResponseType type;
  final Object? data;
  Response({required this.type, required this.data});
}

enum ResponseType {success, failure}