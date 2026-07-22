import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<UserModel>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('usuarios').get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirebase(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<bool> createUser(UserModel user, String password) async {
    try {
      await _firebaseFirestore.collection('usuarios').doc(user.id).set({
        ...user.toFirebase(),
        'password': password,
      });
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await _firebaseFirestore
          .collection('usuarios')
          .doc(user.id)
          .update(user.toFirebase());
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _firebaseFirestore.collection('usuarios').doc(userId).delete();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}
