class AppExceptions implements Exception {

  final String? _prefix, _message;

  AppExceptions([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix: $_message";
  }

}

class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, "No Internet Connection");
}

class ServerTimeOut extends AppExceptions {
  ServerTimeOut([String? message]) : super(message, "Server Time Out");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, "Got Bad Request");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message]) : super(message, "Invalid input Exception");
}

class UnAuthorizedException extends AppExceptions {
  UnAuthorizedException([String? message]) : super(message, "UnAuthorized Exception");
}