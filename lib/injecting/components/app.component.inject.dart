import 'package:my_kom_delivery/injecting/components/app.component.dart';
import 'package:my_kom_delivery/main.dart';
import 'package:my_kom_delivery/module_authorization/authorization_module.dart';
import 'package:my_kom_delivery/module_authorization/screens/login_screen.dart';
import 'package:my_kom_delivery/module_authorization/service/auth_service.dart';
import 'package:my_kom_delivery/module_dashbord/dashboard_module.dart';
import 'package:my_kom_delivery/module_dashbord/screen/dash_bord_screen.dart';
import 'package:my_kom_delivery/module_orders/orders_module.dart';
import 'package:my_kom_delivery/module_orders/ui/screens/order_detail.dart';
import 'package:my_kom_delivery/module_orders/ui/screens/owner_orders.dart';
import 'package:my_kom_delivery/module_splash/screen/splash_screen.dart';
import 'package:my_kom_delivery/module_splash/splash_module.dart';

class AppComponentInjector implements AppComponent {
  AppComponentInjector._();


  static Future<AppComponent> create() async {
    final injector = AppComponentInjector._();
    return injector;
  }

  MyApp _createApp() => MyApp(
      _createSplashModule(),
      _createAuthorizationModule(),
      _createOrderModule(),
      _createDashBoard()
      );
  SplashModule _createSplashModule() =>
      SplashModule(SplashScreen(AuthService()));

  AuthorizationModule _createAuthorizationModule() =>
      AuthorizationModule(LoginScreen());
  OrdersModule _createOrderModule()=> OrdersModule(OrderDetailScreen());
  DashBoardModule _createDashBoard()=> DashBoardModule(DashBoardScreen());

  MyApp get app {
    return _createApp();
  }
}
