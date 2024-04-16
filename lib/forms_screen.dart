import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({Key? key}) : super(key: key);

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formsKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final List<String> _genders = ['Male', 'Female', 'Other'];
  String? _selectedGender;

  final List<String> _maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed']; 
  String? _selectedMaritalStatus;

  final _PrimaryDocNameController = TextEditingController();
  final _ssnController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _PrimaryDocNameController.dispose();
    _middleNameController.dispose();
    _ssnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Electronic Health Records', 
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.deepPurple[300],
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

                  //first name field
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
                    controller: _firstNameController,
                  ),

                  //middle name field
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Middle Name'),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter N/A if non-applicable.';
                      }
                      return null;
                    },
                    controller: _middleNameController,
                  ),

                  //last name
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
                    controller: _lastNameController,
                  ),

                  //DOB
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth (DOB)',
                      hintText: 'Select your date of birth',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        _dobController.text = formattedDate;
                      }
                    },
                  ),
                  
                  //Gender
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

                  //Marital Status
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Marital Status',
                      hintText: 'Please specify your marital status',
                    ),
                    value: _selectedMaritalStatus,
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

                  //SSN
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'SSN',
                      hintText: 'Please fill in your social security number',
                      suffixIcon: Icon(Icons.security),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final newText = newValue.text.replaceAll('-', '');
                        if (newText.length > 9) return oldValue;
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
                    controller: _ssnController,
                    validator: (value) {
                      final ssnRegex = RegExp(r'^\d{3}-\d{2}-\d{4}$');
                      if (value == null || value.isEmpty || !ssnRegex.hasMatch(value)) {
                        return 'Please enter a valid SSN (###-##-####)';
                      }
                      return null;
                    },
                  ),

                  //Primary Care Doctor Name
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Primary Doctor Name', 
                      hintText: 'Please fill in your primary doctor name', 
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Primary doctor name is required. Enter N/A if not known.';
                      }
                      return null;
                    },
                    controller: _PrimaryDocNameController,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formsKey.currentState!.validate()) {
                        _formsKey.currentState!.save();

                        try {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('user_data');
                            
                            await userRef.add({
                              'first name': _firstNameController.text.trim(),
                              'middle name': _middleNameController.text.trim(),
                              'last name': _lastNameController.text.trim(),
                              'dob': _dobController.text.trim(),
                              'gender': _selectedGender,
                              'maritalStatus': _selectedMaritalStatus,
                              'primary doctor name': _PrimaryDocNameController.text.trim(),
                              'ssn': _ssnController.text.trim(),
                            });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(content: Text('Profile completed. Thank you.'));
                              },
                            );
                          }
                        } catch (error) {
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
                      backgroundColor: Colors.deepPurple,
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
