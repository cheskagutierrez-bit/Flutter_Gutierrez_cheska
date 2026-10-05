import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Profile Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const StudentProfilePage(),
    );
  }
}

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers for each field
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  // Selected gender
  String? selectedGender;

  // Saved info shown after submit
  Map<String, String>? savedInfo;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    contactController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // ---------- SIMPLE VALIDATION ----------

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your age';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Age must be a number';
    }
    if (age < 1 || age > 120) {
      return 'Age must be between 1 and 120';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your contact number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  // ---------- ACTIONS ----------

  void submitForm() {
    final formOk = formKey.currentState!.validate();

    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a gender'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!formOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      savedInfo = {
        'Full Name': nameController.text.trim(),
        'Age': ageController.text.trim(),
        'Gender': selectedGender!,
        'Address': addressController.text.trim(),
        'Contact Number': contactController.text.trim(),
        'Email': emailController.text.trim(),
      };
    });

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void clearForm() {
    formKey.currentState!.reset();
    nameController.clear();
    ageController.clear();
    addressController.clear();
    contactController.clear();
    emailController.clear();

    setState(() {
      selectedGender = null;
      savedInfo = null;
    });

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form cleared'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light green background
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text('Student Profile Form'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  // ---------- FULL NAME ----------
                  buildFieldBox(
                    title: 'Full Name',
                    icon: Icons.person,
                    child: TextFormField(
                      controller: nameController,
                      decoration: buildInputDecoration('Enter your full name'),
                      validator: validateName,
                    ),
                  ),

                  // ---------- AGE ----------
                  buildFieldBox(
                    title: 'Age',
                    icon: Icons.cake,
                    child: TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: buildInputDecoration('Enter your age'),
                      validator: validateAge,
                    ),
                  ),

                  // ---------- GENDER ----------
                  buildFieldBox(
                    title: 'Gender',
                    icon: Icons.wc,
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: selectedGender,
                            activeColor: Colors.green.shade700,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() => selectedGender = value);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: selectedGender,
                            activeColor: Colors.green.shade700,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() => selectedGender = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- ADDRESS ----------
                  buildFieldBox(
                    title: 'Address',
                    icon: Icons.home,
                    child: TextFormField(
                      controller: addressController,
                      maxLines: 2,
                      decoration: buildInputDecoration('Enter your address'),
                      validator: validateAddress,
                    ),
                  ),

                  // ---------- CONTACT ----------
                  buildFieldBox(
                    title: 'Contact Number',
                    icon: Icons.phone,
                    child: TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      decoration: buildInputDecoration('e.g. 09171234567'),
                      validator: validateContact,
                    ),
                  ),

                  // ---------- EMAIL ----------
                  buildFieldBox(
                    title: 'Email',
                    icon: Icons.email,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: buildInputDecoration('e.g. juan@email.com'),
                      validator: validateEmail,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------- BUTTONS ----------
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: submitForm,
                          icon: const Icon(Icons.check),
                          label: const Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: clearForm,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green.shade700,
                            side: BorderSide(color: Colors.green.shade700),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- RESULT BOX ----------
            if (savedInfo != null) buildResultBox(),
          ],
        ),
      ),
    );
  }

  // A reusable decoration for the text inputs
  InputDecoration buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.green.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.green.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.green.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.green.shade700, width: 2),
      ),
    );
  }

  // A reusable "box" wrapper for every field.
  // Each field gets its own green bordered card with a title bar.
  Widget buildFieldBox({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar of the box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // Body of the box
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }

  // The green result box that appears after a successful submit
  Widget buildResultBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade700, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.badge, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Student Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Rows of data
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                for (final entry in savedInfo!.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
