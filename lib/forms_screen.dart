import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pages/profile_page.dart';

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

  // Address fields
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  // Phone number
  final _phoneController = TextEditingController();

  // Emergency Contact fields
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationshipController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // Medical conditions and Family history
  List<String> _selectedMedicalConditions = [];
  List<String> _selectedFamilyHistory = [];

  // Smoking status
  String? _smokingStatus;

  //chosen state
  String? _selectedState;

  // Medications
  final _medicationsController = TextEditingController();

  // Lists of conditions
  final List<String> _medicalConditions = [
    'Rheumatic fever', 'Recent surgery', 'Edema (swelling of ankles)', 'High blood pressure',
    'Injury to back or knees', 'Low blood pressure', 'Seizures', 'Lung disease', 'Heart attack',
    'Fainting or dizziness with or without physical exertion', 'Diabetes', 'High cholesterol',
    'Orthopnea', 'Shortness of breath at rest or with mild exertion', 'Chest pains', 
    'Palpitations or tachycardia', 'Intermittent claudication', 'Pain, discomfort in chest, neck, jaw, arms',
    'Known heart murmur', 'Unusual fatigue or shortness of breath with usual activities',
    'Temporary loss of visual acuity or speech, or short-term numbness or weakness', 'Other'
  ];

  final List<String> _familyHistoryConditions = [
    'Heart arrhythmia', 'Heart attack', 'Heart operation', 'Congenital heart disease',
    'Premature death before age 50', 'Significant disability secondary to a heart condition',
    'Marfan syndrome', 'High blood pressure', 'High cholesterol', 'Diabetes', 'Other major illness'
  ];

  // States for dropdown
  final List<String> _states = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
    'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
    'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
    'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
  ];

  @override
  void dispose() {
    _dobController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _PrimaryDocNameController.dispose();
    _middleNameController.dispose();
    _ssnController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationshipController.dispose();
    _emergencyPhoneController.dispose();
    _medicationsController.dispose();
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

                  // Address section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Address:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(labelText: 'Street'),
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: const InputDecoration(labelText: 'State'),
                    items: _states.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Please select your state' : null,
                  ),
                  TextFormField(
                    controller: _zipCodeController,
                    decoration: const InputDecoration(labelText: 'Zip Code'),
                    keyboardType: TextInputType.number,
                  ),

                  // Phone number
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
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

                  // Emergency contact
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Emergency Contact:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  TextFormField(
                    controller: _emergencyNameController,
                    decoration: const InputDecoration(labelText: 'Emergency Contact Name'),
                  ),
                  TextFormField(
                    controller: _emergencyRelationshipController,
                    decoration: const InputDecoration(labelText: 'Relationship to User'),
                  ),
                  TextFormField(
                    controller: _emergencyPhoneController,
                    decoration: const InputDecoration(labelText: 'Emergency Phone Number'),
                    keyboardType: TextInputType.phone,
                  ),

                  // Medical conditions (use CheckboxListTile for each condition)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Past/Present Medical Conditions:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  ..._medicalConditions.map((condition) {
                    return CheckboxListTile(
                      title: Text(condition),
                      value: _selectedMedicalConditions.contains(condition),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedMedicalConditions.add(condition);
                          } else {
                            _selectedMedicalConditions.removeWhere((item) => item == condition);
                          }
                        });
                      },
                    );
                  }).toList(),

                  // Family history (similar to medical conditions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Family Medical History:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  ..._familyHistoryConditions.map((condition) {
                    return CheckboxListTile(
                      title: Text(condition),
                      value: _selectedFamilyHistory.contains(condition),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedFamilyHistory.add(condition);
                          } else {
                            _selectedFamilyHistory.removeWhere((item) => item == condition);
                          }
                        });
                      },
                    );
                  }).toList(),

                  // Smoking status
                  DropdownButtonFormField<String>(
                    value: _smokingStatus,
                    decoration: const InputDecoration(labelText: 'Do you smoke?'),
                    items: <String>['Yes', 'No'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _smokingStatus = newValue;
                      });
                    },
                  ),

                  // List of medications
                  TextFormField(
                    controller: _medicationsController,
                    decoration: const InputDecoration(
                      labelText: 'List of Medications',
                      hintText: 'Separate medications with commas',
                    ),
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
                            final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('ehr_records');

                            // Convert medications from comma-separated string to list of trimmed strings
                            List<String> medicationList = _medicationsController.text.split(',')
                              .map((medication) => medication.trim()) // Remove any extra whitespace
                              .where((medication) => medication.isNotEmpty) // Remove any empty entries
                              .toList();
                            
                            // Create a map of all the data to store
                            Map<String, dynamic> userData = {
                              'first name': _firstNameController.text.trim(),
                              'middle name': _middleNameController.text.trim(),
                              'last name': _lastNameController.text.trim(),
                              'dob': _dobController.text.trim(),
                              'gender': _selectedGender,
                              'marital status': _selectedMaritalStatus,
                              'primary doctor name': _PrimaryDocNameController.text.trim(),
                              'ssn': _ssnController.text.trim(),
                              'street': _streetController.text.trim(),
                              'city': _cityController.text.trim(),
                              'state': _selectedState,
                              'zip code': _zipCodeController.text.trim(),
                              'phone number': _phoneController.text.trim(),
                              'emergency contact name': _emergencyNameController.text.trim(),
                              'emergency relationship': _emergencyRelationshipController.text.trim(),
                              'emergency phone': _emergencyPhoneController.text.trim(),
                              'medical conditions': _selectedMedicalConditions,
                              'family history': _selectedFamilyHistory,
                              'smoking status': _smokingStatus,
                              'medications': medicationList,
                            };

                            // Save the data in Firestore
                            await userRef.doc(currentUser.uid).set(userData, SetOptions(merge: true));

                            /* 
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(content: Text('Profile completed. Thank you.'));
                              },
                            );
                            */
                            // Navigate to ProfilePage after successful profile completion
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        }  catch (error) {
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
