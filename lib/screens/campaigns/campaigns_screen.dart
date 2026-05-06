import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vani_app/config/theme.dart';
import 'package:vani_app/data/services/campaigns_api_service.dart';
import 'package:vani_app/models/campaign_model.dart';
import 'package:vani_app/screens/campaigns/campaign_details_screen.dart';
import 'package:vani_app/screens/campaigns/update_campaign_screen.dart';
import 'package:vani_app/utils/date_time_utils.dart';

// State provider for campaigns
final campaignsProvider = FutureProvider.autoDispose.family<List<Campaign>, CampaignFilters>(
  (ref, filters) async {
    final service = ref.watch(campaignsApiServiceProvider);
    return service.getCampaigns(
      search: filters.search,
      status: filters.status,
      createdFrom: filters.createdFrom,
      createdTill: filters.createdTill,
    );
  },
);

class CampaignFilters {
  final String? search;
  final String? status;
  final String? createdFrom;
  final String? createdTill;

  const CampaignFilters({
    this.search,
    this.status,
    this.createdFrom,
    this.createdTill,
  });

  CampaignFilters copyWith({
    String? search,
    String? status,
    String? createdFrom,
    String? createdTill,
  }) {
    return CampaignFilters(
      search: search ?? this.search,
      status: status ?? this.status,
      createdFrom: createdFrom ?? this.createdFrom,
      createdTill: createdTill ?? this.createdTill,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CampaignFilters &&
          runtimeType == other.runtimeType &&
          search == other.search &&
          status == other.status &&
          createdFrom == other.createdFrom &&
          createdTill == other.createdTill;

  @override
  int get hashCode =>
      search.hashCode ^
      status.hashCode ^
      createdFrom.hashCode ^
      createdTill.hashCode;
}

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaignsAsync = ref.watch(campaignsProvider(const CampaignFilters()));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Campaigns',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage your campaign list',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.mediumGrey,
                  ),
                ),
                const SizedBox(height: 16),

                // Campaign List
                campaignsAsync.when(
                  data: (campaigns) {
                    if (campaigns.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.campaign_outlined,
                                size: 48,
                                color: AppTheme.mediumGrey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No campaigns yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkGrey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your campaigns will appear here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CampaignCard(
                            campaign: campaign,
                            onRefresh: () {
                              ref.invalidate(campaignsProvider);
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  error: (error, stack) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderGrey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Error: ${error.toString()}',
                          style: const TextStyle(color: AppTheme.errorRed),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            ref.invalidate(campaignsProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CampaignCard extends ConsumerWidget {
  final Campaign campaign;
  final VoidCallback onRefresh;

  const _CampaignCard({
    required this.campaign,
    required this.onRefresh,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.primaryGreen;
      case 'completed':
        return Colors.blue;
      case 'paused':
        return Colors.orange;
      case 'draft':
        return AppTheme.mediumGrey;
      default:
        return AppTheme.mediumGrey;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.lightGreen;
      case 'completed':
        return Colors.blue.withOpacity(0.1);
      case 'paused':
        return Colors.orange.withOpacity(0.1);
      case 'draft':
        return AppTheme.borderGrey;
      default:
        return AppTheme.borderGrey;
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final date = DateTime.parse(dateTime);
      // Convert UTC to IST (GMT+5:30)
      final istDate = DateTimeUtils.toIST(date);
      return DateFormat('dd/MM/yyyy, HH:mm:ss').format(istDate);
    } catch (e) {
      return dateTime;
    }
  }

  Future<void> _deleteCampaign(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Campaign'),
        content: Text('Are you sure you want to delete "${campaign.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final service = ref.read(campaignsApiServiceProvider);
        await service.deleteCampaign(campaign.id);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campaign deleted successfully')),
          );
          onRefresh();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting campaign: $e')),
          );
        }
      }
    }
  }

  Future<void> _editCampaign(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateCampaignScreen(campaign: campaign),
      ),
    );
    if (result == true) {
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campaign Name and Status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusBackgroundColor(campaign.status),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '● ${campaign.status.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(campaign.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Campaign ID
          Text(
            'ID: ${campaign.id}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: 12),

          // Schedule Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'START DATE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mediumGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(campaign.startDateTime),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'END DATE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.mediumGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(campaign.endDateTime),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Agent Name Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AGENT NAME',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.mediumGrey,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.headset_mic,
                    size: 14,
                    color: AppTheme.mediumGrey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      campaign.agentName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.darkGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Created Date
          Text(
            'Created: ${_formatDateTime(campaign.createdAt)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.mediumGrey,
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CampaignDetailsScreen(campaignId: campaign.id),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.borderGrey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: AppTheme.darkGrey,
                  ),
                  label: const Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _editCampaign(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.borderGrey),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(48, 48),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppTheme.darkGrey,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _deleteCampaign(context, ref),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.borderGrey),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  minimumSize: const Size(48, 48),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
