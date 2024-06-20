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
  final ValueNotifier<String?> selectedPlaygroundNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectedHoursNotifier = ValueNotifier<String?>(null);
  final List<String> hours=["1 Hour","2 Hours","3 Hours","4 Hours","5 Hours"];
  List<String> playgrounds = [];

  @override
  Widget build(BuildContext context) {
    final TextEditingController dateController = TextEditingController();
    return BlocProvider(
      create: (context) => RoomsCubit(),
      child: BlocBuilder<RoomsCubit, RoomsStates>(
          builder: (context, state) {
        if (state is DateChangeState) {
          dateController.text = state.playDate;
        }
        if (state is GetPlaygroundDataState) {
          playgrounds = state.playgrounds;
        }
        return Scaffold(
          body: Padding(
            padding: 15.padAll,
            child: Column(
              children: [
                CustomTextFormField(
                  hint: "Date",
                  controller: dateController,
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
                ),
                20.verticalSpace,
                CustomDropdown(
                  selectedLevelNotifier: selectedPlaygroundNotifier,
                  items: playgrounds,
                  onTap: (){
                    context.read<RoomsCubit>().getPlaygrounds();
                  },
                ),
                20.verticalSpace,
                CustomDropdown(
                  selectedLevelNotifier: selectedHoursNotifier,
                  items: hours,
                ),
                20.verticalSpace,
                CustomTextFormField(
                  hint: "Number of players",
                  validator: Validator.validatePositiveNumber,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                ),
                20.verticalSpace,
                CustomTextFormField(
                  hint: "Comment.....",
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                ),
                20.verticalSpace,
                LoginButton(
                  onTap: (){

                  },
                  text: "Create Room",
                  tapedGradiantColor: AppColors.loginGradiantColorButtonTaped,
                  gradiantColor: AppColors.loginGradiantColorButton,
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}


