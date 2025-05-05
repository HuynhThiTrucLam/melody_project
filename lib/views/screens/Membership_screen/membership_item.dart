import 'dart:ffi';

import 'package:MELODY/data/models/BE/membership_data.dart';
import 'package:MELODY/theme/custom_themes/color_theme.dart';
import 'package:MELODY/theme/custom_themes/image_theme.dart'; // Assuming the image theme is in this file
import 'package:MELODY/theme/custom_themes/text_theme.dart';
import 'package:MELODY/views/widgets/tag_button/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MembershipItem extends StatefulWidget {
  final MembershipData membership;

  const MembershipItem({super.key, required this.membership});

  @override
  State<MembershipItem> createState() => _MembershipItemState();
}

class _MembershipItemState extends State<MembershipItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // elevation: 5,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
        decoration: BoxDecoration(
          // Background with two Radial Gradients
          gradient: SweepGradient(
            center: Alignment.topRight,
            startAngle: 0.0,
            endAngle: 3.14,
            colors: [
              Color(0xFF99D94D),
              LightColorTheme.mainColor,
              Colors.green.shade200,
              LightColorTheme.mainColor,
            ],
            stops: [0.0, 0.5, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Membership Name
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.black,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 0, // No minimum width
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize
                                .min, // <-- This makes the Row wrap its content
                        children: [
                          SvgPicture.asset(
                            ImageTheme.cardIcon,
                            color: Colors.white,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.membership.name ?? 'Membership',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  TagButton(
                    label: "Hiện tại",
                    borderRadius: BorderRadius.circular(20),
                    fontWeight: 600,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                widget.membership.description ?? 'Description',
                style: LightTextTheme.paragraph1.copyWith(
                  fontSize: 14,
                  color: LightColorTheme.white,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children:
                    widget.membership.features?.map((feature) {
                      return Row(
                        children: [
                          const Icon(
                            Icons.check,
                            size: 18,
                            color: LightColorTheme.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            feature,
                            style: LightTextTheme.paragraph1.copyWith(
                              fontSize: 16,
                              color: LightColorTheme.white,
                            ),
                          ),
                        ],
                      );
                    }).toList() ??
                    [],
              ),

              // List Features
              const SizedBox(height: 8),
              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${widget.membership.price.toString()} VND/ ',
                    style: LightTextTheme.headding2.copyWith(
                      color: LightColorTheme.white,
                    ),
                  ),
                  Text(
                    '${widget.membership.duration} tháng',
                    style: LightTextTheme.paragraph1.copyWith(
                      fontSize: 16,
                      color: LightColorTheme.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
