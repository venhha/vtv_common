import 'package:dartz/dartz.dart';

import '../../../core/base/base_usecase.dart';
import '../../../core/constants/typedef.dart';
import '../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// params: access token
class CheckTokenUC implements UseCaseHasParams<FResult<String?>, String> {
  final AuthRepository _authRepository;

  /// params: access token
  CheckTokenUC(this._authRepository);

  @override
  FResult<String?> call(String params) async {
    final isExpiredToken = await _authRepository.isExpiredToken(params);

    return isExpiredToken.fold(
      (failure) => Left(failure),
      (isExpired) async {
        if (isExpired) {
          // the token is expired >> call refresh token
          final respEither = await _authRepository.getNewAccessToken();
          return respEither.fold(
            (error) => Left(Failure.fromResp(error)),
            (ok) => Right(ok.data),
          );
        } else {
          // the token is valid
          return const Right(null);
        }
      },
    );
  }
}
