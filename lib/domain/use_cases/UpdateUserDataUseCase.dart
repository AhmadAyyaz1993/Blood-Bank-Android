import 'package:BloodBank/domain/repositories/FetchProfileRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failures.dart';
import '../entities/SignUpEntity.dart';

class UpdateUserDataUseCase {
  final FetchProfileRepository fetchProfileRepository; // = getIt<AuthRepository>();

  UpdateUserDataUseCase(this.fetchProfileRepository);

  Future<Either<Failure, bool>> call(SignUpEntity signUpEntity) async{
    return await fetchProfileRepository.updateUserData(signUpEntity);
  }
}