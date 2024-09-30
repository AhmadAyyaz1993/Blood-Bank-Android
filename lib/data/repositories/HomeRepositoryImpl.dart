import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/SignUpEntity.dart';
import '../../domain/repositories/HomeRepository.dart';

class HomeRepositoryImpl implements HomeRepository {

  final NetworkInfo networkInfo;
  final FirebaseFirestore store;


  HomeRepositoryImpl(this.networkInfo, this.store);


  @override
  Future<Either<Failure, List<SignUpEntity>>> fetchDonorsList(String? email) async {
    if(await networkInfo.isConnected){
      try {
        // Step 1: Fetch the user with the provided email to get their country
        QuerySnapshot emailSnapshot = await store
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (emailSnapshot.docs.isNotEmpty) {
          // Assuming the first document is the matching user
          var userData = emailSnapshot.docs.first.data() as Map<String, dynamic>;
          String userCountry = userData['country'];

          // Step 2: Fetch donors from the same country
          QuerySnapshot donorsSnapshot = await store
              .collection('users')
              .where('country', isEqualTo: userCountry)
              .get();

          // Map the data to a list of SignUpEntity objects
          List<SignUpEntity> donors = donorsSnapshot.docs.map((doc) {
            return SignUpEntity.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          // Return the list of donors
          return Right(donors);
        } else {
          // If no user found with the provided email
          return Left(ServerFailure());
        }
      } catch (e) {
        // Return a Failure in case of Firestore fetch error
        return Left(ServerFailure());
      }
    }else{
      return Left(OfflineFailure());
    }
  }
}