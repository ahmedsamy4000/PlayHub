import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/features/authentication/cubits/auth_states.dart';
import 'package:playhub/features/profile/ui/screens/profile_screen.dart';
import 'package:playhub/generated/l10n.dart';

import '../../../../common/fade_in_slide.dart';
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
  bool isError =false;
  TextEditingController emailController=TextEditingController();
   TextEditingController passwordController=TextEditingController();

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
        child: BlocBuilder<AuthCubit,AuthStates>(
          builder: (context,state) {
            if(state is AuthErrorState){
              isError =true;
            }
            return Form(
              key: loginFormKey,
              child: Column(
                children: [
                  FadeInSlide(
                    duration: 0.5,
                    child: Text(
                      S.of(context).Welcome,
                      style:
                      TextStyle(color: AppColors.darkGray, fontSize: 30.sp),
                    ),
                  ),
                  const CustomDivider(colorDivider: AppColors.darkGreen,),
                  35.verticalSpace,

                  FadeInSlide(
                    duration: 0.6,
                    child: CustomTextFormField(
                      hint: S.of(context).Email,
                      validator: Validator.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value){
                        cubit.setEmail(value);
                      },
                      isError:isError,
                      controller: emailController,
                    ),
                  ),
                  35.verticalSpace,
                  FadeInSlide(
                    duration: 0.7,
                    child: CustomTextFormField(
                      hint: S.of(context).Password,
                      validator: Validator.validatePassword,
                      keyboardType: TextInputType.text,
                      onChanged: (value){
                        cubit.setPassword(value);
                      },
                      isPassword: true,
                        isError:isError,
                      controller: passwordController,
                    ),

                  ),
                  40.verticalSpace,
                  FadeInSlide(
                    duration: 0.8,
                    child: Padding(
                      padding: 23.padHorizontal,
                      child: LoginButton(
                        onTap: (){
                          if(loginFormKey.currentState!.validate()){
                            cubit.login(context: context);
                          }
                        },
                        gradiantColor: AppColors.loginGradiantColorButton ,
                        tapedGradiantColor: AppColors.loginGradiantColorButtonTaped ,
                        text: S.of(context).Login,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}