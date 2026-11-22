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
      onTap: () => _openProfileSheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _VetAvatar(vet: vet, size: 64),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vet.name(isAr),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vet.clinic(isAr),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    AppBadge(
                      icon: PhosphorIcons.sealCheck(PhosphorIconsStyle.fill),
                      label: l10n.trustedByShopBadge,
                      tone: AppBadgeTone.success,
                    ),
                  ],
                ),
              ),
              Icon(
                isAr ? PhosphorIcons.caretLeft() : PhosphorIcons.caretRight(),
                color: colors.mutedForeground,
              ),
            ],
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
                  (entry) => _SocialBadgeButton(
                    platform: entry.key,
                    onTap: () => _launch(context, entry.value.trim()),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _openProfileSheet(BuildContext context) {
    final colors = context.appColors;
    final hasPhone = vet.phone != null && vet.phone!.trim().isNotEmpty;
    final hasWhatsapp =
        vet.whatsapp != null && vet.whatsapp!.trim().isNotEmpty;
    final hasMap = vet.mapUrl != null && vet.mapUrl!.trim().isNotEmpty;
    final socials = vet.socialLinks.entries
        .where((e) => e.value.trim().isNotEmpty)
        .toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _VetAvatar(vet: vet, size: 78),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vet.name(isAr),
                          style: Theme.of(ctx).textTheme.titleLarge,
                        ),
                        Text(
                          vet.clinic(isAr),
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        AppBadge(
                          icon: PhosphorIcons.sealCheck(
                            PhosphorIconsStyle.fill,
                          ),
                          label: l10n.trustedByShopBadge,
                          tone: AppBadgeTone.success,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                vet.bio(isAr),
                style: Theme.of(ctx).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(PhosphorIcons.stethoscope(), size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(vet.specialty(isAr))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(PhosphorIcons.mapPin(), size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(vet.area(isAr))),
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
                            _launch(ctx, 'tel:${vet.phone!.trim()}'),
                        icon: Icon(PhosphorIcons.phone(), size: 18),
                        label: Text(l10n.vetCall),
                      ),
                    if (hasWhatsapp)
                      OutlinedButton.icon(
                        onPressed: () => _launch(ctx, vet.whatsapp!.trim()),
                        icon: Icon(PhosphorIcons.whatsappLogo(), size: 18),
                        label: Text(l10n.vetWhatsapp),
                      ),
                    if (hasMap)
                      OutlinedButton.icon(
                        onPressed: () => _launch(ctx, vet.mapUrl!.trim()),
                        icon: Icon(PhosphorIcons.mapTrifold(), size: 18),
                        label: Text(l10n.vetLocation),
                      ),
                    ...socials.map(
                      (entry) => _SocialBadgeButton(
                        platform: entry.key,
                        onTap: () => _launch(ctx, entry.value.trim()),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
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

class _VetAvatar extends StatelessWidget {
  const _VetAvatar({required this.vet, required this.size});

  final VetModel vet;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary.withOpacity(0.12),
        border: Border.all(color: colors.primary.withOpacity(0.35), width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        vet.imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          PhosphorIcons.stethoscope(),
          color: colors.primary,
          size: size * 0.45,
        ),
      ),
    );
  }
}

class _SocialBadgeButton extends StatelessWidget {
  const _SocialBadgeButton({
    required this.platform,
    required this.onTap,
  });

  final String platform;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (platform.toLowerCase()) {
      'facebook' => (
          PhosphorIcons.facebookLogo(PhosphorIconsStyle.fill),
          const Color(0xFF1877F2),
        ),
      'instagram' => (
          PhosphorIcons.instagramLogo(PhosphorIconsStyle.fill),
          const Color(0xFFE4405F),
        ),
      'tiktok' => (
          PhosphorIcons.tiktokLogo(PhosphorIconsStyle.fill),
          const Color(0xFF0F172A),
        ),
      'youtube' => (
          PhosphorIcons.youtubeLogo(PhosphorIconsStyle.fill),
          const Color(0xFFDC2626),
        ),
      'x' || 'twitter' => (
          PhosphorIcons.xLogo(PhosphorIconsStyle.fill),
          const Color(0xFF0F172A),
        ),
      _ => (PhosphorIcons.globe(), context.appColors.primary),
    };

    return Tooltip(
      message: platform,
      child: Material(
        color: color.withOpacity(0.12),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, color: color, size: 22),
          ),
        ),
      ),
    );
  }
}
