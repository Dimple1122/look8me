import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:look8me/common/utils/common_widgets.dart';
import 'package:look8me/common/utils/enums.dart';
import 'package:look8me/screens/onboarding/bloc/onboarding_bloc.dart';
import 'package:intl/intl.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    String? nameError;
    String dob = '';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (previous, current) =>
              current is NameErrorEnableState ||
                  current is NameErrorDisableState,
              builder: (context, state) {
                if (state is NameErrorEnableState) {
                  nameError = state.errorText;
                }
                else {
                  nameError = null;
                }
                return CommonWidget.getCredentialTextField(
                    context: context,
                    label: 'Name',
                    isObscure: false,
                    type: TextFieldType.name,
                    onChanged: (value) => context
                        .read<OnboardingBloc>()
                        .add(NameTFChanged(value)),
                    errorText: nameError);
              }),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white70, width: 1)
            ),
            child: Row(
              children: [
                const SizedBox(width: 2),
                const Icon(IconData(0xe120, fontFamily: 'MaterialIcons'), color: Colors.white70, size: 35),
                const SizedBox(width: 5),
                BlocBuilder<OnboardingBloc, OnboardingState>(builder: (context, state) {
                  return dob.isEmpty ? const Text("What's Your Date of Birth?", style: TextStyle(color: Colors.white70, fontSize: 18)) : Text(dob, style: const TextStyle(color: Colors.white, fontSize: 22));
                })
              ],
            ),
          ),
          const SizedBox(height: 20),
          CupertinoTheme(
            data: const CupertinoThemeData(
              brightness: Brightness.dark,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 200,
                // width: 100,
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  minimumYear: 1900,
                  maximumDate: DateTime.now(),
                  dateOrder: DatePickerDateOrder.dmy,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDateTime) {
                    dob = DateFormat('d MMMM, y').format(newDateTime);
                    context.read<OnboardingBloc>().add(DobChanged(dob));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
