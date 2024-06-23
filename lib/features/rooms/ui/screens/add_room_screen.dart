import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:playhub/core/validator.dart';
import 'package:playhub/features/rooms/cubits/rooms_cubit.dart';
import 'package:playhub/features/rooms/cubits/rooms_states.dart';

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
      create: (context) => RoomsCubit()..getPlaygrounds(),
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
          appBar: AppBar(),
          body: Padding(
            padding: 10.padAll,
            child: SingleChildScrollView(
              child: Form(
                key: creationFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hint: "Date",
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
                      hint: "Enter playground",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: playgroundSearchController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomDropdown(
                      items: hours,
                      hint: "Enter time of match",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: hoursSearchController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomDropdown(
                      items: levels,
                      hint: "Enter match's level",
                      colors: AppColors.loginGradiantColorButton,
                      searchController: levelSearchController,
                      isError: isError,
                    ),
                    20.verticalSpace,
                    CustomTextFormField(
                      hint: "Category",
                      keyboardType: TextInputType.text,
                      onChanged: cubit.setCategory,
                      validator: Validator.notEmpty,
                      controller: categoryController,
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
                    LoginButton(
                      onTap: (){
                        if(cubit.checkValidation(
                            playground: playgroundSearchController.text,
                            date: dateController.text,
                            time: timeController.text,
                            period: hoursSearchController.text,
                            level: levelSearchController.text
                        )){
                          context.read<RoomsCubit>().createRoom(
                              playground: playgroundSearchController.text,
                              date: dateController.text,
                              time: timeController.text,
                              period: hoursSearchController.text,
                              level: levelSearchController.text
                          );
                        }
                      },
                      text: "Create Room",
                      tapedGradiantColor: AppColors.loginGradiantColorButtonTaped,
                      gradiantColor: AppColors.loginGradiantColorButton,
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


