import 'package:flutter/material.dart';
import 'package:mhgo/core/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 46.0,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() {
      _isHovered = isHovered;
    });
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    // Background & text/icon colors
    Color bg;
    Color fg;
    BorderSide borderSide = BorderSide.none;

    switch (widget.variant) {
      case AppButtonVariant.secondary:
        bg = isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.04);
        fg = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
        if (_isHovered && isEnabled) {
          bg = isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.08);
        }
        break;

      case AppButtonVariant.outlined:
        bg = Colors.transparent;
        fg = isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary;
        borderSide = BorderSide(
          color: _isHovered && isEnabled
              ? theme.colorScheme.primary
              : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          width: 1.2,
        );
        if (_isHovered && isEnabled) {
          bg = theme.colorScheme.primary.withOpacity(isDark ? 0.04 : 0.02);
        }
        break;

      case AppButtonVariant.text:
        bg = Colors.transparent;
        fg = theme.colorScheme.primary;
        if (_isHovered && isEnabled) {
          bg = theme.colorScheme.primary.withOpacity(isDark ? 0.08 : 0.05);
        }
        break;

      case AppButtonVariant.danger:
        bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        fg = isDark ? Colors.red.shade100 : const Color(0xFF991B1B);
        if (_isHovered && isEnabled) {
          bg = isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5);
        }
        break;

      case AppButtonVariant.primary:
      default:
        bg = isDark ? theme.colorScheme.primary : theme.colorScheme.primary;
        fg = Colors.white;
        if (_isHovered && isEnabled) {
          // Darken/lighten primary on hover
          bg = isDark
              ? theme.colorScheme.primary.withOpacity(0.9)
              : theme.colorScheme.primary.withOpacity(0.9);
        }
        break;
    }

    if (!isEnabled) {
      bg = bg.withOpacity(0.4);
      fg = fg.withOpacity(0.4);
      if (borderSide != BorderSide.none) {
        borderSide = BorderSide(
          color: borderSide.color.withOpacity(0.4),
          width: borderSide.width,
        );
      }
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (widget.icon != null) ...[
          Icon(widget.icon, size: 16, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
        if (!widget.isLoading && widget.trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(widget.trailingIcon, size: 16, color: fg),
        ],
      ],
    );

    final buttonStyle = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.isFullWidth ? double.infinity : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: borderSide != BorderSide.none
            ? Border.fromBorderSide(borderSide)
            : null,
      ),
      alignment: Alignment.center,
      child: content,
    );

    if (!isEnabled) return buttonStyle;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: buttonStyle,
        ),
      ),
    );
  }
}
