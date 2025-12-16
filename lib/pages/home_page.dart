import 'package:flutter/material.dart';
import 'package:gilo_games/games/reaction_time.dart';
import 'package:gilo_games/games/schulte_table.dart';
import 'package:gilo_games/models/game_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<GameItem> games = [
      GameItem(
        title: 'Schulte Table',
        subtitle: 'Focus & speed training',
        icon: Icons.grid_view,
        page: const SchulteTable(),
      ),
      GameItem(
        title: 'Reaction Time',
        subtitle: 'Tap when green appears',
        icon: Icons.flash_on,
        page: const ReactionTime(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: GridView.builder(
            padding: const EdgeInsets.all(32),
            itemCount: games.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 4 / 3,
            ),
            itemBuilder: (context, index) {
              final game = games[index];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => game.page),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(game.icon, size: 48, color: Colors.blueGrey),
                        const SizedBox(height: 16),
                        Text(
                          game.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          game.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
