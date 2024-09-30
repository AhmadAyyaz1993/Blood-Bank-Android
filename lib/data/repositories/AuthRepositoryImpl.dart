import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodBank/core/error/exceptions.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/core/network/network_info.dart';
import 'package:BloodBank/core/util/validator.dart';
import 'package:BloodBank/di/injectable_config.dart';
import 'package:BloodBank/domain/entities/SignInEntity.dart';
import 'package:BloodBank/domain/entities/SignUpEntity.dart';
import 'package:BloodBank/domain/repositories/AuthRepository.dart';
import 'package:injectable/injectable.dart';

class AuthRepositoryImpl implements AuthRepository{
  final FirebaseAuth auth;
  final NetworkInfo networkInfo;
  final FirebaseFirestore store;

  AuthRepositoryImpl(this.auth, this.networkInfo, this.store);

  @override
  Future<Either<Failure, UserCredential>> signIn(SignInEntity signInEntity) async {

    if(signInEntity.email.isEmpty || Validator.validateEmail(signInEntity.email) != null){
      return Left(EmailValidatorFailure());
    }

    if(signInEntity.password.isEmpty || Validator.validatePassword(signInEntity.password) != null){
      return Left(PasswordInvalidOrEmptyFailure());
    }

    if(await networkInfo.isConnected){
      try{
        await auth.currentUser?.reload();
        final userCredentials = await auth.signInWithEmailAndPassword(email: signInEntity.email, password: signInEntity.password);
        return Right(userCredentials);
      }on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return Left(NoUserFailure());
        } else if (e.code == 'wrong-password') {
          return Left(WrongPasswordFailure());
        }else{
          return left(ServerFailure());
        }
      }
    }else{
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> signUp(SignUpEntity signUp) async {

    if(signUp.email.isEmpty || Validator.validateEmail(signUp.email) != null){
      return Left(EmailValidatorFailure());
    }

    if(signUp.password.isEmpty || Validator.validatePassword(signUp.password) != null){
      return Left(PasswordInvalidOrEmptyFailure());
    }

    if(signUp.name.isEmpty){
      return Left(NameInvalidOrEmptyFailure());
    }

    if(signUp.country.isEmpty){
      return Left(CountryInvalidOrEmptyFailure());
    }

    if(signUp.phoneNumber.isEmpty){
      return Left(PhoneNumberInvalidOrEmptyFailure());
    }

    if ( !await networkInfo.isConnected) {
      return Left(OfflineFailure());
    }else if (signUp.password != signUp.repeatedPassword){
      return Left(UnmatchedPassFailure());
    }else{
      try{
        await  auth.currentUser?.reload();
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: signUp.email,
          password: signUp.password,
        );
        String documentId = signUp.email; // Define your custom ID
        await store.collection('users').doc(documentId).set(signUp.toMap());
        return Right(userCredential) ;
      }on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return Left(WeekPassFailure());
        } else if (e.code == 'email-already-in-use') {
          return Left(ExistedAccountFailure());
        }else{
          return Left(ServerFailure());
        }
      }
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async{
    try{
      await  auth.currentUser?.reload();
      final User? user = auth.currentUser;
      return Right(user);
    }catch(e){
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try{
      await auth.signOut();
      return Right(true);
    }catch(e){
      return Left(ServerFailure());
    }
  }

}