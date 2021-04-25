class BaseResponse<T> {
  BaseResponse(this.status, this.code, this.message, this.data);

  T data;
  bool status;
  int code;
  String message;

  @override
  String toString() {
    final sb = StringBuffer('{');
    sb.write('\"status\":\"$status\"');
    sb.write(',\"code\":$code');
    sb.write(',\"msg\":\"$message\"');
    sb.write(',\"data\":\"$data\"');
    sb.write('}');
    return sb.toString();
  }
}
