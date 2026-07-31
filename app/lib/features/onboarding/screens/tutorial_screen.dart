import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/animated_app_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../profile/edit_profile_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_TutorialPageData> _pages = [
    _TutorialPageData(
      title: 'Conoce tu valor real',
      description: 'Valora te ayuda a descubrir cuánto deberías estar ganando en el mercado laboral actual basándose en tus habilidades reales.',
      icon: Icons.rocket_launch_outlined,
    ),
    _TutorialPageData(
      title: '¿Cómo funciona?',
      description: 'Nuestra inteligencia artificial analiza tu área profesional, competencias, idiomas y experiencia para darte un estimado salarial y recomendaciones precisas.',
      icon: Icons.auto_awesome_outlined,
    ),
    _TutorialPageData(
      title: 'Comencemos',
      description: 'Para que la magia funcione, necesitamos que completes un mínimo de datos: tu área profesional y algunas competencias clave. ¿Listo?',
      icon: Icons.person_add_alt_1_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Ir a llenar perfil
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const EditProfileScreen(isInitialSetup: true)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: AnimatedAppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Botón saltar
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen(isInitialSetup: true)),
                      );
                    },
                    child: const Text('Saltar', style: TextStyle(color: AppColors.textMuted)),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            page.icon,
                            size: 100,
                            color: AppColors.silver,
                          ),
                          const SizedBox(height: AppSpacing.space48),
                          Text(
                            page.title,
                            style: AppTextStyles.h1.copyWith(fontSize: 28),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.space24),
                          Text(
                            page.description,
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              color: AppColors.textMuted,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Indicadores y botón
              Padding(
                padding: const EdgeInsets.all(AppSpacing.space32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? AppColors.silver : AppColors.borderDefault,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.space48),
                    PrimaryButton(
                      label: _currentPage == _pages.length - 1 ? 'Completar mi perfil' : 'Siguiente',
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialPageData {
  final String title;
  final String description;
  final IconData icon;

  _TutorialPageData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
