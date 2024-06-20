import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/authentication/ui/widgets/login_custom_textfield.dart';
import 'package:playhub/features/authentication/ui/widgets/login_divider.dart';

class EditInformationScreen extends StatelessWidget {
  const EditInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getCurrentUserData();
    TextEditingController nameController = TextEditingController();
    nameController.text = cubit.userData['Name'];
    TextEditingController emailController = TextEditingController();
    emailController.text = cubit.userData['Email'];
    TextEditingController phoneController = TextEditingController();
    phoneController.text = cubit.userData['PhoneNumber'];
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text(
            'Edit Information',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<AppCubit, AppStates>(
          builder: (context, state) => state is GetCurrentUserLoadingState
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: nameController,
                                label: 'Full Name',
                                validator: Validator.validateName,
                                keyboardType: TextInputType.text,
                              ),
                              30.verticalSpace,
                              CustomTextFormField(
                                controller: emailController,
                                label: 'Email',
                                validator: Validator.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              30.verticalSpace,
                              CustomTextFormField(
                                controller: phoneController,
                                label: 'Phone',
                                validator: Validator.validatePhoneNumber,
                                inputFormatter:
                                    FilteringTextInputFormatter.digitsOnly,
                                keyboardType: TextInputType.phone,
                              ),
                              35.verticalSpace,
                              Padding(
                                padding: 23.padHorizontal,
                                child: LoginButton(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit
                                          .updateUserInfo(
                                              name: nameController.text,
                                              phone: phoneController.text,
                                              email: emailController.text)
                                          .then((_) {
                                        if (cubit.state
                                            is UpdateUserInfoSuccessState) {
                                              cubit.getCurrentUserData();
                                          Navigator.pop(context);
                                        }
                                      });
                                    }
                                  },
                                  gradiantColor:
                                      AppColors.loginGradiantColorButton,
                                  tapedGradiantColor:
                                      AppColors.loginGradiantColorButtonTaped,
                                  text: "Update",
                                ),
                              ),
                              20.verticalSpace,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
