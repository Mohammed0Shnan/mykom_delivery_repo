
import 'package:flutter/material.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/module_orders/ui/screens/orders_screen.dart';
import 'package:my_kom_delivery/module_profile/screen/profile_screen.dart';

class DashBoardScreen extends StatefulWidget {
  final OrdersScreen ordersScreen = OrdersScreen();
  final ProfileScreen _profileScreen = ProfileScreen();

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _getActiveScreen(),
        bottomNavigationBar: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(16),
          child: BottomNavigationBar(
            backgroundColor: ColorsConst.mainColor,
              selectedItemColor: Colors.white,
              unselectedIconTheme:  IconThemeData(
                color: Colors.white.withOpacity(0.5)
              ),
              iconSize: 26,
              
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
              unselectedItemColor: Colors.white.withOpacity(0.5),
              currentIndex: current_index,
              onTap: (index) {
                current_index = index;
                setState(() {});
              },
            items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, color: Colors.white),label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.white),label: 'Profile'),
          ],),
        )
        // bottomNavigationBar:  CurvedNavigationBar(
        //   color: ColorsConst.mainColor,
        //   backgroundColor: Colors.grey.shade50,
        //   onTap: (index) {
        //     current_index = index;
        //     setState(() {});
        //   },
        //   items: [
        //     Icon(Icons.home, color: Colors.white),
        //     Icon(
        //       Icons.person,
        //       color: Colors.white,
        //     ),
        //   ],
        //   animationDuration: Duration(milliseconds: 100),
        //   animationCurve: Curves.easeIn,
        // )
    );
  }

  _getActiveScreen(){
    switch(current_index){
      case 0 : {
        return widget.ordersScreen;

      }

      case 1:{
        return widget._profileScreen;
      }



    }
  }
}
