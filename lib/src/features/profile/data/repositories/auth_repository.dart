import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;

  AuthRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<UserModel?> loginUser(String username, String password) async {
    try {
      final QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('usuarios')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      final userData = doc.data() as Map<String, dynamic>;

      if (userData['password'] == password) {
        return UserModel.fromFirebase(doc.id, userData);
      }

      return null;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
