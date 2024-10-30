import 'package:dartz/dartz.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';

abstract class FetchProfileRepository {
  Future<Either<Failure, SignUpEntity>> fetchUserDetails(String? email);
}