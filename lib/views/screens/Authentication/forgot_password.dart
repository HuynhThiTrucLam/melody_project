import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),

            SizedBox(height: 50.h),

            // Illustration (thay bằng Image.asset nếu cần)
            Center(
              child: Image.asset(
                'assets/forgot_password.png', // Đặt ảnh minh họa phù hợp
                height: 200.h,
              ),
            ),

            SizedBox(height: 40.h),

            // Title
            Center(
              child: Text(
                'Quên mật khẩu',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10.h),

            // Subtitle
            Center(
              child: Text(
                'Nhập số điện thoại để đặt lại mật khẩu',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 30.h),

            // Phone number input
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Country code
                  Row(
                    children: [
                      Image.asset(
                        'assets/vietnam_flag.png', // Đặt icon lá cờ Việt Nam
                        width: 24.w,
                      ),
                      SizedBox(width: 5.w),
                      Text('+84', style: TextStyle(fontSize: 16.sp)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),

                  SizedBox(width: 10.w),

                  // Phone number field
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '0123456789',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Reset via Email
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text.rich(
                  TextSpan(
                    text: 'Đặt lại mật khẩu bằng ',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Email?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
