import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  String selectedGender = "Male";
  bool _loading = false;
  String? _profilePicUrl;
  File? _newImageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _dobController.text = data['dob'] ?? '';
        selectedGender = data['gender'] ?? 'Male';
        _profilePicUrl = data['profile_pic'];
      });
    }
  }

Future<void> _pickImage() async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // reduces file size a bit
    );

    if (pickedFile == null) {
      print("⚠️ No image selected");
      return;
    }

    final originalFile = File(pickedFile.path);
    final tempDir = Directory.systemTemp;
    final targetPath =
        "${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final compressedResult = await FlutterImageCompress.compressAndGetFile(
      originalFile.path,
      targetPath,
      quality: 80,
      minWidth: 512,
      minHeight: 512,
      format: CompressFormat.jpeg,
    );

    // 🔧 Safely convert XFile to File if needed
    File compressedFile;
    if (compressedResult is XFile) {
      compressedFile = File(compressedResult.path);
    } else if (compressedResult is File) {
      compressedFile = compressedResult as File;
    } else {
      compressedFile = originalFile;
    }

    setState(() {
      _newImageFile = compressedFile;
      _profilePicUrl = null; // Force UI to show local file immediately
    });

    print("✅ Image selected: ${_newImageFile?.path}");
  } catch (e, stack) {
    print("⚠️ Error picking/compressing image: $e");
    print(stack);
    }
  }


  Future<void> _saveChanges() async {
    setState(() => _loading = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    String? imageUrl = _profilePicUrl;

    // ✅ Upload new image if selected
    if (_newImageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('$uid.jpg');

        await storageRef.putFile(_newImageFile!);
        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print("⚠️ Image upload failed: $e");
      }
    }

    // ✅ Update Firestore data
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'dob': _dobController.text.trim(),
      'gender': selectedGender,
      'profile_pic': imageUrl ?? _profilePicUrl,
    });

    setState(() => _loading = false);
    Navigator.pop(context, true); // 🔄 Notify ProfileScreen to refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // 🖼 Profile Picture
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          key: ValueKey(_newImageFile?.path ?? _profilePicUrl ?? 'default'),
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _newImageFile != null
                              ? FileImage(_newImageFile!)
                              : (_profilePicUrl != null && _profilePicUrl!.isNotEmpty)
                                  ? NetworkImage(_profilePicUrl!)
                                  : null, // No fallback image
                          child: (_newImageFile == null && (_profilePicUrl == null || _profilePicUrl!.isEmpty))
                              ? const Icon(Icons.person, size: 60, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🧍 User Info Preview
                    Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : "User Name",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emailController.text.isNotEmpty
                          ? _emailController.text
                          : "user@email.com",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),

                    const SizedBox(height: 32),

                    // ✏️ Editable Fields
                    _buildTextField("Name", _nameController),
                    const SizedBox(height: 16),
                    _buildTextField("Email", _emailController),
                    const SizedBox(height: 16),
                    _buildTextField("Phone Number", _phoneController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField("Date of Birth", _dobController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildGenderDropdown()),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 💾 Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedGender,
              isExpanded: true,
              items: ["Male", "Female", "Other"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
