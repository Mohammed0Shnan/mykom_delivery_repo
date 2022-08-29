import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/module_map/screen/map_screen.dart';
import 'package:my_kom_delivery/module_orders/model/order_model.dart';
import 'package:my_kom_delivery/module_orders/orders_routes.dart';
import 'package:my_kom_delivery/module_orders/state_manager/delivery_orders_bloc.dart';
import 'package:my_kom_delivery/module_orders/ui/widgets/delete_order_sheak_alert.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OwnerOrdersScreen extends StatefulWidget {
   final String zone ;
   OwnerOrdersScreen({required this.zone});
  @override
  State<StatefulWidget> createState() => OwnerOrdersScreenState();
}

class OwnerOrdersScreenState extends State<OwnerOrdersScreen> {
  final CaptainOrdersListBloc _ordersListBloc = CaptainOrdersListBloc();

  final String PENDING_ORDER = 'pending';
  final String FINISHED_ORDER = 'finished';
  late String current_tap ;

  @override
  void initState() {
    current_tap = PENDING_ORDER;
    super.initState();
    _ordersListBloc.getZoneOrders(widget.zone);

  }
  bool panelIsOpen = false;
   final PanelController _panelController = PanelController();
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Orders'),
      actions: [

        IconButton(onPressed: (){
          _ordersListBloc.getZoneOrders(widget.zone);
        }, icon: Icon(Icons.refresh)

        ),

      ],
      backgroundColor: ColorsConst.mainColor,
    ),
    backgroundColor: Colors.grey.shade50,
    body: SafeArea(
      child:
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
                    bloc: _ordersListBloc,
                    listener: (context ,state){
                    },
                    builder: (maincontext,state) {
                      if(state is CaptainOrdersListSuccessState) {
                        List<OrderModel> orders = state.data['curr']!;
                        return MapWidget(orders: orders);
                      }
                      else{
                        return Center(child: Container(
                            height: 20,width: 20,
                            child: CircularProgressIndicator(color: Colors.blue,)));
                      }
                    }
                ),
              ),
              SlidingUpPanel(

                borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                topLeft:  Radius.circular(10)
                ),

                maxHeight: MediaQuery.of(context).size.height * 0.8,
                controller: _panelController,
                minHeight: MediaQuery.of(context).size.height * 0.4,
                panel: Center(child:Column(
                  children: [

IconButton(  icon: Icon(!panelIsOpen?Icons.arrow_upward_outlined:Icons.arrow_downward_rounded),onPressed: (){
  if(_panelController.isPanelOpen){
    _panelController.close();


  }
    else
      _panelController.open();

  panelIsOpen = !panelIsOpen;
  setState((){});


},)     ,               SizedBox(height: 20,),
                    getAccountSwitcher(),
                    SizedBox(height: 8,),

                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: current_tap == PENDING_ORDER
                            ? getOrders()
                            : getFinishedOrders(),
                      ),
                    ),

                  ],
                )),
              )
            ],
          ),


    ),

  );
  }



  Widget getFinishedOrders(){

    return  BlocBuilder<CaptainOrdersListBloc ,CaptainOrdersListStates >(
      bloc: _ordersListBloc,
      builder: (context , state) {
        if(state is CaptainOrdersListErrorState){
          return Center(child: Text('Error In Fetch Data !!  Scroll For Refresh'),);
        }else if(state is CaptainOrdersListSuccessState){
          List<OrderModel> list = state.data['pre']!;

          if(list.isEmpty)
            return Center(
              child: Container(child: Text(' There are no completed orders !',style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20,color: Colors.black54),),),
            );
          else

          return RefreshIndicator(
            onRefresh: ()=>onRefreshMyOrder(),
            child: ListView.separated(
              itemCount:list.length,
              separatorBuilder: (context,index){
                return SizedBox(height: 8,);
              },
              itemBuilder: (context,index){

                return GestureDetector(
                  onTap: (){
                     Navigator.pushNamed(context, OrdersRoutes.ORDER_DETAIL_SCREEN , arguments:list[index].id );
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius:2,
                            spreadRadius: 1
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorsConst.mainColor.withOpacity(0.1)
                              ),
                              child: Text('Num : '+list[index].customerOrderID.toString() ,style: GoogleFonts.lato(
                                  color: ColorsConst.mainColor,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            InkWell(
                                onTap: (){

                                  //deleteOrderCheckAlertWidget(maincontext, orderID: orders[index].id);
                                },
                                child: Icon(Icons.close,color:Colors.black54 ,)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              height:40,width: 40,

                         child: Image.asset('assets/order_completed.png',height: 40,width: 40,fit: BoxFit.contain),

                            ),
                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8,),
                                  Text(list[index].description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                      fontSize: 12,

                                      color: Colors.black45,
                                      fontWeight: FontWeight.w800
                                  )),
                                  SizedBox(height: 4,),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined , color: Colors.black45,),
                                      Expanded(
                                        child: Text(list[index].addressName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800,

                                        )),
                                      )

                                    ],),
                                  SizedBox(height: 4,),
                                  Text(list[index].orderValue.toString() + '    AED',style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: ColorsConst.mainColor,
                                      fontWeight: FontWeight.bold
                                  )),
                                  SizedBox(height: 4,),


                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        else {
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }
  Widget getAccountSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: BlocBuilder<CaptainOrdersListBloc ,CaptainOrdersListStates >(
          bloc: _ordersListBloc,
          builder: (context, state) {
            int curNumber =0;
            int preNumber =0;
            if(state is CaptainOrdersListSuccessState){
              curNumber = state.data['curr']!.length;
              preNumber = state.data['pre']!.length;
            }
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      current_tap = PENDING_ORDER;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: current_tap == PENDING_ORDER
                              ? ColorsConst.mainColor
                              : Colors.transparent,

                        ),
                        child: Center(child: Text('Pending Orders (${curNumber})',style: TextStyle(
                            color: current_tap == PENDING_ORDER ?Colors.white: ColorsConst.mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                        ),))),
                  ),
                ),
                Expanded(
                  child:GestureDetector(
                    onTap: () {
                      current_tap = FINISHED_ORDER;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        color:    current_tap == FINISHED_ORDER
                            ? ColorsConst.mainColor
                            : Colors.transparent,
                      ),
                      child:Center(child: Text('Finished Orders (${preNumber})',style: TextStyle(
                          color: current_tap == FINISHED_ORDER ?Colors.white: ColorsConst.mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ))),
                    ),
                  ),
                )

              ],
            );
          }
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
    _ordersListBloc.getZoneOrders(widget.zone);
  }
 Widget getOrders(){
    return BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
      bloc: _ordersListBloc,
      listener: (context ,state){
      },
      builder: (maincontext,state) {

         if(state is CaptainOrdersListErrorState)
          return Center(
            child: Container(
              color: ColorsConst.mainColor,
              padding: EdgeInsets.symmetric(),
              child: Text(state.message,style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
            ),
          );

        else if(state is CaptainOrdersListSuccessState) {
           List<OrderModel> orders = state.data['curr']!;

           if(orders.isEmpty)
             return Center(
               child: Container(child: Text('No Orders !',style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 20,color: Colors.black54),),),
             );
           else
          return RefreshIndicator(
          onRefresh: ()=>onRefreshMyOrder(),
          child: Column(
            children: [

              Expanded(
                child: ListView.separated(
                  itemCount:orders.length,
                  separatorBuilder: (context,index){
                    return SizedBox(height: 8,);
                  },
                  itemBuilder: (context,index){

                    return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(maincontext, OrdersRoutes.ORDER_DETAIL_SCREEN, arguments:orders[index].id);
                      },
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius:2,
                              spreadRadius: 1
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              child: Image.asset('assets/order.png',fit: BoxFit.fill,),
                            ),
                            SizedBox(width: 8,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: ColorsConst.mainColor.withOpacity(0.1)
                                            ),
                                            child: Text('Num : '+orders[index].customerOrderID.toString() ,style: GoogleFonts.lato(
                                                color: ColorsConst.mainColor,
                                                fontSize: 15,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.bold
                                            ),),
                                          ),
                                          SizedBox(width: 8,),
                                          InkWell(
                                              onTap: (){

                                                deleteOrderCheckAlertWidget(maincontext, orderID: orders[index].id);
                                              },
                                              child: Icon(Icons.close,color:Colors.black54 ,)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Expanded(
                                    child: Text(orders[index].description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w800
                                    )),
                                  ),
                                  SizedBox(height: 4,),

                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                    Icon(Icons.location_on_outlined , color: Colors.black45,),
                                    Expanded(
                                      child: Text(orders[index].addressName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800,

                                      )),
                                    )

                                  ],),
                                  SizedBox(height: 4,),
                                  Text(orders[index].orderValue.toString() + '    AED',style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: ColorsConst.mainColor,
                                      fontWeight: FontWeight.bold
                                  )),
                                  SizedBox(height: 8,),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );}
        else  return Center(
             child: Container(
               width: 30,
               height: 30,
               child: CircularProgressIndicator(color: ColorsConst.mainColor,),
             ),
           );

      }
    );
  }


}
