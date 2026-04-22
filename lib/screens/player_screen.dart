import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────
//  Schermata Personaggio
// ─────────────────────────────────────────
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final p = game.player;

        return Scaffold(
          appBar: AppBar(title: const Text('🧙  PERSONAGGIO')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // ── Card principale del personaggio ──
                _HeroCard(player: p),
                const SizedBox(height: 16),

                // ── Gemme ──
                _InfoRow(
                  label: 'GEMME DISPONIBILI',
                  value: '${p.gems}',
                  icon: '💎',
                  color: AppColors.gem,
                  subtitle: 'Usa le gemme nello Shop per sbloccare premi reali',
                ),
                const SizedBox(height: 16),

                // ── Sezione statistiche ──
                const _SectionTitle(text: 'STATISTICHE'),
                const SizedBox(height: 8),

                _StatBar(
                  icon: '💪',
                  name: 'Forza',
                  value: p.strength,
                  color: AppColors.catSport,
                  hint: 'Sport & Salute',
                ),
                const SizedBox(height: 8),
                _StatBar(
                  icon: '🧠',
                  name: 'Intelligenza',
                  value: p.intelligence,
                  color: AppColors.catStudy,
                  hint: 'Studio',
                ),
                const SizedBox(height: 8),
                _StatBar(
                  icon: '⚙️',
                  name: 'Disciplina',
                  value: p.discipline,
                  color: AppColors.catWork,
                  hint: 'Produttività & Sociale',
                ),
                const SizedBox(height: 20),

                // ── Riepilogo numerico ──
                const _SectionTitle(text: 'RIEPILOGO'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _NumberTile(value: '${p.level}',         label: 'Livello',    icon: '⚔️')),
                    const SizedBox(width: 8),
                    Expanded(child: _NumberTile(value: '${p.totalTasksDone}', label: 'Missioni',   icon: '🏆')),
                    const SizedBox(width: 8),
                    Expanded(child: _NumberTile(value: '${p.totalXp}',        label: 'XP Totali',  icon: '⚡')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Card con avatar, livello e barra XP ──
class _HeroCard extends StatelessWidget {
  final dynamic player; // Player
  const _HeroCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.gold, width: 3),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 25),
              ],
            ),
            child: const Center(child: Text('⚔️', style: TextStyle(fontSize: 40))),
          ),
          const SizedBox(height: 12),

          // Titolo personaggio
          Text(
            player.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 2,
            ),
          ),

          // Numero livello
          Text(
            'LIVELLO ${player.level}',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          // Barra XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('⚡ ESPERIENZA',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, letterSpacing: 1)),
                  Text(
                    '${player.currentXp} / ${player.xpToNextLevel} XP',
                    style: const TextStyle(fontSize: 11, color: AppColors.xpGreen),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: player.xpProgress,
                  minHeight: 14,
                  backgroundColor: AppColors.background,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.xpGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Riga con icona, valore e sottotitolo ──
class _InfoRow extends StatelessWidget {
  final String label, value, icon, subtitle;
  final Color color;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, letterSpacing: 1)),
              Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

// ── Barra statistica ──
class _StatBar extends StatelessWidget {
  final String icon, name, hint;
  final int value;
  final Color color;
  const _StatBar({required this.icon, required this.name, required this.value, required this.color, required this.hint});

  @override
  Widget build(BuildContext context) {
    // Max visivo per la barra (50 punti = piena)
    final barValue = (value / 50).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text(hint, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text(
                '$value',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: barValue,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Titolo sezione ──
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 2,
      ),
    );
  }
}

// ── Tile con numero grande ──
class _NumberTile extends StatelessWidget {
  final String value, label, icon;
  const _NumberTile({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gold)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}