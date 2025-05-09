import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/data/models/BE/user_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/screens/Authentication/sign_in_screen.dart';
import 'package:MELODY/views/widgets/custom_button/custom_button.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  final UserData? userData;
  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // call getUserInfo in _authService to get user info
    final user = _authService.getUserInfo();
    debugPrint('User info: $user');
  }

  void handleSignOut() async {
    await _authService.signOut();
    // Navigate to the login screen or perform any other action
    print('User signed out');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 22, right: 22),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Profile Picture with height and width
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        widget.userData?.profilePictureUrl ??
                            'assets/images/Avatar.png',
                      ),
                    ),

                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userData?.name ?? 'User Name',
                          style: LightTextTheme.headding3.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.userData?.name ?? 'UserName@gmail.com',
                          style: LightTextTheme.paragraph2.copyWith(
                            fontSize: 14,
                            color: LightColorTheme.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TagButton(
                  label: widget.userData?.membership ?? 'Free',
                  backgroundColor: LightColorTheme.black,
                  textColor: LightColorTheme.white,
                  fontWeight: 600,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.headphones,
                      color: LightColorTheme.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Artist',
                      style: LightTextTheme.paragraph2.copyWith(
                        fontSize: 16,
                        color: LightColorTheme.grey,
                      ),
                    ),
                  ],
                ),

                //Toggle Button
                Switch(
                  value: true,
                  activeColor: Colors.black, // Active color of the thumb
                  inactiveThumbColor: Colors.white, // Inactive thumb color
                  inactiveTrackColor:
                      Colors.grey.shade300, // Inactive track color
                  activeTrackColor: Colors.green, // Active track color
                  onChanged: (bool value) {
                    setState(() {
                      false;
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  // trackBorderColor: MaterialStateProperty.all(
                  //   Colors.grey.shade300,
                  // ), // Track border color
                ),
              ],
            ),
            Divider(
              color: LightColorTheme.grey.withOpacity(0.5),
              thickness: 0.25,
              height: 20,
            ),

            // const SizedBox(height: 16),

            // personal Infor
            GestureDetector(
              onTap: () {
                print('Xem thông tin của tôi');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageTheme.cccdIcon,
                      width: 24,
                      height: 24,
                      color: LightColorTheme.black,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Thông tin của tôi',
                      style: LightTextTheme.regular.copyWith(
                        fontSize: 16,
                        color: LightColorTheme.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Setting Icon
            GestureDetector(
              onTap: () {
                print('Cài đặt');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageTheme.settingIcon,
                      width: 24,
                      height: 24,
                      color: LightColorTheme.black,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Cài đặt',
                      style: LightTextTheme.regular.copyWith(
                        fontSize: 16,
                        color: LightColorTheme.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Contact Icon
            GestureDetector(
              onTap: () {
                print('Cài đặt');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImageTheme.contactIcon,
                      width: 24,
                      height: 24,
                      color: LightColorTheme.black,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hỗ trợ',
                      style: LightTextTheme.regular.copyWith(
                        fontSize: 16,
                        color: LightColorTheme.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(
              color: LightColorTheme.grey.withOpacity(0.5),
              thickness: 0.25,
              height: 20,
            ),

            // Logout Button
            CustomButton(
              hintText: 'Đăng xuất',
              onPressed: () {
                handleSignOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
