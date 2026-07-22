import '../../domain/entities/athlete.dart';

class AthleteModel extends Athlete {
  AthleteModel({
    required String id,
    required String names,
    required String classification,
    required String category,
    required String weight,
    required String gender,
    required String academy,
  }) : super(
    id: id,
    names: names,
    classification: classification,
    category: category,
    weight: weight,
    gender: gender,
    academy: academy,
  );

  factory AthleteModel.fromMap(String id, Map<String, dynamic> map) {
    return AthleteModel(
      id: id,
      names: map['nombre'] ?? '',
      classification: map['classification'] ?? '',
      category: map['category'] ?? '',
      weight: map['weight'] ?? '',
      gender: map['gender'] ?? '',
      academy: map['academyId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': names,
      'classification': classification,
      'category': category,
      'weight': weight,
      'gender': gender,
      'academyId': academy,
    };
  }
}
