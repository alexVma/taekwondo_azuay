enum UserRole {
  administrador('ADMINISTRADOR'),
  administrativo('ADMINISTRATIVO'),
  arbitro('ARBITRO'),
  club('CLUB'),
  organizadorEventos('ORGANIZADOR EVENTOS');

  final String displayName;
  const UserRole(this.displayName);
}
