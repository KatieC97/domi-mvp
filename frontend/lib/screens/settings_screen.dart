import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppTopBar(showBack: true, context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF515254),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Dark Mode Toggle
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0x1A634A8A)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.dark_mode_outlined, color: Color(0xFF515254)),
                  SizedBox(width: 12),
                  Text('Dark Mode', style: TextStyle(color: Color(0xFF515254))),
                  Spacer(),
                  Switch(value: false, onChanged: null),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Options list
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0x1A634A8A)),
              ),
              child: Column(
                children: [
                  _buildSettingsOption('Manage Locations'),
                  _buildDivider(),
                  _buildSettingsOption('Contact Support'),
                  _buildDivider(),

                  // Logout
                  InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Color(0xFFB63D36),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  Widget _buildSettingsOption(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF515254),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Color(0xFF515254)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: const Color(0x1A634A8A),
    );
  }
}
