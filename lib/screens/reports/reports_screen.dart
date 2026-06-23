import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/glass_panel.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(recentTransactionsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return SafeArea(
      bottom: false,
      child: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'No data available for reports',
                style: textStyles.bodyLarge.copyWith(color: colors.textMuted),
              ),
            );
          }

          double totalIncome = 0;
          double totalExpense = 0;

          for (final t in transactions) {
            if (t.direction == TransactionDirection.credit) {
              totalIncome += t.amount;
            } else if (t.direction == TransactionDirection.debit) {
              totalExpense += t.amount;
            }
          }

          final netProfit = totalIncome - totalExpense;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16).copyWith(bottom: 120),
            children: [
              Text('Financial Overview', style: textStyles.displayMedium),
              const SizedBox(height: 24),
              
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Income',
                      amount: totalIncome,
                      icon: Icons.arrow_downward_rounded,
                      color: colors.accentTeal,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Expense',
                      amount: totalExpense,
                      icon: Icons.arrow_upward_rounded,
                      color: colors.accentRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GlassPanel(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Net Profit', style: textStyles.headingLarge),
                    Text(
                      CurrencyFormatter.format(netProfit),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: netProfit >= 0 ? colors.accentTeal : colors.accentRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text('Cash Flow (Last 6 Months)', style: textStyles.headingLarge),
              const SizedBox(height: 16),
              
              // Line Chart
              SizedBox(
                height: 300,
                child: GlassPanel(
                  padding: const EdgeInsets.all(16).copyWith(top: 32, right: 32),
                  child: _buildChart(transactions),
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colors.accentPurple))),
        error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: colors.accentRed))),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Text(title, style: textStyles.bodyMedium.copyWith(color: colors.textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.compactCurrency(symbol: '₹').format(amount),
            style: textStyles.headingLarge.copyWith(fontSize: 22),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<Transaction> transactions) {
    final colors = context.colors;
    
    // Group transactions by month for the last 6 months
    final now = DateTime.now();
    final months = List.generate(6, (i) => DateTime(now.year, now.month - i, 1)).reversed.toList();
    
    List<FlSpot> incomeSpots = [];
    List<FlSpot> expenseSpots = [];
    
    double maxY = 0;

    for (int i = 0; i < months.length; i++) {
      final month = months[i];
      double inc = 0;
      double exp = 0;
      
      for (final t in transactions) {
        if (t.date.year == month.year && t.date.month == month.month) {
          if (t.direction == TransactionDirection.credit) inc += t.amount;
          if (t.direction == TransactionDirection.debit) exp += t.amount;
        }
      }
      
      if (inc > maxY) maxY = inc;
      if (exp > maxY) maxY = exp;
      
      incomeSpots.add(FlSpot(i.toDouble(), inc));
      expenseSpots.add(FlSpot(i.toDouble(), exp));
    }

    if (maxY == 0) maxY = 1000;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4 == 0 ? 1 : maxY / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: colors.borderMid, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  final date = months[value.toInt()];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 4 == 0 ? 1 : maxY / 4,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                return Text(
                  NumberFormat.compactCurrency(symbol: '₹').format(value),
                  style: TextStyle(color: colors.textMuted, fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: maxY * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: colors.accentTeal,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: colors.accentTeal.withValues(alpha: 0.1),
            ),
          ),
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: colors.accentRed,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: colors.accentRed.withValues(alpha: 0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => colors.backgroundElevated,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final isIncome = spot.barIndex == 0;
                return LineTooltipItem(
                  '${isIncome ? 'Income' : 'Expense'}\n${CurrencyFormatter.format(spot.y)}',
                  TextStyle(
                    color: isIncome ? colors.accentTeal : colors.accentRed,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
