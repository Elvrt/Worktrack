import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:worktrack/profil/editprofile.dart';
import 'package:worktrack/navbar.dart';
import 'package:worktrack/login.dart';


class InfoProfile extends StatefulWidget {
  @override
  _InfoProfileState createState() => _InfoProfileState();
}

class _InfoProfileState extends State<InfoProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController profileController = TextEditingController();

  String? errorMessage;

  // Fungsi untuk mendapatkan data profil dari API
  Future<void> fetchProfile() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${urlDomain}api/employee/show',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        setState(() {
          nameController.text = data['employee']['name'] ?? '';
          phoneController.text = data['employee']['phone_number'] ?? '';
          dateController.text = data['employee']['date_of_birth'] ?? '';
          usernameController.text = data['user']['username'] ?? '';
          addressController.text = data['employee']['address'] ?? '';
          positionController.text = data['role']['position'] ?? '';
          numberController.text = data['employee']['employee_number'] ?? '';
          profileController.text = data['employee']['profile'] ?? '';
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch profile data.";
        });
      }
    } on DioError catch (e) {
      setState(() {
        errorMessage =
            e.response?.data['message'] ?? "An unexpected error occurred.";
      });
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        '${urlDomain}api/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
  // Navigasi ke halaman home_screen setelah logout berhasil
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
} else {
  setState(() {
    errorMessage = "Logout failed.";
  });
}

    } on DioError catch (e) {
      setState(() {
        errorMessage =
            e.response?.data['message'] ?? "An unexpected error occurred.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: profileController.text.isNotEmpty &&
                            Uri.tryParse(profileController.text)
                                    ?.hasAbsolutePath ==
                                true
                        ? Image.network(
                            profileController.text,
                            height: 94,
                            width: 94,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 94,
                                width: 94,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 94,
                            width: 94,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  SizedBox(height: 20),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  _buildField('Name', nameController),
                  _buildField('Phone Number', phoneController),
                  _buildField('Date of Birth', dateController),
                  _buildField('Username', usernameController),
                  _buildField('Address', addressController),
                  _buildField('Position', positionController),
                  _buildField(
                      'Employee Identification Number', numberController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD83A),
                          fixedSize: Size(174, 40),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          fixedSize: Size(174, 40),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        TextField(
          controller: controller,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            filled: true,
            fillColor: Color(0xFFFFFFFF),
          ),
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
