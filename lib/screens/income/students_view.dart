import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/student.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/glass_panel.dart';
import 'add_student_sheet.dart';

class StudentsView extends ConsumerWidget {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsProvider);
    final colors = context.colors;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: studentsAsync.when(
        data: (students) {
          if (students.isEmpty) {
            return const EmptyState(
              icon: Icons.school_rounded,
              title: 'No students yet.',
              subtitle: 'Add your first student to track tuition income.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            itemCount: students.length,
            itemBuilder: (context, index) {
              return _buildStudentCard(context, ref, students[index]);
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colors.accentPurple),
          ),
        ),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.accentRed)),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton(
          backgroundColor: colors.accentPurple,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            AddStudentSheet.show(context);
          },
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, WidgetRef ref, Student s) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return Dismissible(
      key: ValueKey(s.id),
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
        ref.read(studentRepositoryProvider).delete(s.id);
      },
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push('/student-detail/${s.id}');
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassPanel(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      s.name,
                      style: textStyles.headingLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: s.isActive ? colors.accentTeal.withValues(alpha: 0.15) : colors.textMuted.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: s.isActive ? colors.accentTeal.withValues(alpha: 0.3) : colors.borderMid),
                    ),
                    child: Text(
                      s.isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        color: s.isActive ? colors.accentTeal : colors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.menu_book_rounded, size: 16, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Text(s.subject, style: textStyles.bodyMedium),
                  const Spacer(),
                  Text(
                    '${CurrencyFormatter.format(s.feePerSession)}/session',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (s.schedule?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 16, color: colors.accentPurple.withValues(alpha: 0.8)),
                    const SizedBox(width: 6),
                    Text(
                      s.schedule!,
                      style: TextStyle(
                        color: colors.accentPurple.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        ),
      ),
    );
  }
}
