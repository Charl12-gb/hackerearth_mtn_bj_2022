class Base implements Exception{
  final String message;
  final String? httpStatus;
  final String? httpBody;
  final String? jsonBody;
  final String? httpHeaders;
  final String? requestId;

  const Base({
    required this.message,
    this.httpStatus,
    this.httpBody,
    this.jsonBody,
    this.httpHeaders,
    this.requestId,
  });

  @override
  String toString() {
    var id = requestId!=null?" from API request '{$this->requestId}'" : "";
    var message = super.toString().split("\n");
    message[0] = id;
    return message.join("\n");
    }

}