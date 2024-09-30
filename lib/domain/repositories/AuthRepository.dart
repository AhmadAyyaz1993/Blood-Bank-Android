import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodBank/domain/entities/SignInEntity.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import '../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserCredential>> signIn(SignInEntity signInEntity);
  Future<Either<Failure, UserCredential>> signUp(SignUpEntity signUpEntity);
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, bool>> logout();
}