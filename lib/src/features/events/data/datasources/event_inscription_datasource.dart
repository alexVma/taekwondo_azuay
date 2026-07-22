import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_inscription_model.dart';

class EventInscriptionDatasource {
  final FirebaseFirestore _firestore;
  final String eventId;

  EventInscriptionDatasource(this._firestore, {required this.eventId});

  Future<List<EventInscriptionModel>> getInscriptions() async {
    try {
      final snapshot = await _firestore
          .collection('eventos')
          .doc(eventId)
          .collection('inscripciones')
          .get();
      return snapshot.docs
          .map((doc) => EventInscriptionModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting inscriptions: $e');
    }
  }

  Future<bool> addInscription(EventInscriptionModel inscription) async {
    try {
      await _firestore
          .collection('eventos')
          .doc(eventId)
          .collection('inscripciones')
          .doc(inscription.athleteId)
          .set(inscription.toMap());
      return true;
    } catch (e) {
      throw Exception('Error adding inscription: $e');
    }
  }

  Future<bool> updateInscription(EventInscriptionModel inscription) async {
    try {
      await _firestore
          .collection('eventos')
          .doc(eventId)
          .collection('inscripciones')
          .doc(inscription.athleteId)
          .update(inscription.toMap());
      return true;
    } catch (e) {
      throw Exception('Error updating inscription: $e');
    }
  }

  Future<void> deleteInscription(String athleteId) async {
    try {
      await _firestore
          .collection('eventos')
          .doc(eventId)
          .collection('inscripciones')
          .doc(athleteId)
          .delete();
    } catch (e) {
      throw Exception('Error deleting inscription: $e');
    }
  }
}
