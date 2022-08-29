import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom_delivery/module_authorization/enums/auth_source.dart';
import 'package:my_kom_delivery/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom_delivery/module_authorization/repository/auth_repository.dart';
import 'package:my_kom_delivery/module_authorization/response/login_response.dart';
import 'package:my_kom_delivery/module_profile/model/profile_model.dart';

class ProfileService {

  final AuthRepository _repository = AuthRepository();
  final AuthPrefsHelper _prefsHelper = AuthPrefsHelper();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ProfileModel?> getMyProfile() async {
    var user = _auth.currentUser;
    // Change This
    try {
      ProfileResponse profileResponse = await _repository.getProfile(user!.uid);

      await Future.wait([
        _prefsHelper.setEmail(user.email!),
        _prefsHelper.setAdderss(profileResponse.address),
        _prefsHelper.setUsername(profileResponse.userName),
        _prefsHelper.setPhone(profileResponse.phone),
        _prefsHelper.setAuthSource(AuthSource.EMAIL),
        _prefsHelper.setRole(profileResponse.userRole),
      ]);
      ProfileModel profileModel = ProfileModel(
          userName: profileResponse.userName,
          email: user.email!,
          phone: profileResponse.phone,
          address: profileResponse.address,
          userRole: profileResponse.userRole);
      return profileModel;
    } catch (e) {
      return null;
    }
  }

  Future<ProfileModel?> getUserProfile(String userID) async {
    // Change This
    try {
      ProfileResponse profileResponse = await _repository.getProfile(userID);

      ProfileModel profileModel = ProfileModel(
          userName: profileResponse.userName,
          email: profileResponse.email,
          phone: profileResponse.phone,
          address: profileResponse.address,
          userRole: profileResponse.userRole);
      return profileModel;
    } catch (e) {
      return null;
    }
  }

 Future<String?> getStore()async{
    String? storeId = await _prefsHelper.getStoreId();
     String? store =  await _repository.getStore(storeId!);
     return store;
  }
}

