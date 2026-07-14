enum UserRole {
  client,
  barber;

  String get label {
    return switch (this) {
      UserRole.client => 'Client',
      UserRole.barber => 'Barber',
    };
  }
}
