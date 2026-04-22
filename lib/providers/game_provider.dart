import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/player.dart';

// ─────────────────────────────────────────
//  Modello per gli oggetti nel negozio
// ─────────────────────────────────────────
class ShopItem {
  final String id;
  final String icon;
  final String title;
  final String description;
  final int cost; // costo in gemme

  const ShopItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.cost,
  });
}

// ─────────────────────────────────────────
//  GameProvider — cervello dell'applicazione
//  Tutti i widget leggono e scrivono da qui
// ─────────────────────────────────────────
class GameProvider extends ChangeNotifier {

  // ── Giocatore ──
  final Player player = Player();

  // Flag per mostrare il dialogo di level-up
  bool justLeveledUp = false;

  // ── Lista task predefinite ──
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Studiare Flutter 1 ora',
      difficulty: Difficulty.normale,
      estimatedMinutes: 60,
      xp: 80,
      gems: 18,
      category: TaskCategory.studio,
    ),
    Task(
      id: '2',
      title: 'Allenamento in palestra',
      difficulty: Difficulty.difficile,
      estimatedMinutes: 90,
      xp: 130,
      gems: 30,
      category: TaskCategory.sport,
    ),
    Task(
      id: '3',
      title: 'Leggere 20 minuti',
      difficulty: Difficulty.facile,
      estimatedMinutes: 20,
      xp: 40,
      gems: 8,
      category: TaskCategory.studio,
    ),
    Task(
      id: '4',
      title: 'Meditazione mattutina',
      difficulty: Difficulty.facile,
      estimatedMinutes: 15,
      xp: 30,
      gems: 5,
      category: TaskCategory.salute,
    ),
    Task(
      id: '5',
      title: 'Completare progetto lavoro',
      difficulty: Difficulty.epica,
      estimatedMinutes: 180,
      xp: 220,
      gems: 55,
      category: TaskCategory.produttivita,
    ),
    Task(
      id: '6',
      title: 'Uscita con amici',
      difficulty: Difficulty.normale,
      estimatedMinutes: 120,
      xp: 80,
      gems: 20,
      category: TaskCategory.sociale,
    ),
  ];

  // ── Oggetti nel negozio ──
  final List<ShopItem> shopItems = const [
    ShopItem(id: 's1', icon: '🎮', title: 'Serata Gaming',
      description: '2 ore di videogiochi senza sensi di colpa', cost: 50),
    ShopItem(id: 's2', icon: '👥', title: 'Uscita con Amici',
      description: 'Serata fuori con gli amici', cost: 80),
    ShopItem(id: 's3', icon: '🎬', title: 'Film o Serie TV',
      description: 'Un episodio o un film a tua scelta', cost: 30),
    ShopItem(id: 's4', icon: '🏖️', title: 'Giornata Libera',
      description: 'Nessuna task per oggi — meritata!', cost: 150),
    ShopItem(id: 's5', icon: '🍕', title: 'Premio Goloso',
      description: 'Concediti qualcosa di delizioso', cost: 25),
    ShopItem(id: 's6', icon: '🎵', title: 'Sessione Musica',
      description: '1 ora di musica o podcast', cost: 20),
  ];

  // ── Getter per filtrare le task ──
  List<Task> get pendingTasks   => tasks.where((t) => !t.done).toList();
  List<Task> get completedTasks => tasks.where((t) => t.done).toList();

  // ────────────────────────────────────────
  //  Completa una task
  // ────────────────────────────────────────
  void completeTask(String taskId) {
    final task = tasks.firstWhere((t) => t.id == taskId);
    if (task.done) return; // già completata, ignora

    task.done = true;
    justLeveledUp = player.gainXp(task.xp);
    player.gainGems(task.gems);
    player.updateStats(task.category, task.difficulty);

    notifyListeners(); // aggiorna tutti i widget che ascoltano
  }

  // Chiamato dopo aver mostrato il dialogo di level-up
  void resetLevelUpFlag() {
    justLeveledUp = false;
  }

  // ────────────────────────────────────────
  //  Aggiungi una nuova task
  // ────────────────────────────────────────
  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  // ────────────────────────────────────────
  //  Acquista oggetto dal negozio
  // ────────────────────────────────────────
  bool buyShopItem(String itemId) {
    final item = shopItems.firstWhere((i) => i.id == itemId);
    final success = player.spendGems(item.cost);
    if (success) notifyListeners();
    return success;
  }
}