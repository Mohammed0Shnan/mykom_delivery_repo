import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom_delivery/consts/colors.dart';
import 'package:my_kom_delivery/module_authorization/bloc/cubits.dart';
import 'package:my_kom_delivery/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom_delivery/module_authorization/enums/user_role.dart';
import 'package:my_kom_delivery/module_authorization/screens/reset_password_screen.dart';
import 'package:my_kom_delivery/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom_delivery/module_authorization/service/auth_service.dart';
import 'package:my_kom_delivery/module_dashbord/dashboard_routes.dart';
import 'package:my_kom_delivery/utils/size_configration/size_config.dart';

class LoginScreen extends StatefulWidget {
  final LoginBloc _loginBloc = LoginBloc();
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _LoginFormKey = GlobalKey<FormState>();
  final TextEditingController _LoginEmailController = TextEditingController();
  final TextEditingController _LoginPasswordController =
      TextEditingController();

  late final PasswordHiddinCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = PasswordHiddinCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _LoginFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.heightMulti * 7,
                color: ColorsConst.mainColor,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              Text('Login',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: SizeConfig.titleSize * 5)),
              SizedBox(
                height: SizeConfig.screenHeight * 0.05,
              ),
              SizedBox(
                height: SizeConfig.heightMulti * 4,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(

                    subtitle: SizedBox(
                      child: TextFormField(
                        style: TextStyle(fontSize: 18,
                        height: 1
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _LoginEmailController,
                        decoration: InputDecoration(
                          isDense: true,
                            contentPadding: EdgeInsets.all(16),
                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    width: 2,
                                    style: BorderStyle.solid,
                                    color: Colors.black87)),
                            label: Text('Email',),
                            labelStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: SizeConfig.titleSize * 2.5)

                            //S.of(context).name,
                            ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        validator: (result) {
                          if (result!.isEmpty) {
                            return 'Email Address is Required'; //S.of(context).nameIsRequired;
                          }
                          if (!_validateEmailStructure(result))
                            return 'Must write an email address';
                          return null;
                        },
                      ),
                    )),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  subtitle: BlocBuilder<PasswordHiddinCubit,
                      PasswordHiddinCubitState>(
                    bloc: cubit,
                    builder: (context, state) {
                      return SizedBox(
                        child: TextFormField(
                          controller: _LoginPasswordController,
                          style: TextStyle(fontSize: 20,
                          height: 1
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                              contentPadding: EdgeInsets.all(16.0),
                              errorStyle: GoogleFonts.lato(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w800,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.changeState();
                                  },
                                  icon:
                                      state == PasswordHiddinCubitState.VISIBILITY
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 2,
                                      style: BorderStyle.solid,
                                      color: Colors.black87)),
                              label: Text('Password',),
                              labelStyle: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: SizeConfig.titleSize * 2.5)
// S.of(context).email,
                              ),
                          obscureText:
                              state == PasswordHiddinCubitState.VISIBILITY
                                  ? false
                                  : true,

                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (v) => node.unfocus(),
                          // Move focus to next
                          validator: (result) {
                            if (result!.isEmpty) {
                              return '* Password is Required'; //S.of(context).emailAddressIsRequired;
                            }
                            if (result.length < 8) {
                              return '* The password is short, it must be 8 characters long'; //S.of(context).emailAddressIsRequired;
                            }

                            return null;
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestPasswordScreen()));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(right: 2.345 * SizeConfig.heightMulti),
                    child: Text('Forgot password ?',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w800,
                          color: Colors.black54,
                          fontSize: SizeConfig.titleSize * 2.1,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMulti * 3,
              ),
              BlocConsumer<LoginBloc, LoginStates>(
                  bloc: widget._loginBloc,
                  listener: (context, LoginStates state) async {
                    if (state is LoginSuccessState) {
                      snackBarSuccessWidget(context, state.message);
                      UserRole? role = await AuthService().userRole;
                      if (role != null) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            DashboardRoutes.DASHBOARD_SCREEN, (route) => false);
                      }
                    } else if (state is LoginErrorState) {
                      snackBarErrorWidget(context, state.message);
                    }
                  },
                  builder: (context, LoginStates state) {
                    if (state is LoginLoadingState)
                      return Container(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorsConst.mainColor,
                            ),
                          ));
                    else
                      return ListTile(
                        title: Container(
                          height: 55,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: ColorsConst.mainColor,
                              ),
                              onPressed: () {
                                if (_LoginFormKey.currentState!.validate()) {
                                  String email =
                                      _LoginEmailController.text.trim();
                                  String password =
                                      _LoginPasswordController.text.trim();
                                  widget._loginBloc.login(email, password);
                                }
                              },
                              child: Text('LOGIN',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: SizeConfig.titleSize * 2.5,
                                      fontWeight: FontWeight.w700))),
                        ),
                      );
                  }),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateEmailStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
