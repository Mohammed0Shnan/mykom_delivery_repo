

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_delivery/injecting/components/app.component.dart';
import 'package:my_kom_delivery/module_authorization/authorization_module.dart';
import 'package:my_kom_delivery/module_dashbord/dashboard_module.dart';
import 'package:my_kom_delivery/module_dashbord/dashboard_routes.dart';
import 'package:my_kom_delivery/module_notifications/service/fire_notification_service/fire_notification_service.dart';
import 'package:my_kom_delivery/module_orders/orders_module.dart';
import 'package:my_kom_delivery/module_splash/splash_module.dart';
import 'package:my_kom_delivery/module_splash/splash_routes.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  // FirebaseMessaging.instance.subscribeToTopic('advertisements');
  //

  print(message.data.toString());
  print(message.notification!.title);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  final container = await AppComponent.create();

  BlocOverrides.runZoned(
    () {
      return runApp(container.app);
    },
    blocObserver: AppObserver(),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  final SplashModule _splashModule;
  final AuthorizationModule _authorizationModule;
  final OrdersModule _ordersModule;
  final DashBoardModule _dashBoardModule;
  MyApp(this._splashModule,
      this._authorizationModule,this._ordersModule,this._dashBoardModule);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
  //
  // FireNotificationService().init(context);
  //
  // FirebaseMessaging.instance.getInitialMessage().then((value) {
  //   if(value != null){
  //     final routeFromMessage = value.data['route'];
  //     Navigator.of(context).pushNamed( DashboardRoutes.DASHBOARD_SCREEN);
  //   }
  // });
  ///


  // FirebaseMessaging.onMessage.listen((event) {
  //   print('##############  notification #############');
  //   if(event.notification != null){
  //     print(event.notification!.body);
  //     print(event.notification!.title);
  //     print(event.notification!.toMap());
  //
  //   }
  //   FireNotificationService().display(event);
  // });
  //
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   print('##############  notification Clicked 000000000#############');
  //   final routeFromMessage = event.data['route'];
  //   Navigator.of(context).pushNamed( DashboardRoutes.DASHBOARD_SCREEN);
  //   print(routeFromMessage);
  // });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll(widget._splashModule.getRoutes());
    routes.addAll(widget._authorizationModule.getRoutes());
    routes.addAll(widget._ordersModule.getRoutes());
    routes.addAll(widget._dashBoardModule.getRoutes());

    return FutureBuilder<Widget>(
      initialData: Container(color: Colors.green),
      future: configuratedApp(routes),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data!;
      },
    );
  }

  Future<Widget> configuratedApp(Map<String, WidgetBuilder> routes) async {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Kom Delivery',
        routes: routes,

        initialRoute: SplashRoutes.SPLASH_SCREEN
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}

class AppObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print(bloc);
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    print(bloc);
    super.onClose(bloc);
  }
}
