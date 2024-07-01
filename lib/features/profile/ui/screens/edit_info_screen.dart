import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/Layout/MainApp.dart';
import 'package:playhub/common/data/local/local_storage.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/enums/type_enum.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/authentication/ui/widgets/login_custom_textfield.dart';
import 'package:playhub/features/authentication/ui/widgets/login_divider.dart';
import 'package:playhub/generated/l10n.dart';

class EditInformationScreen extends StatelessWidget {
  const EditInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var cubit = BlocProvider.of<AppCubit>(context);
    cubit.getCurrentUserData();
    var userData = LocalStorage().userData;
    TextEditingController nameController = TextEditingController();
    nameController.text = userData?.fullName ?? '';
    TextEditingController emailController = TextEditingController();
    emailController.text = userData?.email ?? '';
    TextEditingController phoneController = TextEditingController();
    phoneController.text = userData?.phoneNumber ?? '';
    TextEditingController cityController = TextEditingController();
    cityController.text = userData?.city ?? '';
    TextEditingController regionController = TextEditingController();
    regionController.text = userData?.region ?? '';
    return Scaffold(
        backgroundColor: AppColors.greenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.greenBackground,
          title: Text(
            S.of(context).pop1,
            style: const TextStyle(
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
                                label: S.of(context).Name,
                                validator: Validator.validateName,
                                keyboardType: TextInputType.text,
                              ),
                              30.verticalSpace,
                              CustomTextFormField(
                                controller: emailController,
                                label: S.of(context).Email,
                                validator: Validator.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              30.verticalSpace,
                              CustomTextFormField(
                                controller: phoneController,
                                label: S.of(context).Phone,
                                validator: Validator.validatePhoneNumber,
                                inputFormatter:
                                    FilteringTextInputFormatter.digitsOnly,
                                keyboardType: TextInputType.phone,
                              ),
                              30.verticalSpace,
                              CustomTextFormField(
                                controller: cityController,
                                label: S.of(context).City,
                                keyboardType: TextInputType.text,
                              ),
                              30.verticalSpace,
                              CustomTextFormField(
                                controller: regionController,
                                label: S.of(context).Region,
                                keyboardType: TextInputType.text,
                              ),
                              35.verticalSpace,
                              Padding(
                                padding: 23.padHorizontal,
                                child: LoginButton(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      cubit
                                          .updateUserInfo(
                                              name: nameController.text,
                                              phone: phoneController.text,
                                              email: emailController.text,
                                              city: cityController.text,
                                              region: regionController.text)
                                          .then((_) {
                                        if (cubit.state
                                            is UpdateUserInfoSuccessState) {
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Main()));
                                          userData?.type == UserType.player || userData?.type == UserType.admin  ?
                                                    cubit.changeScreenIdx(3) : cubit.changeScreenIdx(2);
                                        }
                                      });
                                    }
                                  },
                                  gradiantColor:
                                      AppColors.loginGradiantColorButton,
                                  tapedGradiantColor:
                                      AppColors.loginGradiantColorButtonTaped,
                                  text: S.of(context).Update,
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
