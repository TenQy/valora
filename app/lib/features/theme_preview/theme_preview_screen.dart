import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_badge.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/language_chip.dart';
import '../../shared/widgets/match_badge.dart';
import '../../shared/widgets/progress_bar.dart';
import '../../shared/widgets/score_item.dart';
import '../../shared/widgets/section_label.dart';
import '../../shared/widgets/skill_chip.dart';

class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _ValoraLogo(),
        actions: [
          IconButton(
            tooltip: 'Notificaciones',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: _NavIcon(Icons.home_outlined),
            activeIcon: _NavIcon(Icons.home_outlined, isActive: true),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(Icons.person_outline),
            activeIcon: _NavIcon(Icons.person_outline, isActive: true),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(Icons.analytics_outlined),
            activeIcon: _NavIcon(Icons.analytics_outlined, isActive: true),
            label: 'Resultados',
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(Icons.work_outline),
            activeIcon: _NavIcon(Icons.work_outline, isActive: true),
            label: 'Proyectos',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space24,
          vertical: AppSpacing.space24,
        ),
        children: const [
          _HeaderPreview(),
          SizedBox(height: AppSpacing.space32),
          _SalaryPreviewCard(),
          SizedBox(height: AppSpacing.space32),
          _ControlsPreview(),
          SizedBox(height: AppSpacing.space32),
          _ComponentsPreview(),
          SizedBox(height: AppSpacing.space32),
          _ScorePreview(),
          SizedBox(height: AppSpacing.space32),
          _JobPreview(),
          SizedBox(height: AppSpacing.space48),
        ],
      ),
    );
  }
}

class _ValoraLogo extends StatelessWidget {
  const _ValoraLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.space8),
        const Text('Valora'),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon(this.icon, {this.isActive = false});

  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 20),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.silver : AppColors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPreview extends StatelessWidget {
  const _HeaderPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Sistema visual'),
        const SizedBox(height: AppSpacing.space12),
        Text('AppTheme oscuro', style: AppTextStyles.h1),
        const SizedBox(height: AppSpacing.space12),
        Text(
          'Pantalla temporal para revisar paleta, tipografias, bordes, '
          'espaciados y componentes base de Valora.',
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}

class _SalaryPreviewCard extends StatelessWidget {
  const _SalaryPreviewCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppCard(
          padding: EdgeInsets.all(AppSpacing.space28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel('Salario estimado'),
              SizedBox(height: AppSpacing.space12),
              Text(
                'Ana Martinez - Flutter Developer',
                style: AppTextStyles.subtitle,
              ),
              SizedBox(height: AppSpacing.space16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(r'$', style: AppTextStyles.currencySymbol),
                  Text('74,000', style: AppTextStyles.salary),
                ],
              ),
              SizedBox(height: AppSpacing.space8),
              Text(
                'Valor central estimado - MXN mensual',
                style: AppTextStyles.hint,
              ),
              SizedBox(height: AppSpacing.space20),
              ProgressBar(value: 0.74, variant: ProgressBarVariant.green),
              SizedBox(height: AppSpacing.space8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r'$58k', style: AppTextStyles.hint),
                  Text(r'$92k', style: AppTextStyles.hint),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: -50,
          right: -40,
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.greenDim, AppColors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlsPreview extends StatelessWidget {
  const _ControlsPreview();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Controles'),
          const SizedBox(height: AppSpacing.space16),
          TextField(
            style: AppTextStyles.subtitle,
            decoration: const InputDecoration(
              hintText: 'Correo electronico',
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          TextField(
            obscureText: true,
            style: AppTextStyles.subtitle,
            decoration: const InputDecoration(
              hintText: 'Contrasena',
              prefixIcon: Icon(Icons.lock_outline),
              errorText: 'Campo requerido',
            ),
          ),
          const SizedBox(height: AppSpacing.space16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Continuar'),
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Cancelar'),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: const Text('Ver detalles'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentsPreview extends StatelessWidget {
  const _ComponentsPreview();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Badges y chips'),
          const SizedBox(height: AppSpacing.space16),
          const Wrap(
            spacing: AppSpacing.space8,
            runSpacing: AppSpacing.space8,
            children: [
              MatchBadge(percentage: 92),
              MatchBadge(percentage: 74),
              AppBadge(label: 'Senior'),
              AppBadge(
                label: 'Perfil incompleto',
                variant: AppBadgeVariant.warning,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space20),
          const Wrap(
            spacing: AppSpacing.space8,
            runSpacing: AppSpacing.space8,
            children: [
              SkillChip(label: 'Flutter'),
              SkillChip(label: 'Supabase'),
              SkillChip(label: 'TypeScript'),
              LanguageChip(flag: 'US', language: 'English', level: 'B2'),
            ],
          ),
          const SizedBox(height: AppSpacing.space20),
          const SectionLabel('Progreso'),
          const SizedBox(height: AppSpacing.space12),
          const ProgressBar(value: 0.68),
          const SizedBox(height: AppSpacing.space8),
          Text('Perfil completado al 68%', style: AppTextStyles.hint),
        ],
      ),
    );
  }
}

class _ScorePreview extends StatelessWidget {
  const _ScorePreview();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel('Score grid'),
        SizedBox(height: AppSpacing.space12),
        Row(
          children: [
            Expanded(
              child: ScoreItem(
                label: 'Indice tecnico',
                value: '83/100',
                caption: 'Top 22% del rol',
              ),
            ),
            SizedBox(width: AppSpacing.space12),
            Expanded(
              child: ScoreItem(
                label: 'Boost idiomas',
                value: r'+$8.4k',
                caption: 'Impacto mensual',
                isMonetary: true,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.space12),
        Row(
          children: [
            Expanded(
              child: ScoreItem(
                label: 'Portfolio',
                value: '71/100',
                caption: 'Evidencia media',
              ),
            ),
            SizedBox(width: AppSpacing.space12),
            Expanded(
              child: ScoreItem(
                label: 'Potencial',
                value: r'$92k',
                caption: 'Maximo estimado',
                isMonetary: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _JobPreview extends StatelessWidget {
  const _JobPreview();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Compatibilidad laboral'),
          const SizedBox(height: AppSpacing.space16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.bgInput,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: const Icon(
                  Icons.business_center_outlined,
                  color: AppColors.silverMuted,
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile Engineer', style: AppTextStyles.userName),
                    const SizedBox(height: AppSpacing.space4),
                    Text('Valora Labs - Remoto', style: AppTextStyles.hint),
                    const SizedBox(height: AppSpacing.space12),
                    const Wrap(
                      spacing: AppSpacing.space8,
                      runSpacing: AppSpacing.space8,
                      children: [
                        SkillChip(label: 'Dart'),
                        SkillChip(label: 'Auth'),
                        AppBadge(
                          label: r'$68k - $86k',
                          variant: AppBadgeVariant.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              const MatchBadge(percentage: 88),
            ],
          ),
        ],
      ),
    );
  }
}
