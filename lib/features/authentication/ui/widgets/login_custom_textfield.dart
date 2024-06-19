import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';

class CustomTextFormField extends StatelessWidget {
   CustomTextFormField({
    super.key, this.hint, this.label, this.value, required this.validator, this.keyboardType, this.inputFormatter, this.onChanged, this.isPassword=false,
  });
  final String? hint;
  final String? label;
  final String? value;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;
  final Function(String)? onChanged;
  final bool isPassword;
  final ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: 19.padHorizontal,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            offset: Offset(3, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: Offset(-1, -1),
          ),
        ],
      ),
      child:  ValueListenableBuilder<bool>(
          valueListenable: isVisible,
          builder: (context, isVisiblee, child) {
          return TextFormField(
            initialValue: value,
            obscureText: isPassword ? !isVisiblee : false,
            onChanged: onChanged,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters:inputFormatter==null? null:[
              inputFormatter!
            ],
            decoration: InputDecoration(
              hintText:hint,
              labelText: label,
              suffixIcon: (isPassword!=null&&isPassword==true)?IconButton(
                  onPressed: (){
                    isVisible.value=!isVisiblee;
                  },
                  icon: isVisiblee?Icon(Icons.remove_red_eye_outlined):Icon(Icons.remove_red_eye_rounded),
              ):null,
              hintStyle: TextStyle(
                  color: AppColors.grey
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            ),
          );
        }
      ),
    );
  }
}
