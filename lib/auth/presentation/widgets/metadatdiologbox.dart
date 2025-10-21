import 'package:fluentnow/auth/businesse_logic/cubit/auth_cubit.dart';
import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetaDataDialog extends StatefulWidget {
  final User user;
  const MetaDataDialog({super.key, required this.user});

  @override
  State<MetaDataDialog> createState() => MetaDataDialogState();
}

class MetaDataDialogState extends State<MetaDataDialog> {
  late String username;
  late String phoneNumber;
  final TextEditingController birthdaycontroller = TextEditingController();
  String gender = 'male';
  final _formKey = GlobalKey<FormState>();

  Widget buildUsernameField() {
    return BlocProvider(
      create: (context) => UsernameValidationCubit(),
      child: Builder(
        builder: (context) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Mycolors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Mycolors.primary, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }

              final state = context.read<UsernameValidationCubit>().state;
              if (state is UsernameValidationSuccess && state.usernameExists) {
                return 'Username already taken';
              }
              return null;
            },
            onChanged: (value) {
              username = value;
              if (value.isNotEmpty) {
                context.read<UsernameValidationCubit>().checkUsernameExist(
                  value,
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildDateOfBirthField() {
    return TextFormField(
      readOnly: true,
      controller: birthdaycontroller,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        hintText: 'DD-MM-YYYY',
        labelStyle: TextStyle(color: Mycolors.textSecondary),
        suffixIcon: Icon(Icons.calendar_today, color: Mycolors.textSecondary),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Mycolors.primary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Mycolors.primary, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your date of birth';
        }
        return null;
      },
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          lastDate: DateTime(2010),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Mycolors.primary,
                  onPrimary: Colors.white,
                  onSurface: Mycolors.textPrimary,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          birthdaycontroller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        }
      },
    );
  }

  Widget buildPhoneNumberField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'e.g. +213 ',
        labelStyle: TextStyle(color: Mycolors.textSecondary),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Mycolors.primary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Mycolors.primary, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
      onChanged: (value) => phoneNumber = value,
    );
  }

  Widget buildGenderSelector() {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Mycolors.textSecondary, // Unselected radio color
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return Mycolors.primary;
            }
            return Mycolors.textSecondary;
          }),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(color: Mycolors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Male',
                    style: TextStyle(color: Mycolors.textPrimary),
                  ),
                  value: 'male',
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value!),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Female',
                    style: TextStyle(color: Mycolors.textPrimary),
                  ),
                  value: 'female',
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value!),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserCubit, UpdateUserState>(
      listener: (context, state) {
        if (state is UpdateUserSuccess) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, homeNavigationScreen);
        } else if (state is UpdateUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Mycolors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: AlertDialog(
        backgroundColor: Mycolors.cardPanel,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Complete your profile',
          style: TextStyle(
            color: Mycolors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildUsernameField(),
                const SizedBox(height: 16),
                buildDateOfBirthField(),
                const SizedBox(height: 16),
                buildPhoneNumberField(),
                const SizedBox(height: 16),
                buildGenderSelector(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Mycolors.textSecondary),
            ),
          ),
          BlocBuilder<UpdateUserCubit, UpdateUserState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2196F3), // Primary blue (Material blue 500)
                      Color(0xFF00BCD4),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final birthday = DateFormat('yyyy-MM-dd').format(
                        DateFormat('dd-MM-yyyy').parse(birthdaycontroller.text),
                      );
                      BlocProvider.of<UpdateUserCubit>(
                        context,
                      ).updateUser(gender, phoneNumber, birthday, username);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent, // Remove default shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    elevation: 2,
                  ),
                  child:
                      state is UpdateUserLoading
                          ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          )
                          : Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
