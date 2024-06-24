import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

class AddPlaygroundScreen extends StatelessWidget {
  AddPlaygroundScreen({super.key, required this.categories});
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  bool isError = false;
  List<String> categories;

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
                'Add Playground',
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
                                    label: 'Playground Name',
                                    validator: Validator.validateName,
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomDropdown(
                                    items: categories,
                                    hint: "Category",
                                    colors: AppColors.loginGradiantColorButton,
                                    searchController: categoryController,
                                    isError: isError,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    controller: cityController,
                                    label: 'City',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    controller: regionController,
                                    label: 'Region',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  cubit.playgroundImage != null
                                      ? Image.network(
                                          cubit.playgroundImage!,
                                          width: 100,
                                          height: 100,
                                        )
                                      : Container(),
                                  ElevatedButton(
                                      onPressed: () {
                                        cubit.pickPlaygroundImageFromGallery();
                                      },
                                      child: const Text('Pick an image')),
                                  35.verticalSpace,
                                  Padding(
                                    padding: 23.padHorizontal,
                                    child: LoginButton(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.addNewPlayground(
                                              name: nameController.text,
                                              category: categoryController.text,
                                              city: cityController.text,
                                              region: regionController.text,
                                              image: cubit.playgroundImage);
                                          // cubit
                                          //     .updateUserInfo(
                                          //         name: nameController.text,
                                          //         phone: phoneController.text,
                                          //         email: emailController.text,
                                          //         city: cityController.text,
                                          //         region: regionController.text)
                                          //     .then((_) {
                                          //   if (cubit.state
                                          //       is UpdateUserInfoSuccessState) {
                                          //     cubit.getCurrentUserData();
                                          //     Navigator.pop(context);
                                          //   }
                                          // });
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
