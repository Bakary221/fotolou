import 'package:fotolou/core/errors/error_mapper.dart';
import 'package:fotolou/core/utils/result.dart';

Future<Result<T>> guardResult<T>(Future<T> Function() action) async {
  try {
    return ResultSuccess<T>(await action());
  } on Object catch (error) {
    return ResultFailure<T>(mapExceptionToFailure(error));
  }
}
