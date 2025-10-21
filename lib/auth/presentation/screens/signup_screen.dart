import 'package:fluentnow/auth/businesse_logic/cubit/auth_cubit.dart';
import 'package:fluentnow/auth/presentation/widgets/googlebutton.dart';
import 'package:fluentnow/auth/presentation/widgets/metadatdiologbox.dart';
import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String email;
  late String password;
  late String confirmPassword;
  bool showPassword = true;
  bool showConfirmPassword = true;
  late String username;
  late String phoneNumber;
  final TextEditingController birthdaycontroller = TextEditingController();
  String gender =
      'male'; // Changed from 'sexcontroller' to more inclusive 'gender'
  final _formKey = GlobalKey<FormState>(); // Added for form validation

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, signInScreen);
            },
            child: const Text(
              "Sign In",
              style: TextStyle(
                color: Mycolors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Mycolors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Fill in your details to get started',
          style: TextStyle(fontSize: 14, color: Mycolors.textSecondary),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget buildEmailField() {
    return // In your signup screen
    BlocProvider(
      create: (context) => EmailValidationCubit(),
      child: Builder(
        builder: (context) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Mycolors.primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Mycolors.primary, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }

              // Basic email regex validation
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }

              final state = context.read<EmailValidationCubit>().state;
              if (state is EmailValidationSuccess && state.emailExists) {
                return 'Email already exists';
              }
              return null;
            },
            onChanged: (value) {
              email = value;
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (emailRegex.hasMatch(value)) {
                context.read<EmailValidationCubit>().checkEmailExist(value);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: showPassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          splashRadius: 20,
          onPressed: () => setState(() => showPassword = !showPassword),
          icon: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
            color: Mycolors.textSecondary,
          ),
        ),
        labelText: 'Password',
        hintText: 'At least 6 characters',
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
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onChanged: (value) => password = value,
    );
  }

  Widget buildConfirmPasswordField() {
    return TextFormField(
      obscureText: showConfirmPassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          splashRadius: 20,
          onPressed:
              () => setState(() => showConfirmPassword = !showConfirmPassword),
          icon: Icon(
            showConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Mycolors.textSecondary,
          ),
        ),
        labelText: 'Confirm Password',
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
          return 'Please confirm your password';
        }
        if (value != password) {
          return 'Passwords do not match';
        }
        return null;
      },
      onChanged: (value) => confirmPassword = value,
    );
  }

  Widget buildUsernameField() {
    return // In your signup screen
    BlocProvider(
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

  Widget _buildSignUpButton() {
    return BlocBuilder<SignUpCubit, AuthState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,

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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final birthday = DateFormat('yyyy-MM-dd').format(
                  DateFormat('dd-MM-yyyy').parse(birthdaycontroller.text),
                );

                BlocProvider.of<SignUpCubit>(context).signUp(
                  email,
                  password,
                  username,
                  phoneNumber,
                  birthday,
                  gender,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child:
                state is AuthLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                    : const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        );
      },
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else if (state is Authenticated) {
      Navigator.pushReplacementNamed(context, homeNavigationScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocListener(
        listeners: [
          BlocListener<SignUpCubit, AuthState>(
            listener: (context, state) {
              _handleAuthState(context, state);
            },
          ),
          BlocListener<SignInWithGoogleCubit, AuthState>(
            listener: (context, state) {
              handleGoogleAuthState(context, state);
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Mycolors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    buildHeader(),
                    buildEmailField(),
                    const SizedBox(height: 24),
                    buildPasswordField(),
                    const SizedBox(height: 24),
                    buildConfirmPasswordField(),
                    const SizedBox(height: 24),
                    buildUsernameField(),
                    const SizedBox(height: 24),
                    buildDateOfBirthField(),
                    const SizedBox(height: 24),
                    buildPhoneNumberField(),
                    const SizedBox(height: 24),
                    buildGenderSelector(),
                    const SizedBox(height: 40),
                    _buildSignUpButton(),
                    buildGoogleButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
