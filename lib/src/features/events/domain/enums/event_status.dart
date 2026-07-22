enum EventStatus {
  activo('ACTIVO'),
  suspendido('SUSPENDIDO'),
  cerrado('CERRADO');

  final String displayName;
  const EventStatus(this.displayName);
}
