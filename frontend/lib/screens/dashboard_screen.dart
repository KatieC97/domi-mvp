import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import '../widgets/app_top_bar.dart';
import '../services/user_session.dart'; // <- for global name

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'there';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get from route args OR global session
    final routeName = ModalRoute.of(context)?.settings.arguments as String?;

    final name = routeName ?? UserSession.getUserName();

    if (name != null && mounted) {
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppTopBar(showBack: false, context: context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/dashboard_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 342),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Hi, $userName!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF515254),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: const [
                          DashboardCard(
                            label: 'Recently Scanned',
                            icon: Icons.access_time,
                            color: Color(0xFF91C0C6),
                          ),
                          DashboardCard(
                            label: 'Low Stock',
                            icon: Icons.warning_amber_rounded,
                            color: Color(0xFFF5DD98),
                          ),
                          DashboardCard(
                            label: 'Locations',
                            icon: Icons.location_on_rounded,
                            color: Color(0xFFCDBDFA),
                          ),
                          DashboardCard(
                            label: 'Total Items',
                            icon: Icons.list_rounded,
                            color: Color(0xFFE6BAC8),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (kIsWeb) {
                              final fakeBarcode = '4084500970993';
                              Navigator.pushNamed(
                                context,
                                '/add',
                                arguments: fakeBarcode,
                              );
                            } else {
                              final scannedCode = await Navigator.pushNamed(
                                context,
                                '/barcode-scan',
                              );
                              if (!context.mounted || scannedCode == null) {
                                return;
                              }
                              Navigator.pushNamed(
                                context,
                                '/add',
                                arguments: scannedCode,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF634A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Start Scanning',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const DashboardCard({
    required this.label,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 72) / 2;
    final safeWidth = cardWidth.clamp(140.0, 160.0);

    return SizedBox(
      width: safeWidth,
      height: 150,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF515254),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
