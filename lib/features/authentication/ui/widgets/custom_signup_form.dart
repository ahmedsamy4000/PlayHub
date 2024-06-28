import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/features/authentication/cubits/auth_cubit.dart';
import 'package:playhub/features/profile/ui/screens/profile_screen.dart';
import 'package:playhub/generated/l10n.dart';

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
    return
    // SingleChildScrollView(
    //   child:
    Padding(
        padding: 8.padAll,
        child: Container(
          padding: 30.padVertical,
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
                FadeInSlide(
                  duration: 0.4,
                  child: Text(
                    S.of(context).Register,
                    style:
                    TextStyle(color: AppColors.darkGray, fontSize: 30.sp),
                  ),
                ),
                FadeInSlide(
                  duration: 0.5,
                    child: const CustomDivider(colorDivider: AppColors.darkGreen,)),
                20.verticalSpace,
                FadeInSlide(
                  duration: 0.6,
                  child: CustomTextFormField(
                    hint: S.of(context).Name,
                    validator: Validator.validateName,
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      cubit.setName(value);
                    },
                  ),
                ),
                20.verticalSpace,
                FadeInSlide(
                  duration: 0.7,
                  child: CustomTextFormField(
                    hint: S.of(context).Email,
                    validator: Validator.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value){
                      cubit.setEmail(value);
                    },
                  ),
                ),
                20.verticalSpace,
                FadeInSlide(
                  duration: 0.8,
                  child: CustomTextFormField(
                    hint: S.of(context).Phone,
                    validator: Validator.validatePhoneNumber,
                    inputFormatter: FilteringTextInputFormatter.digitsOnly,
                    keyboardType: TextInputType.phone,
                    onChanged: (value){
                      cubit.setPhone(value);
                    },
                  ),
                ),
                20.verticalSpace,
                FadeInSlide(
                  duration: 0.9,
                  child: CustomTextFormField(
                    hint: S.of(context).Password,
                    validator: Validator.validatePassword,
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      cubit.setPassword(value);
                    },
                    isPassword: true,
                  ),
                ),
                20.verticalSpace,
                FadeInSlide(
                  duration: 1.0,
                  child: CustomTextFormField(
                      hint: S.of(context).CPassword,
                      validator: Validator.validatePassword,
                    keyboardType: TextInputType.text,
                    onChanged: (value){
                      cubit.setConfirmPassword(value);
                    },
                    isPassword: true,
                  ),
                ),
                25.verticalSpace,
                FadeInSlide(
                  duration: 1.1,
                  child: Padding(
                    padding: 23.padHorizontal,
                    child: LoginButton(
                      onTap: (){
                        print("outtttt");
                        if(formRegisterKey.currentState!.validate()){
                          cubit.registeration(type: type,context: context);
                        }
                      },
                      gradiantColor: AppColors.loginGradiantColorButton ,
                      tapedGradiantColor: AppColors.loginGradiantColorButtonTaped ,
                      text: S.of(context).Register,
                    ),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      )
    //)
    ;
  }
}
