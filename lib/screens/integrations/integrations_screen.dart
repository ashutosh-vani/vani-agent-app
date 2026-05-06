import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/config/theme.dart';
import 'package:vani_app/presentation/providers/integrations_provider.dart';
import 'package:vani_app/models/integration_model.dart';
import 'package:vani_app/screens/integrations/create_whatsapp_screen.dart';
import 'package:vani_app/screens/integrations/create_meta_screen.dart';

class IntegrationsScreen extends ConsumerStatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  ConsumerState<IntegrationsScreen> createState() =>
      _IntegrationsScreenState();
}

class _IntegrationsScreenState extends ConsumerState<IntegrationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(integrationsProvider.notifier).loadAllConnections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final integrationsState = ref.watch(integrationsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Text(
                      'Integrations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        ref
                            .read(integrationsProvider.notifier)
                            .loadAllConnections();
                      },
                      color: AppTheme.mediumGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect and manage your external services',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.mediumGrey,
                  ),
                ),
                const SizedBox(height: 24),

                // Error Message
                if (integrationsState.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.errorRed),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppTheme.errorRed,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            integrationsState.error!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.errorRed,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            ref
                                .read(integrationsProvider.notifier)
                                .clearError();
                          },
                          color: AppTheme.errorRed,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // WhatsApp Section
                _buildSectionHeader(
                  'WhatsApp Business',
                  'Connect your WhatsApp Business account',
                  Icons.chat_bubble,
                  () => _showCreateWhatsAppDialog(),
                ),
                const SizedBox(height: 12),
                _buildWhatsAppConnections(integrationsState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onAdd,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppConnections(IntegrationsState state) {
    if (state.isLoading && state.whatsappConnections.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.whatsappConnections.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: AppTheme.mediumGrey.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'No WhatsApp connections',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add a connection to start messaging',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: state.whatsappConnections.map((connection) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildWhatsAppConnectionCard(connection),
        );
      }).toList(),
    );
  }

  Widget _buildWhatsAppConnectionCard(WhatsAppConnection connection) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: connection.isActive
                      ? AppTheme.primaryGreen.withOpacity(0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chat_bubble,
                  color: connection.isActive
                      ? AppTheme.primaryGreen
                      : AppTheme.mediumGrey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connection.businessPhoneId,
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
                            color: connection.isActive
                                ? AppTheme.successGreen.withOpacity(0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            connection.isActive ? 'ACTIVE' : 'INACTIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: connection.isActive
                                  ? AppTheme.successGreen
                                  : AppTheme.mediumGrey,
                            ),
                          ),
                        ),
                        if (connection.whatsappAgentEnabled) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'AI ENABLED',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'validate':
                      _validateWhatsAppConnection(connection.id);
                      break;
                    case 'templates':
                      _showWhatsAppTemplates(connection.id);
                      break;
                    case 'edit':
                      _showEditWhatsAppDialog(connection);
                      break;
                    case 'delete':
                      _deleteWhatsAppConnection(connection.id);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'validate',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Validate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'templates',
                    child: Row(
                      children: [
                        Icon(Icons.message, size: 18),
                        SizedBox(width: 8),
                        Text('View Templates'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: AppTheme.errorRed),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (connection.businessAccountId != null) ...[
            const SizedBox(height: 12),
            Text(
              'Business Account: ${connection.businessAccountId}',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.mediumGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaConnections(IntegrationsState state) {
    if (state.isLoading && state.metaConnections.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.metaConnections.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.facebook,
                size: 48,
                color: AppTheme.mediumGrey.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'No Meta connections',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Add a connection to access Meta services',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: state.metaConnections.map((connection) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildMetaConnectionCard(connection),
        );
      }).toList(),
    );
  }

  Widget _buildMetaConnectionCard(MetaConnection connection) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: connection.isActive
                      ? const Color(0x1A1877F2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.facebook,
                  color: connection.isActive
                      ? const Color(0xFF1877F2)
                      : AppTheme.mediumGrey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App ID: ${connection.appId}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: connection.isActive
                            ? AppTheme.successGreen.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        connection.isActive ? 'ACTIVE' : 'INACTIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: connection.isActive
                              ? AppTheme.successGreen
                              : AppTheme.mediumGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'validate':
                      _validateMetaConnection(connection.id);
                      break;
                    case 'edit':
                      _showEditMetaDialog(connection);
                      break;
                    case 'delete':
                      _deleteMetaConnection(connection.id);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'validate',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 18),
                        SizedBox(width: 8),
                        Text('Validate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: AppTheme.errorRed),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppTheme.errorRed)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (connection.pageId != null || connection.adAccountId != null) ...[
            const SizedBox(height: 12),
            if (connection.pageId != null)
              Text(
                'Page ID: ${connection.pageId}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGrey,
                ),
              ),
            if (connection.adAccountId != null)
              Text(
                'Ad Account: ${connection.adAccountId}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.mediumGrey,
                ),
              ),
          ],
          if (connection.lastValidationError != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 16,
                    color: AppTheme.errorRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      connection.lastValidationError!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Dialog and action methods
  void _showCreateWhatsAppDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateWhatsAppScreen(),
      ),
    ).then((result) {
      if (result == true) {
        // Reload connections after successful creation
        ref.read(integrationsProvider.notifier).loadAllConnections();
      }
    });
  }

  void _showCreateMetaDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateMetaScreen(),
      ),
    ).then((result) {
      if (result == true) {
        // Reload connections after successful creation
        ref.read(integrationsProvider.notifier).loadAllConnections();
      }
    });
  }

  void _showEditWhatsAppDialog(WhatsAppConnection connection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateWhatsAppScreen(connection: connection),
      ),
    ).then((result) {
      if (result == true) {
        // Reload connections after successful update
        ref.read(integrationsProvider.notifier).loadAllConnections();
      }
    });
  }

  void _showEditMetaDialog(MetaConnection connection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateMetaScreen(connection: connection),
      ),
    ).then((result) {
      if (result == true) {
        // Reload connections after successful update
        ref.read(integrationsProvider.notifier).loadAllConnections();
      }
    });
  }

  Future<void> _validateWhatsAppConnection(String connectionId) async {
    final result = await ref
        .read(integrationsProvider.notifier)
        .validateWhatsAppConnection(connectionId);

    if (!mounted) return;

    if (result != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                result.valid ? Icons.check_circle : Icons.error,
                color: result.valid ? AppTheme.successGreen : AppTheme.errorRed,
              ),
              const SizedBox(width: 8),
              Text(result.valid ? 'Valid Connection' : 'Invalid Connection'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.displayPhoneNumber != null)
                Text('Phone: ${result.displayPhoneNumber}'),
              if (result.verifiedName != null)
                Text('Name: ${result.verifiedName}'),
              if (result.qualityRating != null)
                Text('Quality: ${result.qualityRating}'),
              if (result.error != null)
                Text(
                  'Error: ${result.error}',
                  style: const TextStyle(color: AppTheme.errorRed),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _validateMetaConnection(String connectionId) async {
    final result = await ref
        .read(integrationsProvider.notifier)
        .validateMetaConnection(connectionId);

    if (!mounted) return;

    if (result != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                result.valid ? Icons.check_circle : Icons.error,
                color: result.valid ? AppTheme.successGreen : AppTheme.errorRed,
              ),
              const SizedBox(width: 8),
              Text(result.valid ? 'Valid Connection' : 'Invalid Connection'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.pageName != null) Text('Page: ${result.pageName}'),
              if (result.adAccountName != null)
                Text('Ad Account: ${result.adAccountName}'),
              if (result.message != null) Text(result.message!),
              if (result.error != null)
                Text(
                  'Error: ${result.error}',
                  style: const TextStyle(color: AppTheme.errorRed),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showWhatsAppTemplates(String connectionId) async {
    await ref
        .read(integrationsProvider.notifier)
        .loadWhatsAppTemplates(connectionId);

    if (!mounted) return;

    final templates = ref.read(integrationsProvider).whatsappTemplates;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WhatsApp Templates'),
        content: SizedBox(
          width: double.maxFinite,
          child: templates == null
              ? const Center(child: CircularProgressIndicator())
              : templates.templates.isEmpty
                  ? const Text('No templates found')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: templates.templates.length,
                      itemBuilder: (context, index) {
                        final template = templates.templates[index];
                        return ListTile(
                          title: Text(template.name),
                          subtitle: Text(
                              '${template.language} - ${template.status}'),
                          trailing: Chip(
                            label: Text(template.category),
                            backgroundColor:
                                AppTheme.primaryGreen.withOpacity(0.1),
                          ),
                        );
                      },
                    ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWhatsAppConnection(String connectionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Connection'),
        content: const Text(
            'Are you sure you want to delete this WhatsApp connection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(integrationsProvider.notifier)
          .deleteWhatsAppConnection(connectionId);

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection deleted successfully')),
        );
      }
    }
  }

  Future<void> _deleteMetaConnection(String connectionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Connection'),
        content:
            const Text('Are you sure you want to delete this Meta connection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref
          .read(integrationsProvider.notifier)
          .deleteMetaConnection(connectionId);

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection deleted successfully')),
        );
      }
    }
  }
}
