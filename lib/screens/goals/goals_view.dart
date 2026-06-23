import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/savings_goal.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/glass_panel.dart';
import '../../core/constants/app_constants.dart';
import 'add_goal_sheet.dart';

class GoalsView extends ConsumerWidget {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsProvider);
    final colors = context.colors;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return const EmptyState(
              icon: Icons.track_changes_rounded,
              title: 'No savings goals.',
              subtitle: 'Set a goal to start saving for your next big purchase.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              return _buildGoalCard(context, ref, goals[index]);
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colors.accentTeal),
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.accentRed)),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: colors.accentTeal,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            AddGoalSheet.show(context);
          },
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, WidgetRef ref, SavingsGoal g) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    final progress = g.targetAmount > 0 ? (g.currentAmount / g.targetAmount).clamp(0.0, 1.0) : 0.0;
    final isCompleted = g.status == GoalStatus.completed || progress >= 1.0;

    return Dismissible(
      key: ValueKey(g.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: colors.accentRed,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(goalRepositoryProvider).delete(g.id);
      },
      child: GestureDetector(
        onTap: () {
          AddGoalSheet.show(context, existingGoal: g);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassPanel(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Circular Progress
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: colors.borderMid,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? colors.accentTeal : colors.accentPurple,
                        ),
                      ),
                      Center(
                        child: Text(
                          g.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.name,
                        style: textStyles.headingLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${CurrencyFormatter.format(g.currentAmount)} / ${CurrencyFormatter.format(g.targetAmount)}',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}% completed',
                        style: textStyles.bodySmall.copyWith(color: colors.textMuted),
                      ),
                    ],
                  ),
                ),
                
                // Add Funds Button
                if (!isCompleted)
                  IconButton(
                    icon: Icon(Icons.add_circle_outline_rounded, color: colors.accentTeal, size: 28),
                    onPressed: () {
                      // TODO: Add Contribution flow
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
