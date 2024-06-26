import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/features/rooms/cubits/rooms_cubit.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';

import '../../../../Layout/MainApp.dart';
import '../../../../cubit/app_cubit.dart';
import '../../../authentication/ui/widgets/custom_login_button.dart';
import '../../../authentication/ui/widgets/login_custom_textfield.dart';
import '../widgets/Custom_dropdown.dart';

class AddRoomScreen extends StatelessWidget {
  final List<String> hours=["1 Hour","2 Hours","3 Hours","4 Hours","5 Hours"];
  final List<String> levels=["Advanced","Intermediate","Beginner"];
  List<String> playgrounds = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController playersNumController = TextEditingController();
  TextEditingController playgroundSearchController = TextEditingController();
  TextEditingController hoursSearchController = TextEditingController();
  TextEditingController levelSearchController = TextEditingController();
  final creationFormKey=GlobalKey<FormState>();
  bool isError=false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsCubit()..getPlaygrounds()..getAllCategory(),
      child: BlocBuilder<RoomsCubit, RoomsStates>(
          builder: (context, state) {
        if (state is DateChangeState) {
          dateController.text = state.playDate;
        }
        if (state is TimeChangeState) {
          timeController.text = state.playTime;
        }
        if (state is GetPlaygroundDataState) {
          playgrounds = state.playgrounds;
        }
        if (state is CreateRoomsErrorState) {
          isError=true;
        }
        var cubit=context.read<RoomsCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Room Details"
            ),
          ),
          body: Container(
            padding: 10.padAll,
            margin: 10.padTop,
            child: SingleChildScrollView(
              child: Form(
                key: creationFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hint: "Date",
                      prefixIcon: Padding(
                        padding: 10.padRight,
                        child: Icon(Icons.date_range_outlined,color: AppColors.darkGreen,),
                      ),
                      controller: dateController,
                      validator: Validator.notEmpty,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          context.read<RoomsCubit>().pickDate(selectedDate);
                        }
                      },
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomTextFormField(
                      hint: "Time",
                      prefixIcon: Padding(
                        padding: 10.padRight,
                        child: Icon(Icons.timer,color: AppColors.darkGreen,),
                      ),
                      validator: Validator.notEmpty,
                      controller: timeController,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          cubit.pickTime(selectedTime); // Assuming pickDate accepts TimeOfDay
                        }
                      },
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomDropdown(
                      items: playgrounds,
                      hint: "Playground",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: playgroundSearchController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomDropdown(
                      items: hours,
                      hint: "Time of match",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: hoursSearchController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomDropdown(
                      items: levels,
                      hint: "Match level",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: levelSearchController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomDropdown(
                      items: cubit.categories,
                      hint: "Category",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: categoryController,
                      isError: isError,

                    ),
                    20.verticalSpace,
                    CustomTextFormField(
                      hint: "Region",
                      keyboardType: TextInputType.text,
                      onChanged: cubit.setCity,
                      validator: Validator.notEmpty,
                      controller: cityController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomTextFormField(
                      hint: "Number of players",
                      validator: Validator.validatePositiveNumber,
                      keyboardType: TextInputType.number,
                      onChanged: cubit.setPlayersNum,
                      controller: playersNumController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomTextFormField(
                      hint: "Comment.....",
                      keyboardType: TextInputType.text,
                      onChanged: cubit.setComment,
                      validator: Validator.notEmpty,

                    ),
                    20.verticalSpace,
                    Padding(
                      padding: 16.padHorizontal,
                      child: LoginButton(
                        onTap: (){
                          if(cubit.checkValidation(
                              playground: playgroundSearchController.text,
                              date: dateController.text,
                              time: timeController.text,
                              period: hoursSearchController.text,
                              level: levelSearchController.text,
                            category:categoryController.text
                          )){
                            log("validaate");
                            context.read<RoomsCubit>().createRoom(
                                playground: playgroundSearchController.text,
                                date: dateController.text,
                                time: timeController.text,
                                period: hoursSearchController.text,
                                level: levelSearchController.text,
                                category:categoryController.text
                            ).then((_){
                              if(context.read<RoomsCubit>().state is createRoomSuccessfully) {
                                Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=> Main()) );
                                BlocProvider.of<AppCubit>(context).changeScreenIdx(1);
                              }
                              //Navigator.pop(context);
                            });
                          }
                        },
                        text: "Create Room",
                        tapedGradiantColor: AppColors.loginGradiantColorButtonTaped,
                        gradiantColor: AppColors.loginGradiantColorButton,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}


