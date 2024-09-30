import 'package:equatable/equatable.dart';

class SignInEntity extends Equatable {
  String email;
  String password;

  SignInEntity({ required this.password, required this.email});

  @override
  List<Object?> get props => [ password, email];
}