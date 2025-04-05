import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class UserDirectionScreen extends StatefulWidget {
  const UserDirectionScreen({super.key});

  @override
  State<UserDirectionScreen> createState() => _UserDirectionScreenState();
}

class _UserDirectionScreenState extends State<UserDirectionScreen> {
  final List<UserRole> _userRoles = [
    UserRole(
      title: 'Singer/Producer',
      description: 'Lorem Ipsum is simply dummy text of the',
      imagePath: 'assets/images/singer_producer_icon.png',
    ),
    UserRole(
      title: 'DJ',
      description: 'Lorem Ipsum is simply dummy text of the',
      imagePath: 'assets/images/dj_icon.png',
    ),
  ];

  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColorTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              _buildTitleSection(),
              const SizedBox(height: 32),
              Expanded(child: _buildRoleSelection()),
              _buildContinueButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          'Tôi là một ...',
          style: LightTextTheme.headding1.copyWith(
            color: LightColorTheme.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Chúng tôi sẽ hợp lý hóa trải nghiệm của bạn với vai trò là',
          style: LightTextTheme.paragraph2.copyWith(
            color: LightColorTheme.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: _userRoles.length,
      itemBuilder: (context, index) {
        final role = _userRoles[index];
        final isSelected = _selectedRole == role;

        return _buildRoleCard(role, isSelected);
      },
    );
  }

  Widget _buildRoleCard(UserRole role, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 32),
        padding: const EdgeInsets.all(16),
        height: 160,
        decoration: BoxDecoration(
          color: LightColorTheme.white,
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? Border.all(color: LightColorTheme.black, width: 1)
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              role.imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    role.title,
                    style: LightTextTheme.headding2.copyWith(
                      color: LightColorTheme.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    role.description,
                    style: LightTextTheme.paragraph3.copyWith(
                      color: LightColorTheme.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final bool isEnabled = _selectedRole != null;

    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: isEnabled ? _handleContinue : null,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isEnabled
                    ? LightColorTheme.mainColor
                    : LightColorTheme.grey.withOpacity(0.5),
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: LightColorTheme.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedRole != null) {
      debugPrint('Selected role: ${_selectedRole!.title}');
      // TODO: Save selected role to shared preferences or user profile

      // TODO: Navigate to the appropriate screen based on the selected role
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      //   (route) => false,
      // );
    }
  }
}

class UserRole {
  final String title;
  final String description;
  final String imagePath;

  const UserRole({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserRole &&
        other.title == title &&
        other.description == description &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode =>
      title.hashCode ^ description.hashCode ^ imagePath.hashCode;
}
