enum CompetitionLevel {
  universidad('UNIVERSIDAD'),
  colegios('COLEGIOS'),
  escuelas('ESCUELAS'),
  cantones('CANTONES'),
  clubs('CLUBS'),
  provincias('PROVINCIAS'),
  paises('PAISES');

  final String displayName;
  const CompetitionLevel(this.displayName);
}
