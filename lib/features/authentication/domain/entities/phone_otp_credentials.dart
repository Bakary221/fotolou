import 'package:equatable/equatable.dart';

class PhoneOtpCredentials extends Equatable {
  const PhoneOtpCredentials({required this.phone, required this.otp});

  final String phone;
  final String otp;

  @override
  List<Object?> get props => [phone, otp];
}
