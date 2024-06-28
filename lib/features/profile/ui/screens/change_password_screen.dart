import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/common/fade_in_slide.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/authentication/ui/widgets/login_custom_textfield.dart';
import 'package:playhub/generated/l10n.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var cubit = BlocProvider.of<AppCubit>(context);
    TextEditingController oldPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          S.of(context).pop2,
          style: const TextStyle(
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInSlide(
              duration: 0.5,
              child: Image.asset('assets/images/password.jpg', width: 280.w, height: 280.h,)
            ),
            30.horizontalSpace,
            Form(
              key: formKey,
              child: Column(
                children: [
                  FadeInSlide(
                    duration: 0.6,
                    child: CustomTextFormField(
                      controller: oldPassController,
                      label: S.of(context).OPassword,
                      validator: Validator.validatePassword,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),
                  ),
                  30.verticalSpace,
                  FadeInSlide(
                    duration: 0.7,
                    child: CustomTextFormField(
                      controller: newPassController,
                      label: S.of(context).NPassword,
                      validator: Validator.validatePassword,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),
                  ),
                  30.verticalSpace,
                  FadeInSlide(
                    duration: 0.8,
                    child: CustomTextFormField(
                      controller: confirmPassController,
                      label: S.of(context).CPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        if (value != newPassController.text) {
                          return 'Passwords doesn\'t match';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      isPassword: true,
                    ),
                  ),
                  35.verticalSpace,
                  Padding(
                    padding: 23.padHorizontal,
                    child: FadeInSlide(
                      duration: 0.9,
                      child: LoginButton(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            cubit.changePassword(context,
                                currentPassword: oldPassController.text,
                                newPassword: newPassController.text);
                          }
                        },
                        gradiantColor: AppColors.loginGradiantColorButton,
                        tapedGradiantColor:
                            AppColors.loginGradiantColorButtonTaped,
                        text: S.of(context).UPassword,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
