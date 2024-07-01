import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isError = false;
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    // cubit.playgroundImage = null;
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: AppColors.greenBackground,
            appBar: AppBar(
              backgroundColor: AppColors.greenBackground,
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
              builder: (context, state) => state
                      is PickPlaygroundImageLoadingState
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
                                    validator: Validator.notEmpty,
                                    controller: cubit.nameController,
                                    label: 'Playground Name',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomDropdown(
                                    items: categories,
                                    hint: "Category",
                                    colors: AppColors.loginGradiantColorButton,
                                    searchController: cubit.categoryController,
                                    isError: isError,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    validator: Validator.notEmpty,
                                    controller: cubit.cityController,
                                    label: 'City',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    validator: Validator.notEmpty,
                                    controller: cubit.regionController,
                                    label: 'Region',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  CustomTextFormField(
                                    validator: Validator.notEmpty,
                                    controller: cubit.locationController,
                                    label: 'Location',
                                    keyboardType: TextInputType.text,
                                  ),
                                  30.verticalSpace,
                                  GestureDetector(
                                    onTap: () {
                                      cubit.pickPlaygroundImageFromGallery();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.add_photo_alternate_rounded,
                                            size: 35,
                                            color: AppColors.darkGreen,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'Add Image',
                                              style: TextStyle(
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                          cubit.playgroundImage != null
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.topRight,
                                                    children: [
                                                      Image.network(
                                                        cubit.playgroundImage!,
                                                        width: 200,
                                                        height: 200,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 16.0,
                                                                left: 32),
                                                        child: IconButton(
                                                            onPressed: () {
                                                              cubit
                                                                  .removeSelectedPlaygroundImage();
                                                            },
                                                            icon: const Icon(
                                                                Icons.close)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  35.verticalSpace,
                                  Padding(
                                    padding: 23.padHorizontal,
                                    child: LoginButton(
                                      onTap: () {
                                        if (formKey.currentState!.validate() &&
                                            cubit.playgroundImage != null) {
                                          cubit
                                              .addNewPlayground(
                                                  name:
                                                      cubit.nameController.text,
                                                  category: cubit
                                                      .categoryController.text,
                                                  city:
                                                      cubit.cityController.text,
                                                  region: cubit
                                                      .regionController.text,
                                                  image: cubit.playgroundImage,
                                                  location: cubit
                                                      .locationController.text)
                                              .then((_) {
                                            if (cubit.state
                                                is AddNewPlaygroundSuccessState) {
                                              cubit.getOwnerPlaygrounds();
                                              Navigator.pop(context);
                                              cubit.playgroundImage = null;
                                              cubit.nameController.text = '';
                                              cubit.categoryController.text =
                                                  '';
                                              cubit.cityController.text = '';
                                              cubit.regionController.text = '';
                                              cubit.locationController.text =
                                                  '';
                                            }
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                'You must enter all of the data',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: AppColors.red,
                                            textColor: AppColors.white,
                                          );
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
