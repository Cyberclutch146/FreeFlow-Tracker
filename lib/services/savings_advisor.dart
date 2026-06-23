import 'package:uuid/uuid.dart';
import '../models/advisor_card.dart';
import '../models/savings_goal.dart';
import '../models/transaction.dart';
import '../models/app_settings.dart';
import '../core/constants/app_constants.dart';

class SavingsAdvisor {
  Future<List<AdvisorCard>> generate({
    required List<SavingsGoal> goals,
    required List<Transaction> currentMonthTxns,
    required List<Transaction> last3MonthsTxns,
    required AppSettings settings,
  }) async {
    final List<AdvisorCard> cards = [];
    final now = DateTime.now();
    
    // Only care about active goals
    final activeGoals = goals.where((g) => g.status == GoalStatus.active).toList();
    if (activeGoals.isEmpty) return cards;

    // Calculate current savings rate (income - expenses) for this month
    double currentIncome = currentMonthTxns.where((t) => t.direction == TransactionDirection.credit).fold(0, (s, t) => s + t.amount);
    double currentExpense = currentMonthTxns.where((t) => t.direction == TransactionDirection.debit).fold(0, (s, t) => s + t.amount);
    double currentSavings = currentIncome - currentExpense;

    void addCard(AdvisorCard? card) {
      if (card != null) cards.add(card);
    }

    // 1. Pace Prediction & 2. Behind Schedule & 6. Milestone Reached
    for (var g in activeGoals) {
      if (g.monthlyAllocation > 0) {
        double remaining = g.targetAmount - g.currentAmount;
        int monthsToCompletion = (remaining / g.monthlyAllocation).ceil();
        DateTime predicted = now.add(Duration(days: monthsToCompletion * 30));
        
        // 1. Pace Prediction
        if (g.deadline != null && predicted.isBefore(g.deadline!)) {
          addCard(AdvisorCard(
            id: const Uuid().v4(),
            capabilityId: 'pace_prediction_${g.id}',
            type: InsightType.info,
            headline: 'Ahead of Schedule: ${g.name}',
            detail: 'At ₹${g.monthlyAllocation.toStringAsFixed(0)}/mo, you will finish ${g.deadline!.difference(predicted).inDays} days before the deadline.',
            generatedAt: now,
            primaryActionType: AdvisorActionType.navigate,
            primaryActionPayload: '/goals',
            isDismissed: false,
          ));
        }

        // 2. Behind Schedule
        if (g.deadline != null && predicted.isAfter(g.deadline!)) {
          int monthsToDeadline = (g.deadline!.difference(now).inDays / 30).ceil();
          if (monthsToDeadline > 0) {
            double requiredAllocation = remaining / monthsToDeadline;
            addCard(AdvisorCard(
              id: const Uuid().v4(),
              capabilityId: 'behind_schedule_${g.id}',
              type: InsightType.warning,
              headline: 'Behind Schedule: ${g.name}',
              detail: 'Increase allocation to ₹${requiredAllocation.toStringAsFixed(0)}/mo to meet your deadline.',
              generatedAt: now,
              primaryActionType: AdvisorActionType.navigate,
              primaryActionPayload: '/goals',
              isDismissed: false,
            ));
          }
        }
      }

      // 6. Milestone Reached
      double percentage = g.currentAmount / g.targetAmount;
      if (percentage >= 0.25 && percentage < 0.26) {
        addCard(_milestoneCard(g, '25%', now));
      } else if (percentage >= 0.50 && percentage < 0.51) {
        addCard(_milestoneCard(g, '50%', now));
      } else if (percentage >= 0.75 && percentage < 0.76) {
        addCard(_milestoneCard(g, '75%', now));
      } else if (percentage >= 1.0) {
        addCard(AdvisorCard(
          id: const Uuid().v4(),
          capabilityId: 'goal_completed_${g.id}',
          type: InsightType.success,
          headline: 'Goal Completed! 🎉',
          detail: 'You have saved ₹${g.targetAmount.toStringAsFixed(0)} for ${g.name}.',
          generatedAt: now,
          primaryActionType: AdvisorActionType.navigate,
          primaryActionPayload: '/goals',
          isDismissed: false,
        ));
      }
    }

    // 3. Goal Achievable & 4. Competing Goals
    double totalAllocationNeeded = activeGoals.fold(0, (s, g) => s + g.monthlyAllocation);
    
    if (totalAllocationNeeded > 0 && currentSavings > totalAllocationNeeded * 1.2) {
      // 3. Goal Achievable
      addCard(AdvisorCard(
        id: const Uuid().v4(),
        capabilityId: 'goal_achievable',
        type: InsightType.success,
        headline: 'Savings on Track',
        detail: 'Your current savings (₹${currentSavings.toStringAsFixed(0)}) comfortably cover your active goals.',
        generatedAt: now,
        primaryActionType: AdvisorActionType.navigate,
        primaryActionPayload: '/goals',
        isDismissed: false,
      ));
    } else if (totalAllocationNeeded > currentSavings && currentSavings > 0) {
      // 4. Competing Goals
      addCard(AdvisorCard(
        id: const Uuid().v4(),
        capabilityId: 'competing_goals',
        type: InsightType.warning,
        headline: 'Goals Conflict',
        detail: 'Your goals need ₹${totalAllocationNeeded.toStringAsFixed(0)}/mo but you are saving ~₹${currentSavings.toStringAsFixed(0)}/mo. Consider adjusting targets.',
        generatedAt: now,
        primaryActionType: AdvisorActionType.navigate,
        primaryActionPayload: '/goals',
        isDismissed: false,
      ));

      // 5. Pause Suggestion
      final lowPriority = activeGoals.where((g) => g.priority == Priority.low).toList();
      final highPriority = activeGoals.where((g) => g.priority == Priority.high).toList();
      if (lowPriority.isNotEmpty && highPriority.isNotEmpty) {
        addCard(AdvisorCard(
          id: const Uuid().v4(),
          capabilityId: 'pause_suggestion',
          type: InsightType.info,
          headline: 'Suggestion: Pause ${lowPriority.first.name}',
          detail: 'Pausing this low-priority goal could free up ₹${lowPriority.first.monthlyAllocation.toStringAsFixed(0)}/mo for ${highPriority.first.name}.',
          generatedAt: now,
          primaryActionType: AdvisorActionType.pauseGoal,
          primaryActionPayload: lowPriority.first.id,
          isDismissed: false,
        ));
      }
    }

    return cards;
  }

  AdvisorCard _milestoneCard(SavingsGoal g, String perc, DateTime now) {
    return AdvisorCard(
      id: const Uuid().v4(),
      capabilityId: 'milestone_${perc}_${g.id}',
      type: InsightType.success,
      headline: 'Milestone Reached! 🎉',
      detail: 'You have hit $perc on your ${g.name} goal! (₹${g.currentAmount.toStringAsFixed(0)} saved)',
      generatedAt: now,
      primaryActionType: AdvisorActionType.navigate,
      primaryActionPayload: '/goals',
      isDismissed: false,
    );
  }
}