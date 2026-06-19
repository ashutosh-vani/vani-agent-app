import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/config/theme.dart';
import 'package:vani_app/models/agent_model.dart';
import 'package:vani_app/presentation/providers/agents_provider.dart';
import 'package:vani_app/screens/agents/create_edit_agent_screen.dart';

class AgentDetailsScreen extends ConsumerStatefulWidget {
  final Agent agent;

  const AgentDetailsScreen({super.key, required this.agent});

  @override
  ConsumerState<AgentDetailsScreen> createState() => _AgentDetailsScreenState();
}

class _AgentDetailsScreenState extends ConsumerState<AgentDetailsScreen> {
  late Agent _currentAgent;

  @override
  void initState() {
    super.initState();
    _currentAgent = widget.agent;
  }

  @override
  Widget build(BuildContext context) {
    final agentsState = ref.watch(agentsProvider);
    
    // Update current agent if it exists in the state
    final updatedAgent = agentsState.agents.firstWhere(
      (agent) => agent.id == _currentAgent.id,
      orElse: () => _currentAgent,
    );
    _currentAgent = updatedAgent;
    
    final phoneNumber = agentsState.getPhoneNumber(_currentAgent);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Back Button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentAgent.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _currentAgent.isActive
                                  ? AppTheme.lightGreen
                                  : const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _currentAgent.isActive ? '● Active' : '● Inactive',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _currentAgent.isActive
                                    ? AppTheme.primaryGreen
                                    : AppTheme.inactiveGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Configuration Details
                _buildDetailSection('Basic Information', [
                  _buildDetailRow('Agent ID', _currentAgent.id),
                  _buildDetailRow('User ID', _currentAgent.userId),
                  _buildDetailRow('Phone Number', phoneNumber),
                ]),

                const SizedBox(height: 16),
                _buildDetailSection('Voice Configuration', [
                  _buildDetailRow('Voice', _currentAgent.voice),
                  _buildDetailRow('TTS Provider', _currentAgent.ttsProvider),
                  _buildDetailRow('TTS Language', _currentAgent.ttsLanguage),
                  _buildDetailRow('TTS Speed', _currentAgent.ttsSpeed.toString()),
                  if (_currentAgent.speechToSpeechProvider != null)
                    _buildDetailRow('S2S Provider', _currentAgent.speechToSpeechProvider!),
                  if (_currentAgent.geminiLiveVoice != null)
                    _buildDetailRow('Gemini Live Voice', _currentAgent.geminiLiveVoice!),
                  if (_currentAgent.geminiLiveLanguage != null)
                    _buildDetailRow('Gemini Live Language', _currentAgent.geminiLiveLanguage!),
                ]),

                const SizedBox(height: 16),
                _buildDetailSection('Call Settings', [
                  _buildDetailRow('Allow Interruptions', _currentAgent.allowInterruptions ? 'Yes' : 'No'),
                  _buildDetailRow('Background Music', _currentAgent.backgroundMusic ? 'Yes' : 'No'),
                  _buildDetailRow('Debug Logging', _currentAgent.debugLogging ? 'Yes' : 'No'),
                  _buildDetailRow('Hard End Call (minutes)', _currentAgent.hardEndCallMinutes.toString()),
                  _buildDetailRow('Cache Hit Rate', '${(_currentAgent.cacheHitRate * 100).toStringAsFixed(1)}%'),
                ]),

                const SizedBox(height: 16),
                _buildDetailSection('Greeting', [
                  _buildDetailRow('Greeting Type', _currentAgent.greetingType),
                  if (_currentAgent.greetingLine != null)
                    _buildDetailText(_currentAgent.greetingLine!),
                ]),

                if (_currentAgent.localFallbackPrompt != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Local Fallback Prompt', [
                    _buildDetailText(_currentAgent.localFallbackPrompt!),
                  ]),
                ],

                if (_currentAgent.agentPrompt != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Agent Prompt', [
                    _buildDetailText(_currentAgent.agentPrompt!),
                  ]),
                ],

                if (_currentAgent.analysisPrompt != null) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Analysis Prompt', [
                    _buildDetailText(_currentAgent.analysisPrompt!),
                  ]),
                ],

                if (_currentAgent.transcriptionLanguages != null && _currentAgent.transcriptionLanguages!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Transcription Languages', [
                    _buildDetailText(_currentAgent.transcriptionLanguages!.join(', ')),
                  ]),
                ],

                if (_currentAgent.knowledgeBaseIds != null && _currentAgent.knowledgeBaseIds!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Knowledge Base IDs', [
                    _buildDetailText(_currentAgent.knowledgeBaseIds!.join(', ')),
                  ]),
                ],

                const SizedBox(height: 16),
                _buildDetailSection('Video Avatar', [
                  _buildDetailRow('Enabled', _currentAgent.enableVideoAvatar ? 'Yes' : 'No'),
                  if (_currentAgent.simliFaceId != null)
                    _buildDetailRow('Simli Face ID', _currentAgent.simliFaceId!),
                ]),

                const SizedBox(height: 16),
                _buildDetailSection('Timestamps', [
                  _buildDetailRow('Created At', _currentAgent.createdAt),
                  _buildDetailRow('Updated At', _currentAgent.updatedAt),
                ]),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEditAgentScreen(agent: _currentAgent),
                            ),
                          ).then((_) {
                            // Reload agents after returning from edit screen
                            ref.read(agentsProvider.notifier).loadAgents();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppTheme.primaryGreen,
                        ),
                        label: const Text(
                          'Edit',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showDeleteConfirmation();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.errorRed),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppTheme.errorRed,
                        ),
                        label: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.errorRed,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppTheme.darkGrey,
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Agent'),
        content: Text('Are you sure you want to delete "${_currentAgent.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(agentsProvider.notifier).deleteAgent(_currentAgent.id);
              Navigator.pop(context); // Go back to agents list
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
