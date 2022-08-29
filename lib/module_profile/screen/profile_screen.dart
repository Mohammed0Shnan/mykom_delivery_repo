import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/module_authorization/authorization_routes.dart';
import 'package:my_kom_delivery/module_authorization/bloc/is_loggedin_cubit.dart';
import 'package:my_kom_delivery/module_authorization/model/address_model.dart';
import 'package:my_kom_delivery/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom_delivery/module_authorization/service/auth_service.dart';
import 'package:my_kom_delivery/module_orders/ui/widgets/no_data_for_display_widget.dart';
import 'package:my_kom_delivery/module_profile/bloc/profile_bloc.dart';
import 'package:my_kom_delivery/module_profile/service/profile_service.dart';
import 'package:my_kom_delivery/utils/size_configration/size_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc profileBloc = ProfileBloc();
  final ProfileService _profileService = ProfileService();
  final TextEditingController _profileUserNameController = TextEditingController();
  final TextEditingController _profileAddressController = TextEditingController();
  final TextEditingController _profilePhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    profileBloc.getMyProfile();


    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
 late String? userId;
  bool isEditingProfile = false;
  late AddressModel addressModel ;
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          color: Colors.grey.shade50,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<ProfileBloc, ProfileStates>(
              bloc: profileBloc,
              listener: (context,state){
                if(state is ProfileSuccessState){
                  _profileUserNameController.text = state.data.userName;
                  _profileAddressController.text = state.data.address.description;
                  _profilePhoneController.text = state.data.phone;
                  addressModel = state.data.address;
                  if(state.isEditState){
                    isEditingProfile = ! isEditingProfile;
                  }

                }
              },
              builder: (context,state) {

                if(state is ProfileErrorState){
                  return NoDataForDisplayWidget();
                }
                else if(state is ProfileSuccessState) {

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Spacer(),
                              Center(
                                child: Text('My Profile',textAlign: TextAlign.center,style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: SizeConfig.titleSize * 3.2,
                                  fontWeight: FontWeight.bold,



                                ),),
                              ),
                              Spacer(),
                              IconButton(onPressed: (){
                                AuthService().logout().then((value) {
                                  Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);
                                });
                              }, icon: Icon(Icons.logout))
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                            height: SizeConfig.screenHeight * 0.27,
                            child: LayoutBuilder(
                              builder: (context,constraints){
                                double innerHeight  = constraints.maxHeight;
                                double innerWidth  = constraints.maxWidth;
                                return Stack(
                                  fit:StackFit.expand,
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:innerHeight * 0.55,
                                        width:innerWidth ,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(color: Colors.black12,
                                                  blurRadius: 5
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            SizedBox(
                                              height: SizeConfig.heightMulti * 4.5,
                                            ),
                                            Center(
                                              child: TextFormField(
                                                textAlign: TextAlign.center,

                                                controller: _profileUserNameController,

                                                style: TextStyle(

                                                    fontSize: SizeConfig.titleSize * 2.8,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700]
                                                ),

                                                decoration: InputDecoration(
                                                  suffixIcon: (!isEditingProfile)?null:Icon(Icons.edit,color: Colors.black,),
                                                  border: InputBorder.none,
                                                  //S.of(context).name,
                                                ),
                                                textInputAction: TextInputAction.next,
                                                // Move focus to next
                                              ),
                                            ),
                                            FutureBuilder<String?>(
                                                initialData: null,
                                                future: _profileService.getStore()
                                                ,builder: (context,AsyncSnapshot<String?> snap){
                                              if(snap.hasData){
                                                String? data = snap.data;
                                                if(data == null){
                                                  return Center(child: Text('load store ...'),);
                                                }else{
                                                  return Center(child: Text('Store : '+data),);
                                                }
                                              }else {
                                                return Center(child: Text('Error in load store'),);
                                              }
                                            })


                                          ],),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(color: Colors.black12,
                                                  blurRadius: 5
                                              )
                                            ],
                                          ),
                                          child: Image.asset('assets/profile.png',
                                            fit: BoxFit.fitWidth,
                                            width: innerWidth *0.35,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 25,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            height: SizeConfig.screenHeight * 0.43,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12,
                                    blurRadius: 5
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),

                                Text('My Information',style:  TextStyle(
                                    fontSize: SizeConfig.titleSize * 2.3,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]
                                ),),
                                Divider(
                                  thickness: 2.5,
                                ),
                                SizedBox(height: 10,),

                                Container(
                                  height: SizeConfig.screenHeight *0.14,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(

                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey.shade200
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 8,),
                                      Text('My Address',style:  TextStyle(
                                          fontSize: SizeConfig.titleSize * 2,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]
                                      ),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.location_on , color: ColorsConst.mainColor,size: 17,),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(top: 12),
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: _profileAddressController,
                                                maxLines: 2,
                                                style:  TextStyle(
                                                    fontSize:SizeConfig.titleSize * 1.7,

                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600]
                                                ),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  //S.of(context).name,
                                                ),
                                                textInputAction: TextInputAction.next,
                                                // Move focus to next
                                              ),
                                            ),

                                          ),


                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),

                                  height: SizeConfig.screenHeight *0.15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.grey.shade200
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,                            children: [
                                    Text('Email And Phone',style:  TextStyle(
                                        fontSize: SizeConfig.titleSize * 2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]
                                    ),),
                                    SizedBox(height: 8,),

                                    Row(
                                      children: [
                                        Icon(Icons.email , color: ColorsConst.mainColor,size: 17,),
                                        SizedBox(width: 10,),
                                        Text(state.data.email,style:  TextStyle(
                                            fontSize: SizeConfig.titleSize * 1.7,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]
                                        ),),

                                      ],
                                    ),
                                    SizedBox(height: 5,),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.phone , color: ColorsConst.mainColor,size: 17,),
                                        SizedBox(width: 10,),
                                        Text(state.data.phone,style:  TextStyle(
                                            fontSize: SizeConfig.titleSize * 1.7,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]
                                        ),),


                                      ],
                                    )
                                  ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else
                  return Center(
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: CircularProgressIndicator(color: ColorsConst.mainColor,),
                      ),
                    ),
                  );
              }
          ),
        )
      ],
    );

  }

}

