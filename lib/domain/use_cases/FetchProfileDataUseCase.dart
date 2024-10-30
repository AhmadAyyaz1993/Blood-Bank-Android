import 'package:BloodBank/domain/repositories/FetchProfileRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/failures.dart';
import '../entities/SignUpEntity.dart';

class FetchProfileDataUseCase {
  final FetchProfileRepository fetchProfileRepository; // = getIt<AuthRepository>();

  FetchProfileDataUseCase(this.fetchProfileRepository);

  Future<Either<Failure, SignUpEntity>> call(String email) async{
    return await fetchProfileRepository.fetchUserDetails(email);
  }
}