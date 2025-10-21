import 'dart:ui';

import 'package:fluentnow/auth/businesse_logic/cubit/auth_cubit.dart';
import 'package:fluentnow/auth/presentation/widgets/googlebutton.dart';
import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool showPassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, signupScreen),
            child: Text(
              "Sign Up",
              style: TextStyle(color: Mycolors.textPrimary, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Mycolors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: TextStyle(fontSize: 14, color: Mycolors.textSecondary),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'your@email.com',
        labelStyle: TextStyle(color: Mycolors.textSecondary),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Mycolors.primary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Mycolors.primary, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onChanged: (value) => email = value,
    );
  }

  Widget _buildPasswordField() {
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
        if (value == null || value.isEmpty) return 'Please enter your password';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
      onChanged: (value) => password = value,
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: Mycolors.primary, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<SignInCubit, AuthState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
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
                BlocProvider.of<SignInCubit>(context).signIn(email, password);
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
                    : Text(
                      'Sign In',
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
          BlocListener<SignInCubit, AuthState>(
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
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    _buildHeader(),
                    _buildEmailField(),
                    const SizedBox(height: 24),
                    _buildPasswordField(),
                    const SizedBox(height: 8),
                    _buildForgotPassword(),
                    const SizedBox(height: 40),
                    _buildSignInButton(),
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
