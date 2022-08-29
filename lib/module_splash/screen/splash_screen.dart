
import 'package:flutter/material.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/module_authorization/authorization_routes.dart';
import 'package:my_kom_delivery/module_authorization/enums/user_role.dart';
import 'package:my_kom_delivery/module_authorization/service/auth_service.dart';
import 'package:my_kom_delivery/module_dashbord/dashboard_routes.dart';
import 'package:my_kom_delivery/module_splash/bloc/splash_bloc.dart';
import 'package:my_kom_delivery/utils/size_configration/size_config.dart';
class SplashScreen extends StatefulWidget {
  final AuthService _authService;
  // final ProfileService _profileService;

  SplashScreen(
    this._authService,
    // this._profileService,
  );
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    spalshAnimationBloC.playAnimation();
       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getNextRoute().then((route) async{
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
      });
    });
  }

  @override
  void dispose() {
    spalshAnimationBloC.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
    );
  }

  Future<String> _getNextRoute() async {
    try {
     // Is LoggedIn
      UserRole? role = await widget._authService.userRole;
      if(role != null){

        return DashboardRoutes.DASHBOARD_SCREEN;
      }

      // Is Not LoggedInt
     else {
         return AuthorizationRoutes.LOGIN_SCREEN;
      //  return AuthorizationRoutes.LOGIN_SCREEN;
      }
    } catch (e) {
              return AuthorizationRoutes.LOGIN_SCREEN;
  // about screen
    }
  }
}


