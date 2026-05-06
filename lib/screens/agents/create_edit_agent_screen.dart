import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vani_app/config/theme.dart';
import 'package:vani_app/models/agent_model.dart';
import 'package:vani_app/presentation/providers/agents_provider.dart';
import 'package:vani_app/presentation/providers/phone_numbers_provider.dart';
import 'package:vani_app/screens/agents/agent_analysis_config_screen.dart';

class CreateEditAgentScreen extends ConsumerStatefulWidget {
  final Agent? agent; // null for create, non-null for edit

  const CreateEditAgentScreen({super.key, this.agent});

  @override
  ConsumerState<CreateEditAgentScreen> createState() => _CreateEditAgentScreenState();
}

class _CreateEditAgentScreenState extends ConsumerState<CreateEditAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _greetingLineController;
  late TextEditingController _agentPromptController;
  late TextEditingController _analysisPromptController;
  late TextEditingController _hardEndCallMinutesController;
  
  // Form values
  String? _selectedPhoneNumberId;
  String _selectedVoice = 'alloy';
  String _selectedTtsLanguage = 'en';
  String _selectedTtsProvider = 'openai';
  bool _allowInterruptions = true;
  bool _backgroundMusic = false;
  bool _debugLogging = false;
  bool _isActive = true;
  List<String> _transcriptionLanguages = ['en'];
  
  bool _isLoading = false;
  bool _isGeneratingAnalysis = false;
  Map<String, dynamic>? _analysisConfig;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing values if editing
    _nameController = TextEditingController(text: widget.agent?.name ?? '');
    _greetingLineController = TextEditingController(text: widget.agent?.greetingLine ?? '');
    _agentPromptController = TextEditingController(text: widget.agent?.agentPrompt ?? '');
    _analysisPromptController = TextEditingController(text: widget.agent?.analysisPrompt ?? '');
    _hardEndCallMinutesController = TextEditingController(
      text: widget.agent?.hardEndCallMinutes.toString() ?? '30',
    );
    
    if (widget.agent != null) {
      _selectedPhoneNumberId = widget.agent!.phoneNumberId;
      _selectedVoice = widget.agent!.voice.toLowerCase();
      _selectedTtsLanguage = widget.agent!.ttsLanguage.toLowerCase();
      _selectedTtsProvider = widget.agent!.ttsProvider.toLowerCase();
      _allowInterruptions = widget.agent!.allowInterruptions;
      _backgroundMusic = widget.agent!.backgroundMusic;
      _debugLogging = widget.agent!.debugLogging;
      _isActive = widget.agent!.isActive;
      _transcriptionLanguages = widget.agent!.transcriptionLanguages ?? ['en'];
      _analysisConfig = widget.agent!.analysisConfig;
    }
    
    // Load phone numbers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(phoneNumbersProvider.notifier).loadPhoneNumbers();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _greetingLineController.dispose();
    _agentPromptController.dispose();
    _analysisPromptController.dispose();
    _hardEndCallMinutesController.dispose();
    super.dispose();
  }

  Future<void> _generateAnalysisPrompt() async {
    if (_agentPromptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an agent prompt first'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }

    setState(() => _isGeneratingAnalysis = true);
    
    try {
      final analysisPrompt = await ref
          .read(agentsProvider.notifier)
          .generateAnalysisPrompt(_agentPromptController.text.trim());
      
      setState(() {
        _analysisPromptController.text = analysisPrompt;
        _isGeneratingAnalysis = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Analysis prompt generated successfully'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      setState(() => _isGeneratingAnalysis = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate analysis prompt: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Future<void> _saveAgent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final agentData = {
        'name': _nameController.text.trim(),
        'phone_number_id': _selectedPhoneNumberId,
        'voice': _selectedVoice,
        'tts_language': _selectedTtsLanguage,
        'tts_provider': _selectedTtsProvider,
        'greeting_line': _greetingLineController.text.trim().isEmpty 
            ? null 
            : _greetingLineController.text.trim(),
        'agent_prompt': _agentPromptController.text.trim().isEmpty 
            ? null 
            : _agentPromptController.text.trim(),
        'analysis_prompt': _analysisPromptController.text.trim().isEmpty 
            ? null 
            : _analysisPromptController.text.trim(),
        'analysis_config': _analysisConfig,
        'transcription_languages': _transcriptionLanguages,
        'knowledge_base_ids': widget.agent?.knowledgeBaseIds ?? [],
        'allow_interruptions': _allowInterruptions,
        'background_music': _backgroundMusic,
        'debug_logging': _debugLogging,
        'is_frozen': widget.agent?.isFrozen ?? false,
        'hard_end_call_minutes': int.tryParse(_hardEndCallMinutesController.text) ?? 30,
        'is_active': _isActive,
      };

      print('=== SAVE AGENT DEBUG ===');
      print('Is Editing: ${widget.agent != null}');
      print('Agent ID: ${widget.agent?.id}');
      print('Agent Data: $agentData');
      print('========================');

      if (widget.agent == null) {
        // Create new agent
        await ref.read(agentsProvider.notifier).createAgent(agentData);
      } else {
        // Update existing agent
        print('Calling updateAgent with ID: ${widget.agent!.id}');
        await ref.read(agentsProvider.notifier).updateAgent(widget.agent!.id, agentData);
        print('Update completed successfully');
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.agent == null 
                ? 'Agent created successfully' 
                : 'Agent updated successfully'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('=== SAVE AGENT ERROR ===');
      print('Error: $e');
      print('Stack trace: ${StackTrace.current}');
      print('========================');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save agent: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumbersState = ref.watch(phoneNumbersProvider);
    final isEditing = widget.agent != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditing ? 'Edit Agent' : 'Create Agent'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? 'Edit Agent' : 'Create New Agent',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditing 
                                ? 'Update your agent configuration' 
                                : 'Configure your new voice agent',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Basic Information Section
                _buildSectionTitle('Basic Information'),
                const SizedBox(height: 12),
                
                _buildTextField(
                  controller: _nameController,
                  label: 'Agent Name',
                  hint: 'e.g., Customer Support Agent',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an agent name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown<String?>(
                  label: 'Phone Number',
                  value: _selectedPhoneNumberId,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Unassigned'),
                    ),
                    ...phoneNumbersState.phoneNumbers.map((phone) {
                      return DropdownMenuItem<String?>(
                        value: phone.id,
                        child: Text(phone.phoneNumber ?? phone.id),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedPhoneNumberId = value);
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Status',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Switch(
                            value: _isActive,
                            onChanged: (value) {
                              setState(() => _isActive = value);
                            },
                            activeTrackColor: AppTheme.primaryGreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Voice Configuration Section
                _buildSectionTitle('Voice Configuration'),
                const SizedBox(height: 12),

                _buildDropdown<String>(
                  label: 'Voice',
                  value: _selectedVoice,
                  items: ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer', 'ashley']
                      .map((voice) => DropdownMenuItem(
                            value: voice,
                            child: Text(voice[0].toUpperCase() + voice.substring(1)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedVoice = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown<String>(
                  label: 'TTS Provider',
                  value: _selectedTtsProvider,
                  items: ['openai', 'elevenlabs', 'google', 'azure', 'inworld']
                      .map((provider) => DropdownMenuItem(
                            value: provider,
                            child: Text(provider[0].toUpperCase() + provider.substring(1)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTtsProvider = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                _buildDropdown<String>(
                  label: 'TTS Language',
                  value: _selectedTtsLanguage,
                  items: ['en', 'es', 'fr', 'de', 'it', 'pt', 'hi', 'ja', 'ko', 'zh']
                      .map((lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTtsLanguage = value);
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Prompts Section
                _buildSectionTitle('Prompts & Instructions'),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _greetingLineController,
                  label: 'Greeting Line',
                  hint: 'Hello! How can I help you today?',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _agentPromptController,
                  label: 'Agent Prompt',
                  hint: 'You are a helpful customer support agent...',
                  maxLines: 5,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _analysisPromptController,
                  label: 'Analysis Prompt',
                  hint: 'Analyze the conversation and provide insights...',
                  maxLines: 5,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isGeneratingAnalysis ? null : _generateAnalysisPrompt,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: _isGeneratingAnalysis
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(
                                Icons.auto_awesome,
                                size: 18,
                                color: AppTheme.primaryGreen,
                              ),
                        label: Text(
                          _isGeneratingAnalysis 
                              ? 'Generating...' 
                              : 'Generate Prompt',
                          style: const TextStyle(
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
                        onPressed: () async {
                          final config = await Navigator.push<Map<String, dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgentAnalysisConfigScreen(
                                agentPrompt: _agentPromptController.text.trim(),
                                existingConfig: _analysisConfig,
                              ),
                            ),
                          );
                          if (config != null && mounted) {
                            setState(() {
                              _analysisConfig = config;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Analysis config updated'),
                                backgroundColor: AppTheme.primaryGreen,
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _analysisConfig != null 
                                ? AppTheme.primaryGreen 
                                : AppTheme.borderGrey,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(
                          Icons.settings,
                          size: 18,
                          color: _analysisConfig != null 
                              ? AppTheme.primaryGreen 
                              : AppTheme.darkGrey,
                        ),
                        label: Text(
                          _analysisConfig != null ? 'Config Set' : 'Config',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _analysisConfig != null 
                                ? AppTheme.primaryGreen 
                                : AppTheme.darkGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Call Settings Section
                _buildSectionTitle('Call Settings'),
                const SizedBox(height: 12),

                _buildTextField(
                  controller: _hardEndCallMinutesController,
                  label: 'Hard End Call (minutes)',
                  hint: '30',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a value';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildSwitchTile(
                  title: 'Allow Interruptions',
                  subtitle: 'Allow users to interrupt the agent',
                  value: _allowInterruptions,
                  onChanged: (value) {
                    setState(() => _allowInterruptions = value);
                  },
                ),
                const SizedBox(height: 12),

                _buildSwitchTile(
                  title: 'Background Music',
                  subtitle: 'Play background music during calls',
                  value: _backgroundMusic,
                  onChanged: (value) {
                    setState(() => _backgroundMusic = value);
                  },
                ),
                const SizedBox(height: 12),

                _buildSwitchTile(
                  title: 'Debug Logging',
                  subtitle: 'Enable detailed logging for debugging',
                  value: _debugLogging,
                  onChanged: (value) {
                    setState(() => _debugLogging = value);
                  },
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAgent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            isEditing ? 'Update Agent' : 'Create Agent',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.darkGrey,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppTheme.mediumGrey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.errorRed),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }
}
