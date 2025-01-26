import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:dartz/dartz.dart';
import 'package:BloodBank/core/error/failures.dart';
import '../repositories/BloodRequestRepository.dart';

class CreateBloodRequestUseCase {
  final BloodRequestRepository bloodRequestRepository; // = getIt<AuthRepository>();

  CreateBloodRequestUseCase(this.bloodRequestRepository);

  Future<Either<Failure, bool>> call(BloodRequestEntity bloodRequestEntity) async{
    return await bloodRequestRepository.createBloodRequest(bloodRequestEntity);
  }
}