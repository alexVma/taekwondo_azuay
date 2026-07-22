import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/athlete_model.dart';

class AthleteFirestoreDatasource {
  final FirebaseFirestore _firestore;

  AthleteFirestoreDatasource(this._firestore);

  Future<List<AthleteModel>> getAllAthletes() async {
    try {
      final snapshot = await _firestore.collection('deportistas').get();
      return snapshot.docs
          .map((doc) => AthleteModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting athletes: $e');
    }
  }

  Future<bool> createAthlete(AthleteModel athlete) async {
    try {
      await _firestore
          .collection('deportistas')
          .doc(athlete.id)
          .set(athlete.toMap());
      return true;
    } catch (e) {
      throw Exception('Error creating athlete: $e');
    }
  }

  Future<bool> updateAthlete(AthleteModel athlete) async {
    try {
      await _firestore
          .collection('deportistas')
          .doc(athlete.id)
          .update(athlete.toMap());
      return true;
    } catch (e) {
      throw Exception('Error updating athlete: $e');
    }
  }

  Future<void> deleteAthlete(String id) async {
    try {
      await _firestore.collection('deportistas').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting athlete: $e');
    }
  }

  Future<List<String>> getClassifications() async {
    try {
      final snapshot = await _firestore.collection('grupos').get();
      return snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    } catch (e) {
      throw Exception('Error getting classifications: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categorias').get();
      return snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    } catch (e) {
      throw Exception('Error getting categories: $e');
    }
  }

  Future<List<String>> getWeights() async {
    try {
      final snapshot = await _firestore.collection('pesos').get();
      return snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    } catch (e) {
      throw Exception('Error getting weights: $e');
    }
  }

  Future<List<String>> getGenders() async {
    try {
      final snapshot = await _firestore.collection('generos').get();
      return snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    } catch (e) {
      throw Exception('Error getting genders: $e');
    }
  }

  Future<Map<String, String>> getAcademies() async {
    try {
      final snapshot = await _firestore.collection('academies').get();
      final Map<String, String> academies = {};
      for (var doc in snapshot.docs) {
        academies[doc.id] = doc['name'] as String;
      }
      return academies;
    } catch (e) {
      throw Exception('Error getting academies: $e');
    }
  }

  Future<Map<String, String>> getAcademyNames() async {
    try {
      final snapshot = await _firestore.collection('academies').get();
      final Map<String, String> academyNames = {};
      for (var doc in snapshot.docs) {
        academyNames[doc['name'] as String] = doc.id;
      }
      return academyNames;
    } catch (e) {
      throw Exception('Error getting academy names: $e');
    }
  }
}
