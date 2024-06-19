import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/authentication/ui/widgets/login_custom_textfield.dart';
import 'package:playhub/features/authentication/ui/widgets/login_divider.dart';

class EditInformationScreen extends StatelessWidget {
  const EditInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var cubit = BlocProvider.of<AppCubit>(context);
    var user = cubit.getCurrentUserData();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Edit Information'),
      ),
      body: FutureBuilder(
        future: user,
        builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>?> snapshot) =>
            snapshot.data == null
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            label: 'Full Name',
                            value: snapshot.data?['Name'],
                            validator: Validator.validateName,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              // cubit.setName(value);
                            },
                          ),
                          30.verticalSpace,
                          CustomTextFormField(
                            label: 'Email',
                            value: snapshot.data?['Email'],
                            validator: Validator.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              // cubit.setEmail(value);
                            },
                          ),
                          30.verticalSpace,
                          CustomTextFormField(
                            label: 'Phone',
                            value: snapshot.data?['PhoneNumber'],
                            validator: Validator.validatePhoneNumber,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              // cubit.setPhone(value);
                            },
                          ),
                          35.verticalSpace,
                          Padding(
                            padding: 23.padHorizontal,
                            child: LoginButton(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  // cubit.registeration(type: type);
                                  Navigator.pop(context);
                                }
                              },
                              gradiantColor: AppColors.loginGradiantColorButton,
                              tapedGradiantColor:
                                  AppColors.loginGradiantColorButtonTaped,
                              text: "Update",
                            ),
                          ),
                          20.verticalSpace,
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
