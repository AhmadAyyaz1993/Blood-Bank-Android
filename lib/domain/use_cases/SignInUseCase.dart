import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/domain/entities/SignInEntity.dart';
import 'package:BloodBank/domain/repositories/AuthRepository.dart';
import 'package:injectable/injectable.dart';

class SignInUseCase {
  final AuthRepository authRepository; // = getIt<AuthRepository>();

  SignInUseCase(this.authRepository);

  Future<Either<Failure, UserCredential>> call(SignInEntity signInEntity) async{
    return await authRepository.signIn(signInEntity);
  }
}