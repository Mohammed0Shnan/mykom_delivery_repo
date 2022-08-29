
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/consts/order_status.dart';
import 'package:my_kom_delivery/module_orders/model/order_model.dart';
import 'package:my_kom_delivery/module_orders/state_manager/delivery_orders_bloc.dart';
import 'package:my_kom_delivery/module_orders/ui/screens/owner_orders.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  final CaptainOrdersListBloc _ordersListBloc = CaptainOrdersListBloc();

  @override
  void initState() {
    super.initState();
    _ordersListBloc.getOwnerOrders();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regions'),
        backgroundColor: ColorsConst.mainColor,
      ),
      body: Container(
        child: Column(
          children: [

            SizedBox(height: 20,),
            Expanded(
              child: BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
                  bloc: _ordersListBloc,
                  listener: (context ,state){
                  },
                  builder: (maincontext,state) {

                    if(state is CaptainOrdersListErrorState)
                      return  Center(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            color: ColorsConst.mainColor,
                            child: Text('Error ! , Scroll For Refresh',style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
                          ),
                        ),
                      );

                    else if(state is CaptainOrdersListSuccessState) {
                     Map<String , List<OrderModel>> sections = state.data;
                      if(sections.isEmpty)
                        return Center(
                          child: Container(child: Text('No Orders !!'),),
                        );
                      else
                        return RefreshIndicator(
                          onRefresh: ()=>onRefreshMyOrder(),
                          child:  ListView.separated(
                              itemCount:sections.length,
                              separatorBuilder: (context,index){
                                return SizedBox(height: 8,);
                              },
                              itemBuilder: (context,index){

                                List<OrderModel> cardOrders = sections[sections.keys.elementAt(index)]!;

                                int finishedOrders = 0;
                                int pendingOrders = 0;
                                double value = 0.0;
                                cardOrders.forEach((element) {

                                  if(element.status == OrderStatus.FINISHED){
                                    finishedOrders++;
                                  value+= element.orderValue;
                                  }
                                  else
                                    pendingOrders++;
                                });


                                return  GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> OwnerOrdersScreen(zone:sections.keys.elementAt(index))));
                                  },
                                  child: Container(
                                      height: 165,
                                      width: double.infinity,
                                      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius:1,
                                              offset: Offset(0,2)
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(sections.keys.elementAt(index),overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold
                                              )),
                                              SizedBox(height: 16,),
                                              Text('Number of orders all :  ${cardOrders.length}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w800
                                              )),
                                              SizedBox(height: 8,),
                                              Text('Processed orders :  ${finishedOrders}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w800
                                              )),
                                              SizedBox(height: 8,),
                                              Text('Pending orders :  ${pendingOrders}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w800
                                              )),
                                              SizedBox(height: 8,),
                                              Text('Sales value :  ${value}',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w800
                                              )),
                                            ],
                                          ),
                                          Row(children: [
                                            Text('Go for orders',style: TextStyle(fontWeight: FontWeight.w700 , color: Colors.black54 ,fontSize: 16),),
                                            SizedBox(width: 8,),
                                           Icon(Icons.arrow_forward)
                                          ],)
                                        ],
                                      )
                                  ),
                                );
                              },
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
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
    _ordersListBloc.getOwnerOrders();
  }
}
