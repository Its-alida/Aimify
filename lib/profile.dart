import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String selectedImagePath;
  late bool textOption1Checked = true; 
  late bool textOption2Checked = true;

  @override
  void initState() {
    super.initState();
    selectedImagePath = 'assets/aimify_logo.png';
    textOption1Checked = true;
    textOption2Checked = true;
  }

  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    

    if (pickedFile != null) {
      setState(() {
        selectedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 83, 218, 151),
        title: const Text('Profile'),
      ),
      body:
       Padding(
         padding: const EdgeInsets.fromLTRB(20.0, 80.0, 40.0, 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
              children: [
              GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(selectedImagePath),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Profile Photo',
              style: TextStyle(fontSize: 22),
            ),
            ],
            ),
            ),
            
            const SizedBox(height: 20),
            const Text(
              'Other Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                ),
            ),
            Row(
              children: [
                const Text(
                  'Enable reminders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Checkbox(
                  value: textOption1Checked,
                  activeColor: Color.fromARGB(255, 94, 224, 163),
                  onChanged: (bool? value) {
                    setState(() {
                      textOption1Checked = value ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Enable insights ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    ),
                ),
                Checkbox(
                  value: textOption2Checked,
                  activeColor: Color.fromARGB(255, 114, 243, 189),
                  onChanged: (bool? value) {
                    setState(() {
                      textOption2Checked = value ?? false;
                    });
                  },
                ),
              ],
            ),
            
             const Padding(
              padding: EdgeInsets.only(left: 10.0), 
              child: Text(
                'Disabling this will stop analysis generation and display for your task completions',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 109, 108, 108)),
              ),
            ),
           
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 250, 250), 
    );
  }
}
