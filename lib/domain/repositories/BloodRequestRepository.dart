import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class BloodRequestRepository {
  Future<Either<Failure, bool>> createBloodRequest(BloodRequestEntity bloodRequestEntity);
  Future<Either<Failure, List<BloodRequestEntity>>> fetchBloodRequestsList(String? country);
}