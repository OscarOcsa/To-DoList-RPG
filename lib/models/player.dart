import 'task.dart';

// ─────────────────────────────────────────
//  Modello Giocatore (Player)
// ─────────────────────────────────────────
class Player {
  int level;
  int currentXp;
  int totalXp;         // XP cumulativo (per statistiche)
  int gems;

  // Stats RPG
  int strength;        // Forza       → sport, salute
  int intelligence;    // Intelligenza → studio
  int discipline;      // Disciplina  → produttività, sociale

  int totalTasksDone;  // Missioni completate totali

  Player({
    this.level          = 1,
    this.currentXp      = 0,
    this.totalXp        = 0,
    this.gems           = 0,
    this.strength       = 0,
    this.intelligence   = 0,
    this.discipline     = 0,
    this.totalTasksDone = 0,
  });

  // ── XP necessaria per salire al prossimo livello ──
  int get xpToNextLevel => level * 100;

  // ── Progresso barra XP (0.0 → 1.0) ──
  double get xpProgress {
    if (xpToNextLevel == 0) return 1.0;
    return (currentXp / xpToNextLevel).clamp(0.0, 1.0);
  }

  // ── Titolo in base al livello ──
  String get title {
    if (level < 5)  return 'Novizio';
    if (level < 10) return 'Avventuriero';
    if (level < 20) return 'Guerriero';
    if (level < 30) return 'Campione';
    return 'Leggenda';
  }

  // ────────────────────────────────────────
  //  Guadagna XP → restituisce true se level up
  // ────────────────────────────────────────
  bool gainXp(int amount) {
    currentXp += amount;
    totalXp   += amount;

    if (currentXp >= xpToNextLevel) {
      currentXp -= xpToNextLevel; // mantieni l'XP in eccesso
      level++;
      return true; // LEVEL UP!
    }
    return false;
  }

  // ────────────────────────────────────────
  //  Gemme
  // ────────────────────────────────────────
  void gainGems(int amount) {
    gems += amount;
  }

  // Restituisce true se l'acquisto va a buon fine
  bool spendGems(int amount) {
    if (gems >= amount) {
      gems -= amount;
      return true;
    }
    return false;
  }

  // ────────────────────────────────────────
  //  Aggiorna le stat in base alla categoria
  // ────────────────────────────────────────
  void updateStats(TaskCategory category, Difficulty difficulty) {
    final bonus = difficulty.statBonus;

    switch (category) {
      case TaskCategory.sport:
      case TaskCategory.salute:
        strength += bonus;
        break;
      case TaskCategory.studio:
        intelligence += bonus;
        break;
      case TaskCategory.produttivita:
      case TaskCategory.sociale:
        discipline += bonus;
        break;
    }
    totalTasksDone++;
  }
}