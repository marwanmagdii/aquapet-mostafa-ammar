import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/tokens/app_tokens.dart';
import '../../data/models/vet.dart';
import '../../data/repositories/app_providers.dart';
import '../../shared/widgets/shared_widgets.dart';

class TrustedVetsScreen extends ConsumerWidget {
  const TrustedVetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = ref.watch(localeProvider).languageCode == 'ar';
    final colors = context.appColors;
    final vetsAsync = ref.watch(vetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.trustedVetsTitle),
            Text(
              l10n.trustedVetsSubtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                  ),
            ),
          ],
        ),
      ),
      body: vetsAsync.when(
        loading: () => AppLoadingState(message: l10n.vetsLoadingMessage),
        error: (_, __) => AppErrorState(
          message: l10n.vetsErrorMessage,
          retryLabel: l10n.vetsRetry,
          onRetry: () => ref.invalidate(vetsProvider),
        ),
        data: (vets) {
          if (vets.isEmpty) {
            return AppEmptyState(
              icon: PhosphorIcons.stethoscope(),
              title: l10n.vetsEmptyTitle,
              subtitle: l10n.vetsEmptySubtitle,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: vets.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => _VetCard(
              vet: vets[index],
              isAr: isAr,
              l10n: l10n,
            ),
          );
        },
      ),
    );
  }
}

class _VetCard extends StatelessWidget {
  const _VetCard({
    required this.vet,
    required this.isAr,
    required this.l10n,
  });

  final VetModel vet;
  final bool isAr;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasPhone = vet.phone != null && vet.phone!.trim().isNotEmpty;
    final hasWhatsapp =
        vet.whatsapp != null && vet.whatsapp!.trim().isNotEmpty;
    final hasMap = vet.mapUrl != null && vet.mapUrl!.trim().isNotEmpty;
    final socials = vet.socialLinks.entries
        .where((e) => e.value.trim().isNotEmpty)
        .toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(
                  PhosphorIcons.stethoscope(),
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vet.name(isAr),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vet.clinic(isAr),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppBadge(
            icon: PhosphorIcons.sealCheck(PhosphorIconsStyle.fill),
            label: l10n.trustedByShopBadge,
            tone: AppBadgeTone.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            vet.specialty(isAr),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.mutedForeground,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                PhosphorIcons.mapPin(),
                size: 16,
                color: colors.mutedForeground,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  vet.area(isAr),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.mutedForeground,
                      ),
                ),
              ),
            ],
          ),
          if (hasPhone || hasWhatsapp || hasMap || socials.isNotEmpty) ...[
            const Divider(height: 24),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (hasPhone)
                  FilledButton.icon(
                    onPressed: () =>
                        _launch(context, 'tel:${vet.phone!.trim()}'),
                    icon: Icon(PhosphorIcons.phone(), size: 18),
                    label: Text(l10n.vetCall),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                  ),
                if (hasWhatsapp)
                  OutlinedButton.icon(
                    onPressed: () => _launch(context, vet.whatsapp!.trim()),
                    icon: Icon(PhosphorIcons.whatsappLogo(), size: 18),
                    label: Text(l10n.vetWhatsapp),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                  ),
                if (hasMap)
                  OutlinedButton.icon(
                    onPressed: () => _launch(context, vet.mapUrl!.trim()),
                    icon: Icon(PhosphorIcons.mapTrifold(), size: 18),
                    label: Text(l10n.vetLocation),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                  ),
                ...socials.map(
                  (entry) => AppIconButton(
                    icon: _socialIcon(entry.key),
                    tooltip: entry.key,
                    color: colors.primary,
                    onPressed: () => _launch(context, entry.value.trim()),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _socialIcon(String platform) {
    return switch (platform.toLowerCase()) {
      'facebook' => PhosphorIcons.facebookLogo(),
      'instagram' => PhosphorIcons.instagramLogo(),
      'tiktok' => PhosphorIcons.tiktokLogo(),
      'youtube' => PhosphorIcons.youtubeLogo(),
      'x' || 'twitter' => PhosphorIcons.xLogo(),
      _ => PhosphorIcons.globe(),
    };
  }

  Future<void> _launch(BuildContext context, String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null) {
      _showLinkError(context);
      return;
    }
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && context.mounted) {
        _showLinkError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showLinkError(context);
      }
    }
  }

  void _showLinkError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.vetLinkError)),
    );
  }
}
