import 'package:dartz/dartz.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import 'package:BloodBank/domain/repositories/HomeRepository.dart';

import '../../core/error/failures.dart';

class FetchDonorsUseCase {
  final HomeRepository homeRepository;

  FetchDonorsUseCase(this.homeRepository);

  Future<Either<Failure, List<SignUpEntity>>> call(String? email) async {
    return await homeRepository.fetchDonorsList(email);
  }
}