// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kanisaapp/usajili/screens/improved_registration.dart';

class RegistrationPageScreen extends StatelessWidget {
  const RegistrationPageScreen({super.key});
  static const routeName = "/registrationpagescreen";

  @override
  Widget build(BuildContext context) {
    // Redirect to the improved registration screen
    return const RegistrationScreen();
  }
}

// Keep the AlwaysDisabledFocusNode class for compatibility
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
