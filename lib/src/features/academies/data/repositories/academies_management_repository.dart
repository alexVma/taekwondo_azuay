import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/academy_model.dart';

class AcademiesManagementRepository {
  final FirebaseFirestore _firebaseFirestore;

  AcademiesManagementRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<AcademyModel>> getAllAcademies() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('academies').get();

      return querySnapshot.docs
          .map((doc) => AcademyModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching academies: $e');
      return [];
    }
  }

  Future<bool> createAcademy(AcademyModel academy) async {
    try {
      await _firebaseFirestore
          .collection('academies')
          .doc(academy.id)
          .set(academy.toMap());
      return true;
    } catch (e) {
      print('Error creating academy: $e');
      return false;
    }
  }

  Future<bool> updateAcademy(AcademyModel academy) async {
    try {
      await _firebaseFirestore
          .collection('academies')
          .doc(academy.id)
          .update(academy.toMap());
      return true;
    } catch (e) {
      print('Error updating academy: $e');
      return false;
    }
  }

  Future<bool> deleteAcademy(String academyId) async {
    try {
      await _firebaseFirestore.collection('academies').doc(academyId).delete();
      return true;
    } catch (e) {
      print('Error deleting academy: $e');
      return false;
    }
  }
}
