import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/academy_model.dart';

class AcademyFirestoreDatasource {
  final FirebaseFirestore firestore;

  AcademyFirestoreDatasource(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('academies');

  Future<List<AcademyModel>> getAcademies() async {
    final snapshot = await _collection.get();

    return snapshot.docs
        .map(
          (e) => AcademyModel.fromMap(
        e.data(),
        e.id,
      ),
    )
        .toList();
  }

  Future<void> saveAcademies(
      List<AcademyModel> academies,
      ) async {
    final batch = firestore.batch();

    for (final academy in academies) {
      batch.set(
        _collection.doc(academy.id),
        academy.toMap(),
      );
    }

    await batch.commit();
  }
}