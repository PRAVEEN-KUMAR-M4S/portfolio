import 'package:dartz/dartz.dart';

class ApiResult<T> {
  final Either<Exception, T> value;

  ApiResult(this.value);
}
