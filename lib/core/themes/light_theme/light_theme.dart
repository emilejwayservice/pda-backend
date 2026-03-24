



import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

ThemeData lightTheme=ThemeData(

  textSelectionTheme: const TextSelectionThemeData(
      selectionColor: AppColors.primaryColor,
      selectionHandleColor: AppColors.primaryColor,
      cursorColor: AppColors.primaryColor
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: AppColors.scaffoldColor,
    hourMinuteShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    hourMinuteTextColor: Colors.white,
    hourMinuteColor: AppColors.secondaryColor,
    dialHandColor: AppColors.secondaryColor,
    dialBackgroundColor: AppColors.secondaryColor.withOpacity(0.1),
    entryModeIconColor: AppColors.secondaryColor,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    dayBackgroundColor:MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return AppColors.primaryColor;
      }
    }),
    dayStyle: GoogleFonts.acme(),
    headerHeadlineStyle: GoogleFonts.acme(),
    headerHelpStyle: GoogleFonts.acme(),
    rangePickerHeaderHeadlineStyle: GoogleFonts.acme(),
    rangePickerHeaderHelpStyle: GoogleFonts.acme(),
    yearBackgroundColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return AppColors.primaryColor;
      }
    }),
    yearForegroundColor:  MaterialStateProperty.resolveWith((states){
      return Colors.black;
    }),
    yearStyle: GoogleFonts.acme(),
    headerBackgroundColor: AppColors.calendarScaffoldColor.withOpacity(0.5),
    headerForegroundColor: Colors.black,
    todayForegroundColor:MaterialStateProperty.resolveWith((states) => Colors.white),
    todayBackgroundColor: MaterialStateProperty.resolveWith((states){
      return AppColors.primaryColor.withOpacity(0.5);
    }),
    weekdayStyle: GoogleFonts.acme(),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor)
  ),

);



