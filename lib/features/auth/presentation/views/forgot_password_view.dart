import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mhgo/core/theme/app_theme.dart';
import 'package:mhgo/core/widgets/app_button.dart';
import 'package:mhgo/features/auth/presentation/providers/auth_provider.dart';
import 'package:mhgo/features/auth/presentation/views/login_view.dart'; // To reuse SolarBlueprintPainter

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).forgotPassword(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authProvider);

    // Dynamic error popup listener
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(next.errorMessage!)),
              ],
            ),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authProvider.notifier).clearErrors();
      }
    });

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      body: SafeArea(
        child: Row(
          children: [
            // Left Solar Blueprint Branding Column (Desktop only)
            if (isDesktop)
              Expanded(
                flex: 5,
                child: Container(
                  color: isDark
                      ? const Color(0xFF0A2E16)
                      : const Color(0xFFE8F5E9),
                  child: Stack(
                    children: [
                      // Solar Cell Grid Blueprint Painter background
                      Positioned.fill(
                        child: CustomPaint(
                          painter: SolarBlueprintPainter(
                            isDark
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFF81C784),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.wb_sunny_rounded,
                                  color: theme.colorScheme.secondary,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'MHGo',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1.0,
                                      ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Recovery',
                                    style: theme.textTheme.displayMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -2.0,
                                          height: 1.1,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Enter your registered MHG corporate email address to receive password reset links and security guidelines.',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: isDark
                                              ? AppTheme.darkTextSecondary
                                              : AppTheme.lightTextSecondary,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Built for MHG.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Right Form Column (Centered Form for both mobile & desktop)
            Expanded(
              flex: 4,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 24.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Mobile Logo Header
                            if (!isDesktop) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.wb_sunny_rounded,
                                    color: theme.colorScheme.secondary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'MHGo',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],

                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                ref.read(authProvider.notifier).clearErrors();
                                context.pop();
                              },
                              tooltip: 'Back to Sign In',
                            ),
                            const SizedBox(height: 12),

                            if (authState.forgotPasswordSuccess) ...[
                              // Success State
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 56,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Check Your Mail',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We have simulated sending password reset instructions to your work email:\n\n${_emailController.text}\n\nSince this is an offline-first deployment, please note that simulated link operations can be skipped in production.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: AppButton(
                                  text: 'Return to Sign In',
                                  onPressed: () {
                                    ref
                                        .read(authProvider.notifier)
                                        .clearErrors();
                                    context.pop();
                                  },
                                ),
                              ),
                            ] else ...[
                              // Input State
                              Text(
                                'Recover Password',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Enter your work email address, and we will send password reset links.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary,
                                ),
                              ),
                              const SizedBox(height: 28),

                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Work Email Address',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _emailController,
                                      focusNode: _emailFocusNode,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintText: 'e.g. name@mhg.com',
                                        prefixIcon: const Icon(
                                          Icons.email_outlined,
                                          size: 20,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Email is required';
                                        }
                                        if (!val.contains('@') ||
                                            !val.contains('.')) {
                                          return 'Please enter a valid email address';
                                        }
                                        if (!val.trim().toLowerCase().endsWith(
                                          '@mhg.com',
                                        )) {
                                          return 'Email must belong to the @mhg.com domain';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (_) =>
                                          _submitForgotPassword(),
                                    ),
                                    const SizedBox(height: 28),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: AppButton(
                                        text: authState.isLoading
                                            ? 'Sending Request...'
                                            : 'Send Recovery Email',
                                        icon: authState.isLoading
                                            ? null
                                            : Icons.send,
                                        onPressed: authState.isLoading
                                            ? null
                                            : _submitForgotPassword,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
