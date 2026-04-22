import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/player_header.dart';
import '../widgets/task_card.dart';

// ─────────────────────────────────────────
//  Schermata Missioni (Tasks)
// ─────────────────────────────────────────
class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        // Se c'è stato un level-up, mostra il dialogo DOPO il build
        if (game.justLeveledUp) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showLevelUpDialog(context, game.player.level);
            game.resetLevelUpFlag();
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('⚔️  MISSIONI'),
            actions: [
              // Pulsante per aggiungere una nuova task
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Nuova missione',
                  onPressed: () => _showAddTaskDialog(context, game),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Intestazione giocatore sempre visibile
              const PlayerHeader(),

              // Tab: Attive / Completate
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'ATTIVE  (${game.pendingTasks.length})'),
                          Tab(text: 'FATTE  (${game.completedTasks.length})'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _TaskList(tasks: game.pendingTasks,   completed: false),
                            _TaskList(tasks: game.completedTasks, completed: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ────────────────────────────────────────
  //  Dialogo LEVEL UP!
  // ────────────────────────────────────────
  void _showLevelUpDialog(BuildContext context, int newLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.gold, width: 2),
        ),
        title: const Text(
          '🎉  LEVEL UP!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 22,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text('Sei arrivato al livello',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              '$newLevel',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '✨ Le tue statistiche sono aumentate!',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('AVANTI  →',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  //  Bottom sheet: aggiungi nuova task
  // ────────────────────────────────────────
  void _showAddTaskDialog(BuildContext context, GameProvider game) {
    final titleCtrl   = TextEditingController();
    final minutesCtrl = TextEditingController(text: '30');
    Difficulty      selDifficulty = Difficulty.normale;
    TaskCategory    selCategory   = TaskCategory.produttivita;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titolo sheet
              Row(
                children: [
                  const Text('⚔️', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  const Text(
                    'NUOVA MISSIONE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Campo titolo
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Descrivi la missione…',
                  prefixIcon: Icon(Icons.edit, color: AppColors.textSecondary, size: 18),
                ),
              ),
              const SizedBox(height: 14),

              // Minuti stimati
              TextField(
                controller: minutesCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Tempo stimato (minuti)',
                  prefixIcon: Icon(Icons.timer_outlined, color: AppColors.textSecondary, size: 18),
                ),
              ),
              const SizedBox(height: 14),

              // Difficoltà
              Row(
                children: [
                  const Text('Difficoltà:', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  DropdownButton<Difficulty>(
                    value: selDifficulty,
                    dropdownColor: AppColors.surface,
                    underline: const SizedBox(),
                    style: TextStyle(color: selDifficulty.color, fontWeight: FontWeight.bold),
                    onChanged: (v) => setSheet(() => selDifficulty = v!),
                    items: Difficulty.values.map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(d.label, style: TextStyle(color: d.color)),
                    )).toList(),
                  ),
                ],
              ),

              // Categoria
              Row(
                children: [
                  const Text('Categoria:', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  DropdownButton<TaskCategory>(
                    value: selCategory,
                    dropdownColor: AppColors.surface,
                    underline: const SizedBox(),
                    style: const TextStyle(color: AppColors.textPrimary),
                    onChanged: (v) => setSheet(() => selCategory = v!),
                    items: TaskCategory.values.map((c) => DropdownMenuItem(
                      value: c,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(c.icon),
                          const SizedBox(width: 6),
                          Text(c.label),
                        ],
                      ),
                    )).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Anteprima ricompense
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text('Ricompense: ', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    Text('⚡ +${selDifficulty.baseXp} XP',
                        style: const TextStyle(color: AppColors.xpGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Text('💎 +${selDifficulty.baseGems}',
                        style: const TextStyle(color: AppColors.gem, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Pulsante aggiungi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) return;

                    game.addTask(Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: title,
                      difficulty: selDifficulty,
                      estimatedMinutes: int.tryParse(minutesCtrl.text) ?? 30,
                      xp: selDifficulty.baseXp,
                      gems: selDifficulty.baseGems,
                      category: selCategory,
                    ));
                    Navigator.pop(ctx);
                  },
                  child: const Text(
                    '+ AGGIUNGI MISSIONE',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
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

// ─────────────────────────────────────────
//  Lista task (riutilizzata per Attive / Fatte)
// ─────────────────────────────────────────
class _TaskList extends StatelessWidget {
  final List<Task> tasks;
  final bool completed;
  const _TaskList({required this.tasks, required this.completed});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(completed ? '🏆' : '🎯', style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 10),
            Text(
              completed
                  ? 'Nessuna missione completata ancora'
                  : 'Tutte le missioni sono completate!\nAggiungi nuove sfide.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (_, i) => TaskCard(task: tasks[i]),
    );
  }
}