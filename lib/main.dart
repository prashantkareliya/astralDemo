import 'package:anstraldemo/registration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

InputDecoration kTextFieldDecoration = InputDecoration(
    labelText: 'Enter value',
    hintText: 'Enter value',
    labelStyle: GoogleFonts.poppins(color: Colors.grey.shade300, fontWeight: FontWeight.w400),
    hintStyle: GoogleFonts.poppins(color: Colors.grey.shade300, fontWeight: FontWeight.w400),
    enabledBorder: OutlineInputBorder(
        borderSide:  BorderSide(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8.0) // Border radius
    ),
    focusedBorder: OutlineInputBorder(
        borderSide:  BorderSide(color: Colors.grey.shade300, width: 1), borderRadius: BorderRadius.circular(8.0)),
    errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1), borderRadius: BorderRadius.circular(8.0)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1), borderRadius: BorderRadius.circular(8.0)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18));
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;

  @override
  void initState() {
    isCheckLogin();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    mobileController.dispose();
    passwordController.dispose();
  }

  bool showSpinner = false;

  isCheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("mobile") != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } /*else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
    }*/
  }
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: const CircularProgressIndicator(),
        child: Form(
          key: _formKey,
          autovalidateMode: _validate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: "Mobile",
                    labelText: "Mobile",
                  ),
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ⓘ Please enter your mobile number";
                    } else if (mobileController.text.length < 10) {
                      return "ⓘ Enter valid mobile number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Password",
                      labelText: "Password",

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "ⓘ Please enter correct password";
                      }
                      return null;
                    }),
                const SizedBox(height: 15),
                SizedBox(
                    width: query.width,
                    height: 60,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _validate = true;
                          showSpinner =
                          _formKey.currentState!.validate()
                              ? true
                              : false;
                        });
                        if (_formKey.currentState!.validate()){
                          setState(() {
                            showSpinner = false;
                          });
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("mobile", mobileController.text);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                        }
                      },
                      child: const Text('Submit'),
                    )),
                const SizedBox(height: 35),

              ],
            ),
          ),
        ),
      ),
    );
  }
}