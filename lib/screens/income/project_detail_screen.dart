import 'package:flutter/material.dart';
import '../../services/pdf/invoice_service.dart';
import '../../core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/project.dart';
import '../../widgets/common/glass_panel.dart';
import '../../widgets/common/liquid_background.dart';
import 'add_project_sheet.dart';

class ProjectDetailScreen extends ConsumerWidget {
  final String projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final colors = context.colors;
    final textStyles = context.textStyles;

    return LiquidBackground(
      child: Scaffold(backgroundColor: colors.backgroundPrimary, 
        
        appBar: AppBar(
          
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary),
            onPressed: () => context.pop(),
          ),
          actions: [
            projectsAsync.whenOrNull(
              data: (projects) {
                final p = projects.firstWhere((proj) => proj.id == projectId);
                return IconButton(
                  icon: Icon(Icons.edit_rounded, color: colors.textPrimary),
                  onPressed: () => AddProjectSheet.show(context, existingProject: p),
                );
              },
            ) ?? const SizedBox.shrink(),
            const SizedBox(width: 8),
          ],
        ),
        body: projectsAsync.when(
          data: (projects) {
            final project = projects.firstWhere(
              (p) => p.id == projectId,
              orElse: () => Project(
                id: 'not_found',
                name: 'Not Found',
                clientName: 'Unknown',
                totalValue: 0,
                deadline: DateTime.now(),
                status: ProjectStatus.ongoing,
                createdAt: DateTime.now(),
              ),
            );

            if (project.id == 'not_found') {
              return Center(child: Text('Project not found.', style: textStyles.bodyLarge));
            }

            Color statusColor;
            switch (project.status) {
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

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                GlassPanel(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              project.name,
                              style: textStyles.displayMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              project.status.name.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn().slideX(begin: -0.1),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.person_outline_rounded, color: colors.textMuted, size: 20),
                          const SizedBox(width: 8),
                          Text(project.clientName, style: textStyles.bodyLarge),
                        ],
                      ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.backgroundSurface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Value', style: textStyles.bodyMedium),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyFormatter.format(project.totalValue),
                                  style: textStyles.headingLarge.copyWith(color: colors.accentPurple),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Deadline', style: textStyles.bodyMedium),
                                const SizedBox(height: 4),
                                Text(
                                  project.deadline != null ? '${project.deadline!.day}/${project.deadline!.month}/${project.deadline!.year}' : 'No deadline',
                                  style: textStyles.bodyLarge,
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
                
                _buildActionButton(
                  context,
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'Export Invoice (PDF)',
                  color: colors.accentAmber,
                  onTap: () {
                    InvoiceService.generateAndShareInvoice(project);
                  },
                ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
                const SizedBox(height: 12),
                
                _buildActionButton(
                  context,
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Mark as Completed',
                  color: colors.accentTeal,
                  onTap: () {
                    final updated = project.copyWith(status: ProjectStatus.completed);
                    ref.read(projectRepositoryProvider).save(updated);
                  },
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 12),
                
                _buildActionButton(
                  context,
                  icon: Icons.warning_amber_rounded,
                  label: 'Mark as Unpaid',
                  color: colors.accentRed,
                  onTap: () {
                    final updated = project.copyWith(status: ProjectStatus.unpaid);
                    ref.read(projectRepositoryProvider).save(updated);
                  },
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                const SizedBox(height: 12),
                
                _buildActionButton(
                  context,
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Mark as Ongoing',
                  color: colors.accentPurple,
                  onTap: () {
                    final updated = project.copyWith(status: ProjectStatus.ongoing);
                    ref.read(projectRepositoryProvider).save(updated);
                  },
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
              ],
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: colors.accentPurple)),
          error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: colors.accentRed))),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    
    return GestureDetector(
      onTap: onTap,
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(label, style: textStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}
