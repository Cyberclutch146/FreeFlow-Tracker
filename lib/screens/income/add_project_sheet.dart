import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/di/providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_button.dart';
import '../../models/project.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/extensions.dart';
import 'package:intl/intl.dart';

class AddProjectSheet extends ConsumerStatefulWidget {
  final Project? existingProject;
  const AddProjectSheet({super.key, this.existingProject});

  static Future<void> show(BuildContext context, {Project? existingProject}) {
    return AppBottomSheet.show(
      context,
      title: existingProject == null ? 'Add Project' : 'Edit Project',
      child: AddProjectSheet(existingProject: existingProject),
    );
  }

  @override
  ConsumerState<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends ConsumerState<AddProjectSheet> {
  late TextEditingController _nameController;
  late TextEditingController _clientController;
  late TextEditingController _valueController;
  late TextEditingController _notesController;
  
  late ProjectStatus _status;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProject;
    _nameController = TextEditingController(text: p?.name ?? '');
    _clientController = TextEditingController(text: p?.clientName ?? '');
    _valueController = TextEditingController(text: p != null ? p.totalValue.toString() : '');
    _notesController = TextEditingController(text: p?.notes ?? '');
    _status = p?.status ?? ProjectStatus.ongoing;
    _deadline = p?.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clientController.dispose();
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    final name = _nameController.text.trim();
    final client = _clientController.text.trim();
    final valueText = _valueController.text.trim();
    
    if (name.isEmpty || client.isEmpty || valueText.isEmpty) return;
    
    final value = double.tryParse(valueText);
    if (value == null || value <= 0) return;

    final repo = ref.read(projectRepositoryProvider);
    final project = Project(
      id: widget.existingProject?.id ?? const Uuid().v4(),
      name: name,
      clientName: client,
      totalValue: value,
      deadline: _deadline,
      status: _status,
      createdAt: widget.existingProject?.createdAt ?? DateTime.now(),
      notes: _notesController.text.trim(),
    );

    await repo.save(project);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDeadline() async {
    final colors = context.colors;
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: colors.accentPurple,
              onPrimary: colors.textPrimary,
              surface: colors.backgroundSurface,
              onSurface: colors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Project Name',
              labelStyle: TextStyle(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _clientController,
                  decoration: InputDecoration(
                    labelText: 'Client Name',
                    labelStyle: TextStyle(color: colors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<ProjectStatus>(
                  value: _status,
                  isExpanded: true,
                  dropdownColor: colors.backgroundSurface,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(color: colors.textMuted),
                  ),
                  items: ProjectStatus.values.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(
                        s.name.capitalize(),
                        style: textStyles.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _status = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textPrimary),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colors.textMuted),
              hintText: '0',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _pickDeadline,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: colors.borderMid),
                borderRadius: BorderRadius.circular(12),
                color: colors.backgroundElevated,
              ),
              child: Row(
                children: [
                  Icon(Icons.event_rounded, color: colors.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    _deadline != null ? DateFormat('dd MMM yyyy').format(_deadline!) : 'Set Deadline (Optional)',
                    style: textStyles.bodyLarge,
                  ),
                  if (_deadline != null) ...[
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _deadline = null),
                      child: Icon(Icons.close_rounded, size: 18, color: colors.textMuted),
                    ),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              labelStyle: TextStyle(color: colors.textMuted),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: widget.existingProject == null ? 'Save Project' : 'Update Project',
            onPressed: _submit,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
