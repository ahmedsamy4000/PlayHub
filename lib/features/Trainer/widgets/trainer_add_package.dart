import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/cubit/app_cubit.dart';
import 'package:playhub/cubit/states.dart';
import 'package:playhub/features/authentication/ui/widgets/custom_login_button.dart';
import 'package:playhub/features/authentication/ui/widgets/login_custom_textfield.dart';
import 'package:playhub/features/rooms/ui/widgets/Custom_dropdown.dart';

class AddPackage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final String trainerId;

  AddPackage({required this.trainerId});

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              title: const Text(
                'Add Package',
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
                                    controller: descriptionController,
                                    label: 'Package Description',
                                    validator: Validator.validateName,
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    controller: priceController,
                                    validator: Validator.notEmpty,
                                    label: 'Price',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    controller: durationController,
                                    validator: Validator.notEmpty,
                                    label: 'Duration',
                                    keyboardType: TextInputType.text,
                                  ),
                                  35.verticalSpace,
                                  Padding(
                                    padding: 23.padHorizontal,
                                    child: LoginButton(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.addPackage(
                                              descriptionController.text,
                                              double.parse(
                                                  priceController.text),
                                              int.parse(
                                                  durationController.text),
                                              trainerId);
                                          Navigator.pop(context);
                                        }
                                      },
                                      gradiantColor:
                                          AppColors.loginGradiantColorButton,
                                      tapedGradiantColor: AppColors
                                          .loginGradiantColorButtonTaped,
                                      text: "Add",
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
      },
    );
  }
}
