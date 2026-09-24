import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.asset(
              'assets/images/profile.png',
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontFamily: 'ProfileFont', fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(university, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
