import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────
//  Enum: livello di difficoltà
// ─────────────────────────────────────────
enum Difficulty { facile, normale, difficile, epica }

extension DifficultyX on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.facile:    return 'Facile';
      case Difficulty.normale:   return 'Normale';
      case Difficulty.difficile: return 'Difficile';
      case Difficulty.epica:     return 'Epica';
    }
  }

  // Icone stelle per visualizzazione rapida
  String get stars {
    switch (this) {
      case Difficulty.facile:    return '★☆☆☆';
      case Difficulty.normale:   return '★★☆☆';
      case Difficulty.difficile: return '★★★☆';
      case Difficulty.epica:     return '★★★★';
    }
  }

  Color get color {
    switch (this) {
      case Difficulty.facile:    return AppColors.easy;
      case Difficulty.normale:   return AppColors.normal;
      case Difficulty.difficile: return AppColors.hard;
      case Difficulty.epica:     return AppColors.epic;
    }
  }

  // XP base per difficoltà
  int get baseXp {
    switch (this) {
      case Difficulty.facile:    return 40;
      case Difficulty.normale:   return 80;
      case Difficulty.difficile: return 130;
      case Difficulty.epica:     return 220;
    }
  }

  // Gemme base per difficoltà
  int get baseGems {
    switch (this) {
      case Difficulty.facile:    return 8;
      case Difficulty.normale:   return 18;
      case Difficulty.difficile: return 30;
      case Difficulty.epica:     return 55;
    }
  }

  // Bonus stat per difficoltà
  int get statBonus {
    switch (this) {
      case Difficulty.facile:    return 1;
      case Difficulty.normale:   return 2;
      case Difficulty.difficile: return 3;
      case Difficulty.epica:     return 5;
    }
  }
}

// ─────────────────────────────────────────
//  Enum: categoria della task
// ─────────────────────────────────────────
enum TaskCategory { studio, sport, produttivita, sociale, salute }

extension TaskCategoryX on TaskCategory {
  String get label {
    switch (this) {
      case TaskCategory.studio:       return 'Studio';
      case TaskCategory.sport:        return 'Sport';
      case TaskCategory.produttivita: return 'Produttività';
      case TaskCategory.sociale:      return 'Sociale';
      case TaskCategory.salute:       return 'Salute';
    }
  }

  String get icon {
    switch (this) {
      case TaskCategory.studio:       return '📚';
      case TaskCategory.sport:        return '💪';
      case TaskCategory.produttivita: return '⚙️';
      case TaskCategory.sociale:      return '👥';
      case TaskCategory.salute:       return '❤️';
    }
  }

  Color get color {
    switch (this) {
      case TaskCategory.studio:       return AppColors.catStudy;
      case TaskCategory.sport:        return AppColors.catSport;
      case TaskCategory.produttivita: return AppColors.catWork;
      case TaskCategory.sociale:      return AppColors.catSocial;
      case TaskCategory.salute:       return AppColors.catHealth;
    }
  }

  // Quale stat aumenta completando questa categoria
  String get statName {
    switch (this) {
      case TaskCategory.studio:       return 'Intelligenza';
      case TaskCategory.sport:        return 'Forza';
      case TaskCategory.produttivita: return 'Disciplina';
      case TaskCategory.sociale:      return 'Disciplina';
      case TaskCategory.salute:       return 'Forza';
    }
  }
}

// ─────────────────────────────────────────
//  Modello Task
// ─────────────────────────────────────────
class Task {
  final String id;
  final String title;
  final Difficulty difficulty;
  final int estimatedMinutes; // tempo stimato
  final int xp;
  final int gems;
  final TaskCategory category;
  bool done;

  Task({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.xp,
    required this.gems,
    required this.category,
    this.done = false,
  });
}