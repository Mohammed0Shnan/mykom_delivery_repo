
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom_delivery/module_authorization/enums/auth_source.dart';
import 'package:my_kom_delivery/module_authorization/enums/auth_status.dart';
import 'package:my_kom_delivery/module_authorization/enums/user_role.dart';
import 'package:my_kom_delivery/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom_delivery/module_authorization/model/address_model.dart';
import 'package:my_kom_delivery/module_authorization/model/app_user.dart';
import 'package:my_kom_delivery/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom_delivery/module_authorization/repository/auth_repository.dart';
import 'package:my_kom_delivery/module_authorization/requests/login_request.dart';
import 'package:my_kom_delivery/module_authorization/response/login_response.dart';
import 'package:my_kom_delivery/utils/logger/logger.dart';

class AuthService {
  final AuthRepository _repository = new AuthRepository();

  final AuthPrefsHelper _prefsHelper = AuthPrefsHelper();
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Delegates
  Future<bool> get isLoggedIn => _prefsHelper.isSignedIn();

  Future<String?> get userID => _prefsHelper.getUserId();

  Future<UserRole?> get userRole => _prefsHelper.getRole();

Future<AppUser>  getCurrentUser()async{
    String? id = await _prefsHelper.getUserId();
    String? email = await _prefsHelper.getEmail();
    String? phone_number = await _prefsHelper.getPhone();
    UserRole? userRole = await _prefsHelper.getRole();
    AuthSource? authSource = await _prefsHelper.getAuthSource();
    String? user_name = await _prefsHelper.getUsername();
    AddressModel? address = await _prefsHelper.getAddress();
    String? strip_id = await _prefsHelper.getStripId();
    return AppUser(id: id!, email: email!, authSource: authSource, userRole: userRole!, address: address!, phone_number: phone_number!, user_name: user_name!,stripeId: strip_id,activeCard: null);

}
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      LoginRequest request = LoginRequest(email, password);
      LoginResponse response = await _repository.signIn(request);
      await _loginApiUser(AuthSource.EMAIL);


      await Future.wait([
        _prefsHelper.setToken(response.token),
      ]);

      return AuthResponse(
          message: 'Login Success', status: AuthStatus.AUTHORIZED);
    } catch (e) {
      if (e is FirebaseAuthException) {
        Logger().info('AuthService', e.code.toString());
        return AuthResponse(
            message:e.code.toString() +'\n (There Is No Internet)', status: AuthStatus.UNAUTHORIZED);
      }
      else if(e is GetProfileException)
        {
          Logger().info('AuthService', 'Error getting Profile Fire Base API');

        }
      else if(e is UnauthorizedException){
        _auth.signOut();
        return AuthResponse(
            message: e.msg.toString(), status: AuthStatus.UNAUTHORIZED);
      }
      else
      Logger().info('AuthService', 'Error getting the token from the Fire Base API');


      return AuthResponse(
          message: e.toString(), status: AuthStatus.UNAUTHORIZED);
    }
  }

   //This function is private to generalize to different authentication methods 
   //  phone , email , google ...etc

  Future<void> _loginApiUser(AuthSource authSource) async {
    var user = _auth.currentUser;

    // Change This
     try{
       ProfileResponse profileResponse = await _repository.getProfile(user!.uid);

       if(profileResponse.userRole != UserRole.ROLE_DELIVERY)
         throw UnauthorizedException('The account is not authorized');
       await Future.wait([
         _prefsHelper.setUserId(user.uid),
         _prefsHelper.setStoreId(profileResponse.storeId),
         _prefsHelper.setEmail(user.email!),
         _prefsHelper.setAdderss(profileResponse.address),
         _prefsHelper.setUsername(profileResponse.userName),
         _prefsHelper.setPhone(profileResponse.phone),
         _prefsHelper.setAuthSource(authSource),
         _prefsHelper.setRole(profileResponse.userRole),
       ]);
     }catch(e){
       if(e is UnauthorizedException)
         {
           throw UnauthorizedException('The account is not authorized');
         }
         else
       throw GetProfileException('Error getting Profile Fire Base API');
     }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _prefsHelper.deleteToken();
    await _prefsHelper.cleanAll();
  }

  void fakeAccount() {
    FirebaseAuth.instance.currentUser!.delete();
  }

 Future<AuthResponse> resetPassword(String email) async{
    try {
      bool response = await _repository.getNewPassword(email);
      return AuthResponse(
          message: 'The new code has been sent', status: AuthStatus.AUTHORIZED);
    } catch (e) {

      return AuthResponse(
          message: e.toString(), status: AuthStatus.UNAUTHORIZED);
    }
  }
}
