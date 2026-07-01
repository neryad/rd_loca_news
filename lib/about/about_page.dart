import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Acerca de',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // --- Foto de perfil / Logo de la app ---
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                backgroundImage: const AssetImage('assets/logoNeryNews.jpeg'),
              ),
            ),

            const SizedBox(height: 20),

            // --- Nombre y tagline ---
            Text(
              'Nery News',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Noticias de República Dominicana',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 28),

            // --- Redes sociales ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conecta con el Desarrollador',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _socialButton(
                        context,
                        icon: Icons.business,
                        label: 'LinkedIn',
                        url: 'https://www.linkedin.com/in/dayern-gomez/',
                        colorScheme: colorScheme,
                      ),
                      _socialButton(
                        context,
                        icon: Icons.close,
                        label: 'X',
                        url: 'https://x.com/NeryadG',
                        colorScheme: colorScheme,
                      ),
                      _socialButton(
                        context,
                        icon: Icons.play_circle_outlined,
                        label: 'YouTube',
                        url: 'https://www.youtube.com/@neryad',
                        colorScheme: colorScheme,
                      ),
                      _socialButton(
                        context,
                        icon: Icons.videogame_asset_outlined,
                        label: 'Gaming',
                        url: 'https://www.youtube.com/@neryadg',
                        colorScheme: colorScheme,
                      ),
                      _socialButton(
                        context,
                        icon: Icons.code,
                        label: 'GitHub',
                        url: 'https://github.com/neryad',
                        colorScheme: colorScheme,
                      ),
                      _socialButton(
                        context,
                        icon: Icons.mail_outline,
                        label: 'Email',
                        url: 'mailto:contact@neryad.dev',
                        colorScheme: colorScheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Botones de acción ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.favorite_outline,
                    label: 'Apoya el proyecto',
                    subtitle: 'En Ko-fi',
                    onTap: () => _launchUrl('https://ko-fi.com/neryad'),
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.share_outlined,
                    label: 'Compartir App',
                    subtitle: 'Con tus amigos',
                    onTap: () => _shareApp(context),
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.bug_report_outlined,
                    label: 'Reportar Bug',
                    subtitle: 'Enviar email',
                    onTap: () => _launchUrl(
                        'mailto:contact@neryad.dev?subject=Bug%20Report%20-%20Nery%20News'),
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    context,
                    icon: Icons.star_outline,
                    label: 'Calificar App',
                    subtitle: 'En Play Store',
                    onTap: () => _launchUrl(
                        'https://play.google.com/store/apps/details?id=com.neryad.nery_news'),
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Información de versión ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    'Versión',
                    '1.0.0+1',
                    colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    'Desarrollador',
                    'Neryad',
                    colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    'Plataforma',
                    'Flutter',
                    colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _infoRow(
                    'Fuentes',
                    '6 periódicos',
                    colorScheme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Footer ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Hecho con ❤️ en República Dominicana',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© ${DateTime.now().year} Neryad. Todos los derechos reservados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
    required ColorScheme colorScheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(url),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } on Exception catch (_) {
      // Error al abrir URL
    }
  }

  void _shareApp(BuildContext context) {
    Share.share(
      '📰 ¡Descubre Nery News! La mejor app para estar al día con las noticias de República Dominicana 🇩🇴\n\n'
      '✨ 6 periódicos en una sola app\n'
      '📱 Interfaz moderna y rápida\n'
      '🔖 Guarda tus noticias favoritas\n\n'
      'Descárgala gratis: https://play.google.com/store/apps/details?id=com.neryad.nerynews',
      subject: '📰 Nery News - Noticias de RD',
    );
  }
}
