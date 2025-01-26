import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:BloodBank/domain/repositories/BloodRequestRepository.dart';
import 'package:dartz/dartz.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import '../../core/error/failures.dart';

class FetchBloodRequestsUseCase {
  final BloodRequestRepository bloodRequestRepository;

  FetchBloodRequestsUseCase(this.bloodRequestRepository);

  Future<Either<Failure, List<BloodRequestEntity>>> call(String? country) async {
    return await bloodRequestRepository.fetchBloodRequestsList(country);
  }
}