import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/server_config_service.dart';
import '../../../core/utils/logger.dart';
import '../../../main.dart';
import '../../../services/push_notification_service.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _organizationController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // For double-tap detection on logo
  int _logoTapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _loadSavedOrganization();
  }

  /// Load previously saved organization slug
  Future<void> _loadSavedOrganization() async {
    final authService = ref.read(authServiceProvider);
    final savedSlug = await authService.getSavedOrganizationSlug();
    if (savedSlug != null && mounted) {
      setState(() {
        _organizationController.text = savedSlug;
      });
    }
  }

  @override
  void dispose() {
    _organizationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle logo tap for server URL configuration
  void _handleLogoTap() {
    final now = DateTime.now();

    // Reset tap count if more than 500ms between taps
    if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds > 500) {
      _logoTapCount = 0;
    }

    _logoTapCount++;
    _lastTapTime = now;

    // On double tap, show server configuration dialog
    if (_logoTapCount >= 2) {
      _logoTapCount = 0;
      _showServerConfigDialog();
    }
  }

  /// Show dialog to change server API URL
  Future<void> _showServerConfigDialog() async {
    final serverConfig = ref.read(serverConfigProvider);
    final urlController = TextEditingController(text: serverConfig.baseUrl);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _ServerConfigDialog(
        urlController: urlController,
        currentUrl: serverConfig.baseUrl,
        isCustomServer: serverConfig.isCustomServer,
      ),
    );

    if (result == true && mounted) {
      final newUrl = urlController.text.trim();
      if (newUrl.isNotEmpty) {
        final success = await serverConfig.setServerUrl(newUrl);
        if (success && mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Server URL updated to: $newUrl'),
              backgroundColor: Colors.green,
            ),
          );
          // Restart the app to apply changes
          _showRestartDialog();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid URL format'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    urlController.dispose();
  }

  /// Show dialog to restart app after URL change
  void _showRestartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Restart Required'),
        content: const Text(
          'The server URL has been updated. Please restart the app for changes to take effect.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate organization slug is provided
    final organizationSlug = _organizationController.text.trim();
    if (organizationSlug.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your organization code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final loginResponse = await authService.login(
        _emailController.text.trim(),
        _passwordController.text,
        organizationSlug: organizationSlug,
      );

      if (!mounted) return;

      // Check if user has employee profile
      if (loginResponse.user.employee == null) {
        setState(() {
          _errorMessage = 'This account is not associated with a security officer profile. Please contact your administrator.';
          _isLoading = false;
        });
        return;
      }

      AppLogger.info('Login successful: ${loginResponse.user.email}');

      // Initialize and register FCM token for push notifications
      try {
        final pushService = ref.read(pushNotificationServiceProvider);
        await pushService.initialize();
        await pushService.registerToken();
        AppLogger.info('FCM token registered after login');
      } catch (e) {
        AppLogger.error('Failed to register FCM token after login', e);
      }

      if (!mounted) return;

      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      AppLogger.error('Login failed', e);
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title - Double tap to configure server URL
                GestureDetector(
                  onTap: _handleLogoTap,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.security,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Security Officer',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Workforce Management',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),

                // Login Form
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Organization Slug Field
                        TextFormField(
                          controller: _organizationController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            labelText: 'Organization Code',
                            hintText: 'e.g., acme-security',
                            prefixIcon: Icon(Icons.business_outlined),
                            helperText: 'Enter your organization identifier',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your organization code';
                            }
                            return null;
                          },
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _handleLogin(),
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 24),

                        // Error Message
                        if (_errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Footer - show custom server indicator if not default
                Consumer(
                  builder: (context, ref, child) {
                    final serverConfig = ref.watch(serverConfigProvider);
                    return Column(
                      children: [
                        const Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        if (serverConfig.isCustomServer) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Custom Server',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog for configuring server URL
class _ServerConfigDialog extends StatefulWidget {
  final TextEditingController urlController;
  final String currentUrl;
  final bool isCustomServer;

  const _ServerConfigDialog({
    required this.urlController,
    required this.currentUrl,
    required this.isCustomServer,
  });

  @override
  State<_ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<_ServerConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isValidating = false;
  String? _validationError;

  String? _validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a URL';
    }
    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        return 'URL must start with http:// or https://';
      }
      if (!uri.hasAuthority || uri.host.isEmpty) {
        return 'Please enter a valid URL';
      }
    } catch (e) {
      return 'Invalid URL format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Server Configuration'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter the API server URL:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: widget.urlController,
                decoration: InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'https://api.example.com',
                  prefixIcon: const Icon(Icons.link),
                  border: const OutlineInputBorder(),
                  errorText: _validationError,
                ),
                keyboardType: TextInputType.url,
                autocorrect: false,
                validator: _validateUrl,
              ),
              const SizedBox(height: 12),
              if (widget.isCustomServer)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Currently using custom server',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                'Default: http://localhost:3000',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.isCustomServer)
          TextButton(
            onPressed: () async {
              final serverConfig = await ServerConfigService.getInstance();
              await serverConfig.resetToDefault();
              if (context.mounted) {
                Navigator.of(context).pop(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Server URL reset to default. Restart app to apply.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            child: const Text('Reset to Default'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isValidating
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop(true);
                  }
                },
          child: _isValidating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
