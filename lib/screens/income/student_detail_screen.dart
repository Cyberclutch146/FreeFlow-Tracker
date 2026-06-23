import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/student.dart';
import '../../widgets/common/glass_panel.dart';
import '../../widgets/common/liquid_background.dart';
import 'add_student_sheet.dart';

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return LiquidBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary),
            onPressed: () => context.pop(),
          ),
          actions: [
            studentsAsync.whenOrNull(
              data: (students) {
                final s = students.firstWhere((st) => st.id == studentId);
                return IconButton(
                  icon: Icon(Icons.edit_rounded, color: colors.textPrimary),
                  onPressed: () => AddStudentSheet.show(context, existingStudent: s),
                );
              },
            ) ?? const SizedBox.shrink(),
            const SizedBox(width: 8),
          ],
        ),
        body: studentsAsync.when(
          data: (students) {
            final student = students.firstWhere(
              (s) => s.id == studentId,
              orElse: () => Student(
                id: 'not_found',
                name: 'Not Found',
                subject: 'Unknown',
                feePerSession: 0,
                schedule: 'None',
                isActive: false,
                createdAt: DateTime.now(),
              ),
            );

            if (student.id == 'not_found') {
              return Center(child: Text('Student not found.', style: textStyles.bodyLarge));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                GlassPanel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: textStyles.displayMedium,
                      ).animate().fadeIn().slideX(begin: -0.1),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.school_rounded, color: colors.accentAmber, size: 20),
                          const SizedBox(width: 8),
                          Text('${student.subject}', style: textStyles.bodyLarge),
                        ],
                      ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
                      if (student.schedule != null && student.schedule!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, color: colors.textMuted, size: 20),
                            const SizedBox(width: 8),
                            Text('${student.schedule}', style: textStyles.bodyMedium),
                          ],
                        ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1),
                      ],
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.backgroundSurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text('Fee Per Session', style: textStyles.bodyMedium),
                                const SizedBox(height: 4),
                                Text(
                                  '${CurrencyFormatter.format(student.feePerSession)}/session',
                                  style: textStyles.headingLarge.copyWith(color: colors.accentAmber),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                Text('Actions', style: textStyles.headingMedium).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 16),
                
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Log session feature coming soon!'), backgroundColor: colors.accentAmber),
                    );
                  },
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.timer_rounded, color: colors.accentAmber),
                        const SizedBox(width: 16),
                        Text('Log New Session', style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Icon(Icons.chevron_right_rounded, color: colors.textMuted),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: colors.accentAmber)),
          error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: colors.accentRed))),
        ),
      ),
    );
  }
}
