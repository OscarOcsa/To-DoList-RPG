import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────
//  Widget riutilizzabile: intestazione giocatore
//  Mostra livello, barra XP e gemme
// ─────────────────────────────────────────
class PlayerHeader extends StatelessWidget {
  const PlayerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final p = game.player;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // ── Avatar con livello ──
                  _LevelBadge(level: p.level),
                  const SizedBox(width: 12),

                  // ── Titolo e XP testuale ──
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          '${p.currentXp} / ${p.xpToNextLevel} XP',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.xpGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Gemme ──
                  _GemCounter(gems: p.gems),
                ],
              ),

              const SizedBox(height: 10),

              // ── Barra XP ──
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: p.xpProgress,
                  minHeight: 8,
                  backgroundColor: AppColors.background,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xpGreen),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Cerchio con il numero di livello ──
class _LevelBadge extends StatelessWidget {
  final int level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚔️', style: TextStyle(fontSize: 14)),
          Text(
            'LV $level',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contatore gemme ──
class _GemCounter extends StatelessWidget {
  final int gems;
  const _GemCounter({required this.gems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gem.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gem.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💎', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            '$gems',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.gem,
            ),
          ),
        ],
      ),
    );
  }
}