// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key:key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  //final _ageController = TextEditingController();

  bool isPasswordValid = false;
  String passwordValidationMessage = '';

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    //_ageController.dispose();
    super.dispose();
  }  

  Future signUp() async{
    // Check if password meets requirements and passwords match
    if (isPasswordValid && passwordConfirmed()) {
      try {
        // Authenticate user
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim(),
        );

        // If user creation is successful, add user details
        if (userCredential.user != null) {
          await addUserDetails(
            _firstNameController.text.trim(), 
            _lastNameController.text.trim(), 
            _emailController.text.trim(), 
            _passwordController.text.trim(),
            //int.parse(_ageController.text.trim()),
          );
          // Navigate to next screen or perform necessary actions after successful sign up
        }
      } catch (error) {
        // Handle any errors that occur during sign up process
        print("Error during sign up: $error");
      }
    } else {
      // Show error message or handle password validation failure
      print("Password does not meet requirements or passwords do not match.");
    }
  }

  Future addUserDetails(String firstName, String lastName, String email, String password) async{
    //because the collection was manually created in firestore
    //it will automatically create a collection if it nothing exists
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
        'first name': firstName,
        'last name' : lastName,
        'email' : email,
        'password' : password,
        //'age' : age,
      });
    } else {
      print('No user is currently authenticated.');
    }

  }

  bool passwordConfirmed(){
    if (_passwordController.text.trim() == _confirmpasswordController.text.trim()){
      return true;
    } else {
      return false;
    }
  }

  void validatePassword(String passwordToValidate) {
    String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{15,}$';
    RegExp regExp = RegExp(pattern);
    setState(() {
      isPasswordValid = regExp.hasMatch(passwordToValidate);
      if (!isPasswordValid) {
        passwordValidationMessage =
            'Password must be at least 15 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
      } else {
        passwordValidationMessage = 'Password looks good!';
      }
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_information,
                      size: 100,
                    ),
                    SizedBox(height: 45),
                    //Welcome back!
                    Text(
                      'Hello There!',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Register below with your details!',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
              
                    SizedBox(height: 40),
              
                    //first name textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'First Name',
                            ),
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 10),
              
                    //last name textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Last Name',
                            ),
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 10),

                    /* 
                    //age textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _ageController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Age',
                            ),
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 10),
                    */
              
                    //email textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 10),
              
                    //password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            children: [TextField(
                              controller: _passwordController,
                              obscureText: true, //makes the password obscure
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                              ),
                              onChanged: (value) => validatePassword(value), //validates the password
                            ),
                            ],
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 10),
              
                    //password requirements
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Validation Message
                          Expanded(
                            child: Text(
                              passwordValidationMessage,
                              style: TextStyle(
                                color: isPasswordValid ? Colors.green : Colors.red, // Change color based on validation
                              ),
                            ),
                          ),
                          // Validation Icon
                          Icon(
                            isPasswordValid ? Icons.check : Icons.close, // Show check or cross icon
                            color: isPasswordValid ? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
              
                    SizedBox(height: 20),
              
                    //confirm password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[50],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _confirmpasswordController,
                            obscureText: true, //makes the password obscure
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                            ),
                            onChanged: (value) => validatePassword(value),
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 10),
          
                    //password match message
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Validation Message
                          Expanded(
                            child: Text(
                              //passwordValidationMessage,
                              passwordConfirmed()? 'The passwords match.' : 'The passwords must match.',
                              style: TextStyle(
                                color: passwordConfirmed()? Colors.green : Colors.red, // Change color based on validation
                              ),
                            ),
                          ),
                          // Validation Icon
                          Icon(
                            passwordConfirmed()? Icons.check : Icons.close, // Show check or cross icon
                            color: passwordConfirmed()? Colors.green : Colors.red,
                          ),
                        ],
                      ),
                    ),
              
                    SizedBox(height: 20),
              
                    //signin button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: signUp,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(height: 25),
              
                    //already a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                          child: Text(
                            ' Login now', 
                            style: TextStyle(
                              color: Colors.blue, 
                              fontWeight: FontWeight.bold,
                            )
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ), 
      ),
    );
  }
}
