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
import 'package:playhub/features/rooms/data/playground_model.dart';
import 'package:playhub/features/rooms/ui/widgets/Custom_dropdown.dart';

class UpdatePlaygroundScreen extends StatelessWidget {
  UpdatePlaygroundScreen(
      {super.key,
      required this.playground,
      required this.categories,
      required this.id});
  final Playground playground;
  List<String> categories;
  bool isError = false;
  String id;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var cubit = BlocProvider.of<AppCubit>(context);
    TextEditingController nameController = TextEditingController();
    nameController.text = playground.name;
    TextEditingController categoryController = TextEditingController();
    categoryController.text = playground.name;
    TextEditingController cityController = TextEditingController();
    cityController.text = playground.city;
    TextEditingController regionController = TextEditingController();
    regionController.text = playground.region;
    cubit.playgroundImage = playground.image;
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text(
            'Update Playground',
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
                              GestureDetector(
                                onTap: () {
                                  cubit.pickPlaygroundImageFromGallery();
                                },
                                child: Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          'Update Image',
                                          style: TextStyle(
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      cubit.playgroundImage != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Image.network(
                                                    cubit.playgroundImage!,
                                                    width: 150.w,
                                                    height: 200,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                    if (formKey.currentState!.validate()) {
                                      cubit
                                          .updatePlayground(
                                              name: nameController.text,
                                              category: categoryController.text,
                                              city: cityController.text,
                                              region: regionController.text,
                                              image: cubit.playgroundImage,
                                              pid: id)
                                          .then((_) {
                                        if (cubit.state
                                            is UpdatePlaygroundSuccessState) {
                                          cubit.getOwnerPlaygrounds();
                                          Navigator.pop(context);
                                          cubit.playgroundImage = null;
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
