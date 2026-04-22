import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────
//  Card per ogni task con animazione al completamento
// ─────────────────────────────────────────
class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // Leggero "press" visivo quando si tocca
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _onComplete() async {
    // Animazione press
    await _ctrl.forward();
    await _ctrl.reverse();
    if (!mounted) return;
    // Notifica il provider
    context.read<GameProvider>().completeTask(widget.task.id);
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final diffColor = task.difficulty.color;

    return ScaleTransition(
      scale: _scale,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          // Bordo sinistro colorato per difficoltà
          border: Border(
            left: BorderSide(color: diffColor, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: diffColor.withOpacity(task.done ? 0.05 : 0.15),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Riga superiore: categoria + titolo + badge difficoltà ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.category.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: task.done
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            decoration:
                                task.done ? TextDecoration.lineThrough : null,
                            decorationColor: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          task.category.label,
                          style: TextStyle(
                            fontSize: 11,
                            color: task.category.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _DifficultyBadge(difficulty: task.difficulty),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: AppColors.surfaceLight, height: 1),
              const SizedBox(height: 10),

              // ── Riga inferiore: stat + pulsante ──
              Row(
                children: [
                  _Chip(icon: '⚡', text: '+${task.xp} XP', color: AppColors.xpGreen),
                  const SizedBox(width: 8),
                  _Chip(icon: '💎', text: '+${task.gems}',   color: AppColors.gem),
                  const SizedBox(width: 8),
                  _Chip(icon: '⏱️', text: '${task.estimatedMinutes}m', color: AppColors.textSecondary),
                  const Spacer(),
                  // ── Pulsante COMPLETA o badge FATTA ──
                  if (!task.done)
                    ElevatedButton(
                      onPressed: _onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: diffColor,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '✓ Completa',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.xpGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.xpGreen.withOpacity(0.5)),
                      ),
                      child: const Text(
                        '✓ Completata',
                        style: TextStyle(
                          color: AppColors.xpGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Badge difficoltà (stelle + label) ──
class _DifficultyBadge extends StatelessWidget {
  final Difficulty difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: difficulty.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: difficulty.color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        children: [
          Text(
            difficulty.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: difficulty.color,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            difficulty.stars,
            style: TextStyle(fontSize: 9, color: difficulty.color),
          ),
        ],
      ),
    );
  }
}

// ── Chip stat generico ──
class _Chip extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  const _Chip({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}