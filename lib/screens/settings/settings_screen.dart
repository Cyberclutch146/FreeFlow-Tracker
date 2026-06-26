import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/glass_panel.dart';
import '../../models/app_settings.dart';
import '../../services/export/csv_export_service.dart';
import '../../services/notification/notification_service.dart';
import '../../services/notification/background_worker.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      appBar: AppBar(
        title: Text('Settings', style: textStyles.headingLarge),
      ),
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              Text('Appearance', style: textStyles.headingMedium).animate().fadeIn().slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildThemeSelector(context, ref, settings).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
              const SizedBox(height: 32),
              
              Text('Preferences', style: textStyles.headingMedium).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildPreferenceTile(
                context: context,
                icon: Icons.track_changes_rounded,
                title: 'Monthly Income Target',
                subtitle: '₹${settings.monthlyIncomeTarget.toStringAsFixed(0)}',
                onTap: () {
                  final controller = TextEditingController(text: settings.monthlyIncomeTarget.toStringAsFixed(0));
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: colors.backgroundElevated,
                      title: Text('Income Target', style: textStyles.headingMedium),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: colors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: colors.textMuted))),
                        TextButton(
                          onPressed: () {
                            final val = double.tryParse(controller.text) ?? 0;
                            ref.read(settingsRepositoryProvider).update((s) => s.copyWith(monthlyIncomeTarget: val));
                            Navigator.pop(ctx);
                          },
                          child: Text('Save', style: TextStyle(color: colors.accentPurple, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                context: context,
                icon: Icons.calendar_today_rounded,
                title: 'Budget Reset Day',
                subtitle: '${settings.budgetResetDay} of every month',
                onTap: () {
                  final controller = TextEditingController(text: settings.budgetResetDay.toString());
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: colors.backgroundElevated,
                      title: Text('Reset Day (1-31)', style: textStyles.headingMedium),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: colors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter day',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: colors.textMuted))),
                        TextButton(
                          onPressed: () {
                            int val = int.tryParse(controller.text) ?? 1;
                            if (val < 1) val = 1;
                            if (val > 31) val = 31;
                            ref.read(settingsRepositoryProvider).update((s) => s.copyWith(budgetResetDay: val));
                            Navigator.pop(ctx);
                          },
                          child: Text('Save', style: TextStyle(color: colors.accentPurple, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                context: context,
                icon: Icons.currency_exchange_rounded,
                title: 'Primary Currency',
                subtitle: settings.currencySymbol,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      final currencies = ['₹', '\$', '€', '£', '¥'];
                      return AlertDialog(
                        backgroundColor: colors.backgroundElevated,
                        title: Text('Select Currency', style: textStyles.headingMedium),
                        content: Wrap(
                          spacing: 12,
                          children: currencies.map((c) => ChoiceChip(
                            label: Text(c, style: const TextStyle(fontSize: 18)),
                            selected: settings.currencySymbol == c,
                            onSelected: (val) {
                              if (val) {
                                ref.read(settingsRepositoryProvider).update((s) => s.copyWith(currencySymbol: c));
                                Navigator.pop(ctx);
                              }
                            },
                            selectedColor: colors.accentPurple.withValues(alpha: 0.3),
                          )).toList(),
                        ),
                      );
                    },
                  );
                },
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2),
              const SizedBox(height: 32),

              Text('Integrations & Managers', style: textStyles.headingMedium).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildActionTile(
                context: context,
                icon: Icons.autorenew_rounded,
                title: 'Subscriptions Manager',
                color: colors.accentAmber,
                onTap: () => context.push('/subscriptions'),
              ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.2),

              Text('AI Engine', style: textStyles.headingMedium).animate().fadeIn(delay: 620.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildPreferenceTile(
                context: context,
                icon: Icons.offline_bolt_rounded,
                title: 'AI Status',
                subtitle: '✅ Offline AI active — no API key needed',
                onTap: () {},
              ).animate().fadeIn(delay: 630.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildPreferenceTile(
                context: context,
                icon: Icons.key_rounded,
                title: 'Gemini API Key',
                subtitle: settings.geminiApiKey?.isNotEmpty == true ? 'Key is set (Tap to change)' : 'Not set (Optional for better SMS parsing)',
                onTap: () {
                  final controller = TextEditingController(text: settings.geminiApiKey ?? '');
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: colors.backgroundElevated,
                      title: Text('Gemini API Key', style: textStyles.headingMedium),
                      content: TextField(
                        controller: controller,
                        style: TextStyle(color: colors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter your API key',
                          hintStyle: TextStyle(color: colors.textMuted),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: colors.textMuted))),
                        TextButton(
                          onPressed: () {
                            final val = controller.text.trim();
                            ref.read(settingsRepositoryProvider).update((s) => s.copyWith(geminiApiKey: val.isEmpty ? null : val));
                            Navigator.pop(ctx);
                          },
                          child: Text('Save', style: TextStyle(color: colors.accentPurple, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(delay: 640.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildActionTile(
                context: context,
                icon: Icons.auto_awesome,
                title: 'Chat with AI Assistant',
                color: colors.accentPurple,
                onTap: () => context.push('/ai-chat'),
              ).animate().fadeIn(delay: 650.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildActionTile(
                context: context,
                icon: Icons.summarize_rounded,
                title: 'Generate AI Report',
                color: colors.accentTeal,
                onTap: () => context.push('/ai-report'),
              ).animate().fadeIn(delay: 665.ms).slideY(begin: 0.2),
              const SizedBox(height: 32),


              Text('Data', style: textStyles.headingMedium).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
              const SizedBox(height: 16),
              _buildActionTile(
                context: context,
                icon: Icons.download_rounded,
                title: 'Export Transactions (CSV)',
                color: colors.accentTeal,
                onTap: () async {
                  final txns = await ref.read(transactionRepositoryProvider).getAll();
                  await CsvExportService.exportTransactions(txns);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transactions exported!'), backgroundColor: colors.backgroundElevated));
                },
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildActionTile(
                context: context,
                icon: Icons.download_rounded,
                title: 'Backup All Data (JSON)',
                color: colors.accentPurple,
                onTap: () async {
                  final dbService = ref.read(databaseServiceProvider);
                  final jsonStr = await dbService.exportAllJson();
                  await CsvExportService.exportJson(jsonStr);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup exported!'), backgroundColor: colors.backgroundElevated));
                },
              ).animate().fadeIn(delay: 850.ms).slideY(begin: 0.2),
              const SizedBox(height: 12),
              _buildActionTile(
                context: context,
                icon: Icons.delete_forever_rounded,
                title: 'Clear All Data',
                color: colors.accentRed,
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: colors.backgroundElevated,
                      title: Text('Clear All Data?', style: textStyles.headingMedium),
                      content: Text('This action cannot be undone.', style: textStyles.bodyMedium),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: colors.textMuted))),
                        TextButton(
                          onPressed: () async {
                            final dbService = ref.read(databaseServiceProvider);
                            await dbService.clearAll();
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All data cleared.'), backgroundColor: colors.accentRed));
                          },
                          child: Text('Delete', style: TextStyle(color: colors.accentRed, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2),
              const SizedBox(height: 60),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: colors.accentPurple)),
        error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: colors.accentRed))),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, WidgetRef ref, AppSettings settings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _buildThemeCard(context, ref, AppThemeMode.dark, 'Dark', Icons.nightlight_round, settings.theme == AppThemeMode.dark)),
        const SizedBox(width: 12),
        Expanded(child: _buildThemeCard(context, ref, AppThemeMode.oled, 'OLED', Icons.brightness_3, settings.theme == AppThemeMode.oled)),
        const SizedBox(width: 12),
        Expanded(child: _buildThemeCard(context, ref, AppThemeMode.light, 'Light', Icons.wb_sunny_rounded, settings.theme == AppThemeMode.light)),
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context, WidgetRef ref, AppThemeMode mode, String label, IconData icon, bool isSelected) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GestureDetector(
      onTap: () {
        ref.read(settingsRepositoryProvider).update((s) => s.copyWith(theme: mode));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected ? colors.accentPurple.withValues(alpha: 0.2) : colors.backgroundElevated.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.accentPurple : colors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? colors.accentPurple : colors.textMuted, size: 32),
            const SizedBox(height: 12),
            Text(label, style: textStyles.bodyMedium.copyWith(color: isSelected ? colors.accentPurple : colors.textMuted, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceTile({required BuildContext context, required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: colors.accentTeal),
        title: Text(title, style: textStyles.bodyLarge),
        subtitle: Text(subtitle, style: textStyles.bodySmall.copyWith(color: colors.textMuted)),
        trailing: Icon(Icons.chevron_right_rounded, color: colors.textMuted),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleTile({required BuildContext context, required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: SwitchListTile(
        secondary: Icon(icon, color: colors.accentPurple),
        title: Text(title, style: textStyles.bodyLarge),
        subtitle: Text(subtitle, style: textStyles.bodySmall.copyWith(color: colors.textMuted)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: colors.accentPurple,
      ),
    );
  }

  Widget _buildActionTile({required BuildContext context, required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    final textStyles = context.textStyles;

    return GlassPanel(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: textStyles.bodyLarge.copyWith(color: color)),
        onTap: onTap,
      ),
    );
  }
}
