import 'package:MELODY/auth/auth_service.dart';
import 'package:MELODY/core/services/user_service.dart';
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
  final UserService _userService = UserService();
  UserData? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (widget.userData != null) {
      setState(() {
        _userData = widget.userData;
        _isLoading = false;
      });
      return;
    }

    try {
      final userData = await _userService.getUserDataFromToken();
      debugPrint('User data: $userData');
      debugPrint('User ID: ${userData?.id}');
      debugPrint('User Name: ${userData?.name}');
      debugPrint('User Email: ${userData?.email}');
      debugPrint('User Phone: ${userData?.phone}');
      debugPrint('User Membership: ${userData?.membership}');
      debugPrint('User Address: ${userData?.address}');
      debugPrint('User Profile Picture: ${userData?.profilePictureUrl}');
      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleSignOut() async {
    await _authService.signOut();
    _userService.clearCachedUserData();
    print('User signed out');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                        _userData?.profilePictureUrl ??
                            'assets/images/Avatar.png',
                      ),
                    ),

                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData?.name ?? 'User Name',
                          style: LightTextTheme.headding3.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _userData?.email ?? 'UserName@gmail.com',
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
                  label: _userData?.membership ?? 'Free',
                  backgroundColor: LightColorTheme.black,
                  textColor: LightColorTheme.white,
                  fontWeight: 600,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.headphones,
            //           color: LightColorTheme.grey,
            //           size: 16,
            //         ),
            //         const SizedBox(width: 4),
            //         Text(
            //           'Artist',
            //           style: LightTextTheme.paragraph2.copyWith(
            //             fontSize: 16,
            //             color: LightColorTheme.grey,
            //           ),
            //         ),
            //       ],
            //     ),

            //     //Toggle Button
            //     Switch(
            //       value: true,
            //       activeColor: Colors.black, // Active color of the thumb
            //       inactiveThumbColor: Colors.white, // Inactive thumb color
            //       inactiveTrackColor:
            //           Colors.grey.shade300, // Inactive track color
            //       activeTrackColor: Colors.green, // Active track color
            //       onChanged: (bool value) {
            //         setState(() {
            //           false;
            //         });
            //       },
            //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       // trackBorderColor: MaterialStateProperty.all(
            //       //   Colors.grey.shade300,
            //       // ), // Track border color
            //     ),
            //   ],
            // ),
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
            const SizedBox(height: 16),

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
