import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/project.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/glass_panel.dart';
import '../../core/constants/app_constants.dart';
import 'package:intl/intl.dart';
import 'add_project_sheet.dart';

class ProjectsView extends ConsumerWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final colors = context.colors;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return const EmptyState(
              icon: Icons.work_rounded,
              title: 'No projects yet.',
              subtitle: 'Add your first freelance project to track your income.',
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _buildProjectCard(context, ref, projects[index]);
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
            AddProjectSheet.show(context);
          },
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, WidgetRef ref, Project p) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    Color statusColor;
    switch (p.status) {
      case ProjectStatus.completed:
        statusColor = colors.accentTeal;
        break;
      case ProjectStatus.ongoing:
        statusColor = colors.accentPurple;
        break;
      case ProjectStatus.unpaid:
        statusColor = colors.accentRed;
        break;
    }

    return Dismissible(
      key: ValueKey(p.id),
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
        ref.read(projectRepositoryProvider).delete(p.id);
      },
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push('/project-detail/${p.id}');
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
                      p.name,
                      style: textStyles.headingLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      p.status.name.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
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
                  Icon(Icons.person_outline_rounded, size: 16, color: colors.textMuted),
                  const SizedBox(width: 6),
                  Text(p.clientName, style: textStyles.bodyMedium),
                  const Spacer(),
                  Text(
                    CurrencyFormatter.format(p.totalValue),
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              if (p.deadline != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: colors.accentRed.withValues(alpha: 0.8)),
                    const SizedBox(width: 6),
                    Text(
                      'Deadline: ${DateFormat('dd MMM yyyy').format(p.deadline!)}',
                      style: TextStyle(
                        color: colors.accentRed.withValues(alpha: 0.8),
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
