class PhoneOtpRequestDto {
  const PhoneOtpRequestDto({required this.phone});

  final String phone;

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }
}
