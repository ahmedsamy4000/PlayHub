import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/features/authentication/cubits/auth_cubit.dart';
import 'package:playhub/features/profile/ui/screens/profile_screen.dart';

import '../../../../core/app_colors.dart';
import 'custom_login_button.dart';
import 'login_custom_textfield.dart';
import 'login_divider.dart';

class SignupForm extends StatelessWidget {
   SignupForm({super.key, required this.type});

  final formRegisterKey= GlobalKey<FormState>();
  final UserType type;
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
                offset: const Offset(3, 5),
              ),
            ]
        ),
        child: Form(
          key: formRegisterKey,
          child: Column(
            children: [
              Text(
                "Registeration",
                style:
                TextStyle(color: AppColors.darkGray, fontSize: 30.sp),
              ),
              const CustomDivider(colorDivider: AppColors.darkGreen,),
              30.verticalSpace,
              CustomTextFormField(
                hint: "Enter your full name",
                validator: Validator.validateName,
                keyboardType: TextInputType.text,
                onChanged: (value){
                  cubit.setName(value);
                },
              ),
              30.verticalSpace,
              CustomTextFormField(
                hint: "Enter your email",
                validator: Validator.validateEmail,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value){
                  cubit.setEmail(value);
                },
              ),
              30.verticalSpace,
              CustomTextFormField(
                hint: "Enter your phone",
                validator: Validator.validatePhoneNumber,
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                keyboardType: TextInputType.phone,
                onChanged: (value){
                  cubit.setPhone(value);
                },
              ),
              30.verticalSpace,
              CustomTextFormField(
                hint: "Enter your password",
                validator: Validator.validatePassword,
                keyboardType: TextInputType.text,
                onChanged: (value){
                  cubit.setPassword(value);
                },
                isPassword: true,
              ),
              30.verticalSpace,
              CustomTextFormField(
                  hint: "confirm password",
                  validator: Validator.validatePassword,
                keyboardType: TextInputType.text,
                onChanged: (value){
                  cubit.setConfirmPassword(value);
                },
                isPassword: true,
              ),
              35.verticalSpace,
              Padding(
                padding: 23.padHorizontal,
                child: LoginButton(
                  onTap: (){
                    print("outtttt");
                    if(formRegisterKey.currentState!.validate()){
                      cubit.registeration(type: type);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                    }
                  },
                  gradiantColor: AppColors.loginGradiantColorButton ,
                  tapedGradiantColor: AppColors.loginGradiantColorButtonTaped ,
                  text: "Register",
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
