import 'package:flutter/material.dart';
import 'package:mhgo/core/theme/app_theme.dart';

enum AppCardVariant { elevated, outlined, glass }

class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.variant = AppCardVariant.outlined,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.borderRadius = AppTheme.borderRadiusLarge,
    this.width,
    this.height,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yOffsetAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _yOffsetAnimation = Tween<double>(
      begin: 0.0,
      end: -3.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.01,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    if (widget.onTap == null) {
      return; // Only animate hover for interactive cards
    }
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve styling based on variant
    Color bg;
    Border? border;
    List<BoxShadow>? shadow;

    switch (widget.variant) {
      case AppCardVariant.elevated:
        bg =
            widget.backgroundColor ??
            (isDark ? AppTheme.darkSurfaceCard : AppTheme.lightSurface);
        border = Border.all(
          color: isDark
              ? AppTheme.darkBorder.withValues(alpha: 0.5)
              : AppTheme.lightBorder.withValues(alpha: 0.5),
          width: 1,
        );
        shadow = _isHovered
            ? (isDark ? AppTheme.darkShadow : AppTheme.lightShadow)
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ];
        break;

      case AppCardVariant.glass:
        bg =
            widget.backgroundColor ??
            (isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.white.withValues(alpha: 0.7));
        border = Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
          width: 1,
        );
        shadow = _isHovered
            ? (isDark ? AppTheme.darkShadow : AppTheme.lightShadow)
            : null;
        break;

      case AppCardVariant.outlined:
      default:
        bg =
            widget.backgroundColor ??
            (isDark ? AppTheme.darkSurface : AppTheme.lightSurface);
        border = Border.all(
          color: _isHovered
              ? theme.colorScheme.primary.withValues(alpha: 0.4)
              : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          width: 1.2,
        );
        shadow = _isHovered
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(
                    alpha: isDark ? 0.12 : 0.05,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null;
        break;
    }

    Widget cardContent = Container(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: border,
        boxShadow: shadow,
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      cardContent = MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _yOffsetAnimation.value),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: cardContent,
          ),
        ),
      );
    }

    return cardContent;
  }
}
