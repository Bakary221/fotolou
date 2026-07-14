class VerifyOtpRequestDto {
  const VerifyOtpRequestDto({required this.phone, required this.otp});

  final String phone;
  final String otp;

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'otp': otp};
  }
}
