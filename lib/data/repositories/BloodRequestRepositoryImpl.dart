import 'dart:ffi';

import 'package:BloodBank/domain/entities/BloodRequestEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BloodBank/core/error/exceptions.dart';
import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/core/network/network_info.dart';
import 'package:BloodBank/core/util/validator.dart';
import '../../domain/repositories/BloodRequestRepository.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository{
  final NetworkInfo networkInfo;
  final FirebaseFirestore store;

  BloodRequestRepositoryImpl(this.networkInfo, this.store);


  @override
  Future<Either<Failure, bool>> createBloodRequest(BloodRequestEntity bloodRequestEntity) async {

    if(bloodRequestEntity.patientName.isEmpty){
      return Left(PatientNameValidatorFailure());
    }

    if(bloodRequestEntity.hospitalName.isEmpty){
      return Left(HospitalNameValidatorFailure());
    }

    if(bloodRequestEntity.country.isEmpty){
      return Left(CountryInvalidOrEmptyFailure());
    }

    if(bloodRequestEntity.phoneNumber.isEmpty){
      return Left(PhoneNumberInvalidOrEmptyFailure());
    }

    if ( !await networkInfo.isConnected) {
      return Left(OfflineFailure());
    }else{
      try{

        // Create a new map without password and repeatedPassword
        final bloodRequest = bloodRequestEntity.toMap();
        await store.collection('BloodRequest').doc(bloodRequestEntity.country).collection('requests').add(bloodRequest);
        return Right(true) ;
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
  Future<Either<Failure, List<BloodRequestEntity>>> fetchBloodRequestsList(String? country) async {
    if(await networkInfo.isConnected){
      try {
        QuerySnapshot bloodRequestsSnapShot = await store
            .collection('BloodRequest')
            .doc(country)
            .collection('requests')
            .get();

        List<BloodRequestEntity> bloodRequests = bloodRequestsSnapShot.docs.map((doc) {
          return BloodRequestEntity.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        // Return the list of donors
        return Right(bloodRequests);
      } catch (e) {
        // Return a Failure in case of Firestore fetch error
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }
  }

}