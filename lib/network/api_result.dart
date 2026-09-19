class ApiResult<T> {
  bool get isSuccess => this is SuccessApiResult;

  bool get isError => this is FailureApiResult;

  String get errorMessage => (this as FailureApiResult).error.message;

  T? getData() => (this as SuccessApiResult).data;
}

class SuccessApiResult<T> extends ApiResult<T> {
  T? data;

  SuccessApiResult({this.data});
}

class FailureApiResult<T> extends ApiResult<T> {
  Errors error;

  FailureApiResult(this.error);
}

class Errors {
  String message;

  Errors(this.message);
}

class NetworkError extends Errors {
  NetworkError()
      : super("Network error, Please check your internet connection");
}

class ServerError extends Errors {
  ServerError({String? message = "Something went wrong please try again later"})
      : super(message ?? "Something went wrong please try again later");
}