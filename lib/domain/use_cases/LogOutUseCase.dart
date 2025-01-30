

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../repositories/AuthRepository.dart';

class LogOutUseCase {
  final AuthRepository authRepository; // = getIt<AuthRepository>();

  LogOutUseCase(this.authRepository);

  Future<Either<Failure, bool>> call() async{
    return await authRepository.logout();
  }
}