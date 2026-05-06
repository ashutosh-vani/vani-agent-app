import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/config/theme.dart';
import 'package:vani_app/presentation/providers/auth_provider.dart';
import 'package:vani_app/presentation/providers/dashboard_provider.dart';
import 'package:vani_app/presentation/providers/phone_numbers_provider.dart';
import 'package:vani_app/presentation/providers/whatsapp_provider.dart';
import 'package:vani_app/widgets/app_header.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  /// Formats a number using the Indian numbering system (e.g. 1,23,456.78)
  String _formatIndian(num value, {int decimals = 2}) {
    final parts = value.toStringAsFixed(decimals).split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    if (intPart.length <= 3) return '$intPart$decPart';

    // Last 3 digits, then groups of 2
    final last3 = intPart.substring(intPart.length - 3);
    final rest = intPart.substring(0, intPart.length - 3);
    final buffer = StringBuffer();
    for (int i = 0; i < rest.length; i++) {
      if (i != 0 && (rest.length - i) % 2 == 0) buffer.write(',');
      buffer.write(rest[i]);
    }
    return '${buffer.toString()},$last3$decPart';
  }
  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).loadDashboardData();
      ref.read(phoneNumbersProvider.notifier).loadPhoneNumbers();
      ref.read(whatsappProvider.notifier).checkIntegrationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppHeader(
        onProfilePressed: () => _showProfileMenu(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Credit Balance and Current Plan Row
              Row(
                children: [
                  // Credit Balance Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Credit Balance',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.mediumGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (dashboardState.isLoading)
                                const SizedBox(
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              else
                                Text(
                                  '₹${_formatIndian(dashboardState.creditBalance?.balance ?? 0)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text(
                                'Add Funds',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Current Plan Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Current Plan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.mediumGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (dashboardState.isLoading)
                                const SizedBox(
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              else
                                Text(
                                  dashboardState.currentSubscription?.tierName ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.darkGrey,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                    dashboardState.currentSubscription?.status ?? 'inactive',
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (dashboardState.currentSubscription?.status ?? 'inactive').toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.borderGrey),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text(
                                'Upgrade',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Connect WhatsApp Card
              _buildWhatsAppCard(),
              const SizedBox(height: 12),
              // Ads Card
              _buildAdsCard(),
              const SizedBox(height: 24),
              // Usage Statistics Section
              const Text(
                'Usage Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
              const SizedBox(height: 12),
              
              // Show loading or statistics
              if (dashboardState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (dashboardState.callStatistics != null) ...[
                _buildStatCard(
                  title: 'Total Calls',
                  value: _formatIndian(dashboardState.callStatistics!.totalCalls, decimals: 0),
                  hasChart: false,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  title: 'Total Minutes',
                  value: _formatIndian(dashboardState.callStatistics!.totalMinutesAsDouble),
                  hasChart: false,
                ),
                const SizedBox(height: 12),
                _buildStatCard(
                  title: 'Avg Duration',
                  value: '${_formatIndian(dashboardState.callStatistics!.averageDurationSeconds, decimals: 0)}s',
                  hasChart: false,
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderGrey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'No usage statistics available',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGrey,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Phone Numbers Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phone Numbers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/available-phone-numbers');
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 18,
                      color: AppTheme.primaryGreen,
                    ),
                    label: const Text(
                      'Available Numbers',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildPhoneNumbersSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.errorRed),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.errorRed,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(authProvider.notifier).logout();
                  if (mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login',
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.primaryGreen;
      case 'cancelled':
        return Colors.red;
      case 'expired':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPhoneNumbersSection() {
    final phoneNumbersState = ref.watch(phoneNumbersProvider);

    if (phoneNumbersState.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (phoneNumbersState.error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'Error: ${phoneNumbersState.error}',
              style: const TextStyle(color: AppTheme.errorRed),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(phoneNumbersProvider.notifier).loadPhoneNumbers();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (phoneNumbersState.phoneNumbers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No phone numbers assigned yet',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.mediumGrey,
            ),
          ),
        ),
      );
    }

    return Column(
      children: phoneNumbersState.phoneNumbers.map((phoneNumber) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: phoneNumber.isDemo == true
                        ? const Color(0x1AFF9800)  // AppTheme.warningOrange with 10% opacity
                        : const Color(0x1A10B981), // AppTheme.primaryGreen with 10% opacity
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.phone,
                    color: phoneNumber.isDemo == true
                        ? AppTheme.warningOrange
                        : AppTheme.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phoneNumber.phoneNumber ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: phoneNumber.isDemo == true
                                  ? const Color(0x1AFF9800)  // AppTheme.warningOrange with 10% opacity
                                  : const Color(0x1A10B981), // AppTheme.successGreen with 10% opacity
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              phoneNumber.isDemo == true ? 'DEMO' : 'REAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: phoneNumber.isDemo == true
                                    ? AppTheme.warningOrange
                                    : AppTheme.successGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: phoneNumber.isActive == true
                                  ? const Color(0x1A10B981) // AppTheme.successGreen with 10% opacity
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              phoneNumber.isActive == true ? 'ACTIVE' : 'INACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: phoneNumber.isActive == true
                                    ? AppTheme.successGreen
                                    : AppTheme.mediumGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  phoneNumber.supportsInbound == true
                      ? Icons.call_received
                      : Icons.call_made,
                  color: AppTheme.mediumGrey,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }



  Widget _buildStatCard({
    required String title,
    required String value,
    required bool hasChart,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkGrey,
            ),
          ),
          if (hasChart) ...[
            const SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWhatsAppCard() {
    final whatsappState = ref.watch(whatsappProvider);

    return InkWell(
      onTap: () {
        if (whatsappState.hasIntegration) {
          // Navigate to WhatsApp inbox
          Navigator.pushNamed(context, '/whatsapp-inbox');
        } else {
          // Navigate to integrations page
          Navigator.pushNamed(context, '/integrations');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whatsappState.hasIntegration
              ? AppTheme.primaryGreen
              : AppTheme.lightGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              whatsappState.hasIntegration
                  ? Icons.chat_bubble
                  : Icons.chat_bubble_outline,
              color: whatsappState.hasIntegration
                  ? Colors.white
                  : AppTheme.primaryGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    whatsappState.hasIntegration
                        ? 'WhatsApp Messages'
                        : 'Connect WhatsApp',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: whatsappState.hasIntegration
                          ? Colors.white
                          : AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    whatsappState.hasIntegration
                        ? '${whatsappState.conversations.length} conversations'
                        : 'Automate your messaging',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: whatsappState.hasIntegration
                          ? Colors.white70
                          : AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (whatsappState.isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: whatsappState.hasIntegration
                    ? Colors.white
                    : AppTheme.darkGrey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsCard() {
    return InkWell(
      onTap: () {
        // Navigate to Meta Ads screen
        Navigator.pushNamed(context, '/meta-ads');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.campaign,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ads',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Create and manage ad campaigns that generate phone leads for your AI agents',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.darkGrey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}


