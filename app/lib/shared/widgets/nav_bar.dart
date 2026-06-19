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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgBase.withValues(alpha: 0.97),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        border: const Border(
          top: BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
      ),
      padding: EdgeInsets.only(
        top: 0,
        bottom: bottomPadding > 0 ? bottomPadding + 10 : 14,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var index = 0; index < items.length; index++)
                Expanded(
                  child: _NavBarButton(
                    item: items[index],
                    isActive: currentIndex == index,
                    onTap: () => onTap(index),
                  ),
                ),
            ],
          ),
        ],
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
    if (widget.isActive == oldWidget.isActive) return;

    if (widget.isActive) {
      _pulseController.stop();
      _pulseController.reset();
      _pulseController.repeat();
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.easeOut;

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
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 4,
                child: AnimatedSlide(
                  duration: _duration,
                  curve: _curve,
                  offset: isActive ? const Offset(0, -0.1) : Offset.zero,
                  child: Text(
                    widget.item.label,
                    style: AppTextStyles.hint.copyWith(
                      color: isActive
                          ? AppColors.silverMuted
                          : AppColors.bottomNavUnselected,
                      fontWeight:
                          isActive ? FontWeight.w500 : FontWeight.w300,
                      fontSize: 9,
                      letterSpacing: 0.3,
                      shadows: const [],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2,
                child: AnimatedSlide(
                  duration: _duration,
                  curve: _curve,
                  offset: isActive ? const Offset(0, -0.45) : Offset.zero,
                  child: AnimatedContainer(
                    duration: _duration,
                    curve: _curve,
                    width: 40,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.silver
                          : AppColors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.silver.withValues(alpha: 0.10),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
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
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: AppColors.silver
                                            .withValues(alpha: 0.15),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        Icon(
                          widget.item.icon,
                          size: 19,
                          color: isActive
                              ? AppColors.bgBase
                              : AppColors.bottomNavUnselected,
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