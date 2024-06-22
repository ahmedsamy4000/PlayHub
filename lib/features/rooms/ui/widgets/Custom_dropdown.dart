import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:playhub/core/app_colors.dart';
import 'package:playhub/core/padding.dart';
import 'package:searchfield/searchfield.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final focus = FocusNode();
  final String hint;
  final List<Color> colors;
  final ValueNotifier<bool> isVisible = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorText = ValueNotifier<String?>(null);
  final bool isError;
   CustomDropdown({
    required this.items, required this.hint, required this.colors, required this.searchController, required this.isError,
  });
  final TextEditingController searchController;
  String? validator(String? value) {
    if (value == null || !items.contains(value.trim())) {
      return 'Enter a valid value';
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {
    Widget searchChild(x) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Text(x, style: TextStyle(fontSize: 18, color: AppColors.white)),
    );
    if(isError){
      errorText.value = validator.call(searchController.text??"");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                return SearchField(
                  onSearchTextChanged: (query) {
                    final filter = items
                        .where((element) =>
                        element.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                    return filter
                        .map((e) =>
                        SearchFieldListItem<String>(e, child: searchChild(e)))
                        .toList();
                  },
                  controller: searchController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  hint: hint,
                  itemHeight: 50.h,
                  onTapOutside: (x) {
                    focus.unfocus();
                  },
                  scrollbarDecoration: ScrollbarDecoration(
                    thickness: 12,
                    radius: Radius.circular(6),
                    trackColor: Colors.grey,
                    trackBorderColor: Colors.red,
                    thumbColor: AppColors.white,
                  ),
                  suggestionStyle:
                  const TextStyle(fontSize: 18, color: AppColors.white),
                  searchStyle: TextStyle(fontSize: 18, color: AppColors.black),
                  suggestionItemDecoration: BoxDecoration(
                    // color: Colors.grey[100],
                    // borderRadius: BorderRadius.circular(10),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  searchInputDecoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                  ),
                  suggestionsDecoration: SuggestionDecoration(
                    // border: Border.all(color: Colors.orange),
                      elevation: 8.0,
                      selectionColor: Colors.grey.shade100,
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  suggestions: items
                      .map((e) =>
                      SearchFieldListItem<String>(e, child: searchChild(e)))
                      .toList(),
                  focusNode: focus,
                  suggestionState: Suggestion.expand,
                );
              }
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: errorText,
          builder: (context, error, child) {
            return error == null
                ? SizedBox.shrink()
                : Padding(
              padding:25.padHorizontal,
              child: Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            );
          },
        ),

      ],
    );
  }
}


