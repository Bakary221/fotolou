import 'package:fotolou/core/utils/result.dart';

abstract interface class UseCase<Output, Params> {
  Future<Result<Output>> call(Params params);
}

final class NoParams {
  const NoParams();
}
