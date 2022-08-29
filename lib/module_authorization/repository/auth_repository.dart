import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom_delivery/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom_delivery/module_authorization/requests/login_request.dart';
import 'package:my_kom_delivery/module_authorization/response/login_response.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LoginResponse> signIn(LoginRequest request) async {
    var creds = await _firebaseAuth.signInWithEmailAndPassword(
      email: request.email,
      password: request.password,
    );

    try {
      String token = await creds.user!.getIdToken();
      return LoginResponse(token);
    } catch (e) {
      throw Exception('Error getting the token from the Fire Base API');
    }
  }

  Future<ProfileResponse> getProfile(String uid) async {
    try {
      var existProfile = await _firestore.collection('users').doc(uid).get();
      Map<String  ,dynamic > result = existProfile.data()!;
      print('result');
      print(result);
      return ProfileResponse.fromJson(result);
    } catch (e) {
      throw Exception();
    }
  }


  Future<bool> getNewPassword(String email) async{
    try{
      _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    }catch(e){
      throw e;
    }
  }

 Future<String?> getStore(String storeId) async{
    try{
      return _firestore.collection('stores').doc(storeId).get().then((value) {
        Map<String , dynamic> map =  value.data() as Map<String,dynamic>;
        String name = map['name'];
        return name;
      });
    }catch(e){
      return null;
    }


  }

}
