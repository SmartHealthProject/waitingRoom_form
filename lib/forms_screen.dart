import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_demo/models/person.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formsKey = GlobalKey<FormState>();

  //final _passwordController = TextEditingController();

  final _person = Person();
  final _dobController = TextEditingController(); // Controller for DOB

  final List<String> _genders = ['Male', 'Female', 'Other']; // Example gender options
  String? _selectedGender; // Variable to hold selected gender

  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed']; // Example marital statuses
  String? _selectedMaritalStatus; // Variable to hold selected marital status

  
  @override
  void dispose() {
    _dobController.dispose(); // Dispose controller when state is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Complete your medical profile', 
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formsKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First Name', 
                      hintText: 'Please fill in your first name', 
                      suffixIcon: Icon(Icons.person)
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'First name is required';
                      }
                      return null;
                    },
                    //onChanged: (value){
                      //debugPrint(value);
                    //},
                    onSaved: (value) => _person.firstName = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Middle Name'),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter N/A if non-applicable.';
                      }
                      return null;
                    },
                    onSaved: (value) => _person.middleName = value, 
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last Name', 
                      hintText: 'Please fill in your last name', 
                      suffixIcon: Icon(Icons.person)
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Last name is required';
                      }
                      return null;
                    },
                    //onChanged: (value){
                      //debugPrint(value);
                    //},
                    onSaved: (value) => _person.lastName = value, 
                  ),

                  TextFormField(
                    controller: _dobController, // Use controller for DOB
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth (DOB)',
                      hintText: 'Select your date of birth',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true, // Make field read-only
                    onTap: () async {
                    // Use DatePicker to get DOB
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        // Format and set DOB in controller
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        _dobController.text = formattedDate;
                      }
                    },
                    //onSaved: (value) => _person.dob = value, 
                  ),

                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Sex',
                      hintText: 'Please indicate your sex',
                    ),
                    items: _genders.map((String gender) {
                      return DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                        setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    validator: (value) => value == null ? 'Please select your sex' : null,
                  ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Marital Status',
                      hintText: 'Please specify your marital status',
                    ),
                    value: _selectedMaritalStatus, // Set the current dropdown value
                    items: _maritalStatuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMaritalStatus = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your marital status';
                      }
                      return null;
                    },
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'SSN',
                      hintText: 'Please fill in your social security number',
                      suffixIcon: Icon(Icons.security),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11), // Limit to 9 digits + 2 hyphen
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final newText = newValue.text.replaceAll('-', '');
                        if (newText.length > 9) return oldValue; // Limit to 9 digits
                        if (newText.length > 5) {
                          final formattedText = '${newText.substring(0, 3)}-${newText.substring(3, 5)}-${newText.substring(5)}';
                          return TextEditingValue(
                            text: formattedText,
                            selection: TextSelection.collapsed(offset: formattedText.length),
                          );
                        } else if (newText.length > 2) {
                          final formattedText = '${newText.substring(0, 3)}-${newText.substring(3)}';
                          return TextEditingValue(
                            text: formattedText,
                            selection: TextSelection.collapsed(offset: formattedText.length),
                          );
                        }
                        return newValue;
                      }),
                    ],
                    validator: (value) {
                      // Regular expression for validating SSN (###-##-####)
                      final ssnRegex = RegExp(r'^\d{3}-\d{2}-\d{4}$');
                      if (value == null || value.isEmpty || !ssnRegex.hasMatch(value)) {
                        return 'Please enter a valid SSN (###-##-####)';
                      }
                      return null;
                    },
                    onSaved: (value) => _person.ssn = value, 
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Primary Doctore Name', 
                      hintText: 'Please fill in your primary doctor name', 
                      //suffixIcon: Icon(Icons.person)
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Primary doctor name is required. Enter N/A if not known.';
                      }
                      return null;
                    },
                    //onChanged: (value){
                      //debugPrint(value);
                    //},
                    onSaved: (value) => _person.primaryDoctorName = value, 
                  ),

                  
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    
                    onPressed: () async {
                      print("Button pressed");
                      if (_formsKey.currentState!.validate()) {
                        _formsKey.currentState!.save();

                        // Prepare the data for saving
                        _person.dob = _dobController.text;
                        _person.gender = _selectedGender;
                        _person.maritalStatus = _selectedMaritalStatus;
                        print("Attempting to save data to Firebase");
                        try {
                          // Reference to Firestore collection
                          final CollectionReference people = FirebaseFirestore.instance.collection('people');

                          // Adding data to Firestore collection
                          await people.add(_person.toMap());
                          print("Data saved successfully");

                          // Show a dialog upon successful submission
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(content: Text('Profile completed. Thank you.'));
                            },
                          );
                          /* 
                          // Reference to the Firebase Realtime Database
                          final dbRef = FirebaseDatabase.instance.ref();

                          // Inserting data into a specific path, here "people". Adjust as needed.
                          await dbRef.child('people').push().set(_person.toMap());
                          print("Data saved successfully");
                          // Show a dialog upon successful submission
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(content: Text('Profile completed. Thank you.'));
                            },
                          );
                          */
                        } catch (error) {
                          // Handle errors more effectively here
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('Failed to complete profile. Error: $error'),
                              );
                            },
                          );
                        }
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ), 
                    child: const Text(
                      'Complete your profile', 
                      style: TextStyle(color: Colors.white),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
