import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventFirestoreDatasource {
  final FirebaseFirestore firestore;

  EventFirestoreDatasource(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('eventos');

  Future<List<EventModel>> getAllEvents() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<bool> createEvent(EventModel event) async {
    try {
      await _collection.doc(event.id).set(event.toMap());
      return true;
    } catch (e) {
      print('Error creating event: $e');
      return false;
    }
  }

  Future<bool> updateEvent(EventModel event) async {
    try {
      await _collection.doc(event.id).update(event.toMap());
      return true;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    try {
      await _collection.doc(eventId).delete();
      return true;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }
}
