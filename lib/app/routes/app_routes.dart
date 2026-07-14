enum AppRoute {
  splash('/splash'),
  onboarding('/onboarding'),
  phoneLogin('/phone-login'),
  otp('/otp'),
  clientHome('/client'),
  clientTickets('/client/tickets'),
  clientProfile('/client/profile'),
  clientSalonDetail('/client/salon'),
  barberHome('/barber'),
  home('/'),
  login('/login');

  const AppRoute(this.path);

  final String path;
}
