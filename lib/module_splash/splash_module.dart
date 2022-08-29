
import 'package:flutter/material.dart';
import 'package:my_kom_delivery/abstracts/module/my_module.dart';
import 'package:my_kom_delivery/module_splash/screen/splash_screen.dart';
import 'package:my_kom_delivery/module_splash/splash_routes.dart';

class SplashModule extends MyModule {
  
  final SplashScreen _splashScreen;
  SplashModule(this._splashScreen ) ;

  @override
  Map<String, WidgetBuilder> getRoutes() {
  return {SplashRoutes.SPLASH_SCREEN : (context) => _splashScreen};
  }
}