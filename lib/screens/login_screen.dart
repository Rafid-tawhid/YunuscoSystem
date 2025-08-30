import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/auth_provider.dart';
import 'package:yunusco_group/screens/home_page.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../common_widgets/text_fields.dart';
import '../helper_class/dashboard_helpers.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    _emailCon.dispose();
    _passCon.dispose();
    super.dispose();
  } //nbn2-min.png

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              'assets/images/nbn2-min.png',
            ),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Title
                  Image.asset('assets/images/icon.png', height: 140, width: 140),
                  const SizedBox(height: 20),
                  Text("Welcome to ERP", style: AppConstants.customTextStyle(18, Colors.white, FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Sign in to continue", style: AppConstants.customTextStyle(18, Colors.white.withOpacity(0.8), FontWeight.w600)),
                  const SizedBox(height: 40), // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Field
                        CustomTextFormField(
                          controller: _emailCon,
                          labelText: "Username",
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20), // Password Field
                        TextFormField(
                          obscureText: _obscurePassword,
                          controller: _passCon,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white54)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10), // Forgot Password
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: AppConstants.customTextStyle(12, Colors.white.withOpacity(.7), FontWeight.w400),
                                ))),
                        const SizedBox(height: 30), // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: Consumer<AuthProvider>(
                            builder: (context, provider, _) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (await provider.login(
                                    _emailCon.text.trim(),
                                    _passCon.text.trim(),
                                  )) {
                                    DashboardHelpers.setString('email', _emailCon.text.trim());
                                    DashboardHelpers.setString('pass', _passCon.text.trim());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Login Successful")),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Login Unsuccessful")),
                                    );
                                  }
                                }
                              },
                              child: provider.isLoading
                                  ? const CircularProgressIndicator(color: Colors.black)
                                  : Text(
                                      "Login",
                                      style: AppConstants.customTextStyle(16, myColors.primaryColor, FontWeight.w600),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Sign Up Link
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Don't have an account?", style: AppConstants.customTextStyle(12, Colors.white.withOpacity(.7), FontWeight.w400))]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getUserInfo() async {
    String email = await DashboardHelpers.getString('email');
    String pass = await DashboardHelpers.getString('pass');
    if (email != '' && pass != '') {
      setState(() {
        _emailCon.text = email;
        _passCon.text = pass;
      });
    }
  }
}
