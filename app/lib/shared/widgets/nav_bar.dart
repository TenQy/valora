import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class NavBarItem {
  const NavBarItem({
    required this.icon,
    required this.label,
  });

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

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.bgBase.withValues(alpha: 0.86),
            border: const Border(
              top: BorderSide(color: AppColors.borderSubtle),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.space20,
                AppSpacing.space8,
                AppSpacing.space20,
                bottomPadding > 0 ? AppSpacing.space8 : AppSpacing.space12,
              ),
              child: Row(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    Expanded(
                      flex: currentIndex == index ? 3 : 1,
                      child: _NavBarButton(
                        item: items[index],
                        isActive: currentIndex == index,
                        onTap: () => onTap(index),
                      ),
                    ),
                    if (index < items.length - 1)
                      const SizedBox(width: AppSpacing.space8),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  static const _animationDuration = Duration(milliseconds: 340);
  static const _animationCurve = Curves.easeOutCubic;

  final NavBarItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: item.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: _animationDuration,
            curve: _animationCurve,
            height: 52,
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? AppSpacing.space16 : AppSpacing.space8,
            ),
            decoration: const BoxDecoration(
              color: AppColors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                AnimatedSwitcher(
                  duration: _animationDuration,
                  switchInCurve: _animationCurve,
                  switchOutCurve: Curves.easeInCubic,
                  child: Icon(
                    item.icon,
                    key: ValueKey(isActive),
                    size: 21,
                    color: isActive
                        ? AppColors.silverMuted
                        : AppColors.bottomNavUnselected,
                  ),
                ),
                Flexible(
                  child: ClipRect(
                    child: AnimatedAlign(
                      duration: _animationDuration,
                      curve: _animationCurve,
                      alignment: Alignment.centerLeft,
                      widthFactor: isActive ? 1 : 0,
                      child: AnimatedOpacity(
                        duration: _animationDuration,
                        curve: _animationCurve,
                        opacity: isActive ? 1 : 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.space8,
                          ),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: AppTextStyles.hint.copyWith(
                              color: AppColors.silverMuted,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.6,
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
        ),
      ),
    );
  }
}
