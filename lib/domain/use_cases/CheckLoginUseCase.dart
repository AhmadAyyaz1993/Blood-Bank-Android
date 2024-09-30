import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/domain/repositories/AuthRepository.dart';

class CheckLoginUseCase {
  final AuthRepository authRepository; // = getIt<AuthRepository>();

  CheckLoginUseCase(this.authRepository);

  Future<Either<Failure, User?>> call() async{
    return await authRepository.getCurrentUser();
  }
}