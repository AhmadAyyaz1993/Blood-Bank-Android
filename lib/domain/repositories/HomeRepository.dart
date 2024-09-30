import 'package:dartz/dartz.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<SignUpEntity>>> fetchDonorsList(String? email);
}