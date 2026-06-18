import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NavBarItem {
  const NavBarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class NavBar extends StatelessWidget {
  const NavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding > 0 ? bottomPadding + 8 : 22,
        left: 24,
        right: 24,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgBase.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.borderDefault, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x99000000),
                  blurRadius: 30,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < items.length; index++)
                  _NavBarButton(
                    item: items[index],
                    isActive: currentIndex == index,
                    onTap: () => onTap(index),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarButton extends StatefulWidget {
  const _NavBarButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final NavBarItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavBarButton> createState() => _NavBarButtonState();
}

class _NavBarButtonState extends State<_NavBarButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.5), weight: 50),
    ]).animate(_pulseController);

    if (widget.isActive) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(_NavBarButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _pulseController.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  static const _duration = Duration(milliseconds: 420);
  static const _curve = Curves.easeOutBack;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;

    return Semantics(
      button: true,
      selected: isActive,
      label: widget.item.label,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 52,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Label below
              Positioned(
                bottom: 0,
                child: AnimatedSlide(
                  duration: _duration,
                  curve: _curve,
                  offset: isActive ? const Offset(0, -0.15) : Offset.zero,
                  child: AnimatedDefaultTextStyle(
                    duration: _duration,
                    curve: _curve,
                    style: AppTextStyles.hint.copyWith(
                      color: isActive
                          ? AppColors.silverMuted
                          : AppColors.bottomNavUnselected,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w300,
                      fontSize: 9,
                      letterSpacing: 0.3,
                    ),
                    child: Text(widget.item.label),
                  ),
                ),
              ),

              // Icon bubble
              Positioned(
                top: 0,
                child: AnimatedSlide(
                  duration: _duration,
                  curve: _curve,
                  offset: isActive ? const Offset(0, -0.36) : Offset.zero,
                  child: AnimatedContainer(
                    duration: _duration,
                    curve: _curve,
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.silver
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.silver.withValues(alpha: 0.10),
                                blurRadius: 18,
                                spreadRadius: 4,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.40),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse ring
                        if (isActive)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, _) {
                              return Transform.scale(
                                scale: _pulseScale.value,
                                child: Opacity(
                                  opacity: _pulseOpacity.value,
                                  child: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                        color: AppColors.silver.withValues(
                                          alpha: 0.15,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        // Icon
                        AnimatedSwitcher(
                          duration: _duration,
                          switchInCurve: _curve,
                          switchOutCurve: Curves.easeInCubic,
                          child: Icon(
                            widget.item.icon,
                            key: ValueKey(isActive),
                            size: 20,
                            color: isActive
                                ? AppColors.bgBase
                                : AppColors.bottomNavUnselected,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
