import 'package:fluentnow/auth/businesse_logic/cubit/auth_cubit.dart';
import 'package:fluentnow/auth/presentation/widgets/metadatdiologbox.dart';
import 'package:fluentnow/constants/app_theme.dart';
import 'package:fluentnow/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void handleGoogleAuthState(BuildContext context, AuthState state) {
  if (state is AuthError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  } else if (state is MissingUserMetaData) {
    showDialog(
      context: context,
      builder:
          (context) => BlocProvider(
            create: (context) => UpdateUserCubit(),
            child: MetaDataDialog(user: state.user),
          ),
    );
  } else if (state is Authenticated) {
    Navigator.pushReplacementNamed(context, homeNavigationScreen);
  }
}

Widget buildGoogleButton(BuildContext context) {
  return BlocBuilder<SignInWithGoogleCubit, AuthState>(
    builder: (context, state) {
      return Column(
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(fontSize: 14, color: Mycolors.textSecondary),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                BlocProvider.of<SignInWithGoogleCubit>(context).googleSignIn();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                  color: Mycolors.textSecondary.withOpacity(0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  state is AuthLoading
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Mycolors.primary,
                          strokeWidth: 2.0,
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/googleLogo.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Mycolors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      );
    },
  );
}
