import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────
//  Schermata Shop
// ─────────────────────────────────────────
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🏪  SHOP'),
            actions: [
              // Saldo gemme sempre visibile
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Text('💎', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 6),
                    Text(
                      '${game.player.gems}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gem,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Banner informativo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: AppColors.surface,
                child: const Text(
                  '💡 Completa le missioni per guadagnare gemme e riscattare premi reali!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),

              // Lista oggetti
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: game.shopItems.length,
                  itemBuilder: (context, i) {
                    final item = game.shopItems[i];
                    final canAfford = game.player.gems >= item.cost;

                    return _ShopCard(
                      item: item,
                      canAfford: canAfford,
                      onBuy: () => _onBuy(context, game, item.id, item.title, item.icon),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onBuy(BuildContext context, GameProvider game, String id, String title, String icon) {
    final success = game.buyShopItem(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$icon $title sbloccato! Goditi il premio 🎉'),
          backgroundColor: AppColors.gem,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💎 Non hai abbastanza gemme!'),
          backgroundColor: AppColors.hard,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ── Card singolo oggetto del negozio ──
class _ShopCard extends StatelessWidget {
  final ShopItem item;
  final bool canAfford;
  final VoidCallback onBuy;

  const _ShopCard({
    required this.item,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: canAfford
              ? AppColors.gem.withOpacity(0.3)
              : AppColors.textSecondary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: canAfford
            ? [BoxShadow(color: AppColors.gem.withOpacity(0.08), blurRadius: 8)]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icona
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: canAfford
                    ? AppColors.gem.withOpacity(0.12)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(item.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),

            // Testo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: canAfford ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  // Prezzo
                  Row(
                    children: [
                      const Text('💎', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        '${item.cost} gemme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: canAfford ? AppColors.gem : AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Pulsante acquisto
            ElevatedButton(
              onPressed: canAfford ? onBuy : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canAfford ? AppColors.gem : AppColors.surfaceLight,
                foregroundColor: canAfford ? Colors.black : AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                canAfford ? 'Riscatta' : '🔒',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}