import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

DateTime currentDate = DateTime.now();

class ReturndateCubit extends Cubit<DateTime> {
  ReturndateCubit() : super(currentDate);

  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: state,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != state) {
      FocusScope.of(context).unfocus();
      emit(pickedDate);
    }
  }
}
