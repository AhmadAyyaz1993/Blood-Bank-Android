import 'package:BloodBank/core/error/failures.dart';
import 'package:BloodBank/core/strings/failures.dart';

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}