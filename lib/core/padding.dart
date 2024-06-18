import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension CustomPaddingExtensions on num{
  EdgeInsets get padAll => EdgeInsets.all(toDouble());
  EdgeInsets get padHorizontal => EdgeInsets.symmetric(horizontal: toDouble().w);
  EdgeInsets get padVertical => EdgeInsets.symmetric(vertical: toDouble().h);
  EdgeInsets get padTop => EdgeInsets.only(top: toDouble().h);
  EdgeInsets get padBottom => EdgeInsets.only(bottom: toDouble().h);
  EdgeInsets get padLeft => EdgeInsets.only(left: toDouble().w);
  EdgeInsets get padRight => EdgeInsets.only(right: toDouble().w);
}