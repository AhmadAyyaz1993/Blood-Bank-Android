import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/util/validator.dart';
import '../../domain/entities/SignUpEntity.dart';
import '../../domain/repositories/FetchProfileRepository.dart';
import '../../domain/repositories/HomeRepository.dart';

class FetchProfileRepositoryImpl implements FetchProfileRepository {

  final NetworkInfo networkInfo;
  final FirebaseFirestore store;


  FetchProfileRepositoryImpl(this.networkInfo, this.store);

  @override
  Future<Either<Failure, SignUpEntity>> fetchUserDetails(String? email) async {
    if(await networkInfo.isConnected){
      try {
        // Step 1: Fetch the user with the provided email to get their country
        QuerySnapshot emailSnapshot = await store
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        return Right(SignUpEntity.fromMap(emailSnapshot.docs.first.data() as Map<String, dynamic>));

      } catch (e) {
        // Return a Failure in case of Firestore fetch error
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserData(SignUpEntity signUp) async {
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
        String documentId = signUp.email; // Define your custom ID
        await store.collection('users').doc(documentId).set(signUp.toMap());
        return Right(true) ;
      }on Exception catch (e) {
        return Left(ServerFailure());
      }
    }
  }
}