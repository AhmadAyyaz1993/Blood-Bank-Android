import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import 'package:BloodBank/domain/repositories/AuthRepository.dart';

class SignUpUseCase {
  final AuthRepository authRepository; // = getIt<AuthRepository>();

  SignUpUseCase(this.authRepository);

  Future<Either<Failure, UserCredential>> call(SignUpEntity signUpEntity) async{
    return await authRepository.signUp(signUpEntity);
  }
}