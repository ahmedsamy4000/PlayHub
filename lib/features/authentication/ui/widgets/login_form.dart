import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';

import '../../../../core/validator.dart';
import '../../cubits/auth_cubit.dart';
import 'custom_login_button.dart';
import 'login_custom_textfield.dart';
import 'login_divider.dart';

class CustomLoginForm extends StatelessWidget {
   CustomLoginForm({
    super.key,
  });
  final loginFormKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var cubit =BlocProvider.of<AuthCubit>(context);
    return Padding(
      padding: 8.padAll,
      child: Container(
        padding: 40.padVertical,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(50.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                offset: Offset(3, 5),
              ),
            ]
        ),
        child: Form(
          key: loginFormKey,
          child: Column(
            children: [
              Text(
                "Welcome",
                style:
                TextStyle(color: AppColors.darkGray, fontSize: 30.sp),
              ),
              CustomDivider(colorDivider: AppColors.darkGreen,),
              35.verticalSpace,
              CustomTextFormField(
                hint: "Enter your email",
                validator: Validator.validateEmail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value){
                  cubit.setEmail(value);
                },
              ),
              35.verticalSpace,
              CustomTextFormField(
                hint: "Enter your password",
                validator: Validator.validatePassword,
                keyboardType: TextInputType.text,
                onChanged: (value){
                  cubit.setPassword(value);
                },
                isPassword: true,
              ),
              40.verticalSpace,
              Padding(
                padding: 23.padHorizontal,
                child: LoginButton(
                  onTap: (){
                    if(loginFormKey.currentState!.validate()){
                      cubit.login();
                    }
                  },
                  gradiantColor: AppColors.loginGradiantColorButton ,
                  tapedGradiantColor: AppColors.loginGradiantColorButtonTaped ,
                  text: "Login",
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}