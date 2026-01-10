import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:security_officer_app/main.dart';

final incidentReportViewModelProvider = StateNotifierProvider.autoDispose<
    IncidentReportViewModel, IncidentReportState>(
  (ref) => IncidentReportViewModel(ref),
);

class IncidentReportScreen extends ConsumerWidget {
  final String shiftId;

  const IncidentReportScreen({super.key, required this.shiftId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(incidentReportViewModelProvider.notifier);
    final state = ref.watch(incidentReportViewModelProvider);

    ref.listen<IncidentReportState>(incidentReportViewModelProvider, (previous, next) {
      if (next.isSubmitted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident report submitted successfully')),
        );
        Navigator.of(context).pop();
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('New Incident Report')),
      body: _buildBody(context, viewModel, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    IncidentReportViewModel viewModel,
    IncidentReportState state,
  ) {
    return Form(
      key: viewModel.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildDropdown(
            label: 'Incident Type',
            value: state.incidentType,
            items: ['Safety Hazard', 'Theft', 'Damage', 'Medical', 'Other'],
            onChanged: viewModel.onIncidentTypeChanged,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Severity',
            value: state.severity,
            items: ['Low', 'Medium', 'High', 'Critical'],
            onChanged: viewModel.onSeverityChanged,
          ),
          const SizedBox(height: 16),
          _buildDescriptionField(viewModel.descriptionController),
          const SizedBox(height: 16),
          _buildMediaPicker(viewModel.pickMedia, state.mediaFiles),
          const SizedBox(height: 24),
          _buildSubmitButton(viewModel, state),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDescriptionField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Description',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter a description' : null,
    );
  }

  Widget _buildMediaPicker(VoidCallback onPickMedia, List<File> mediaFiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: onPickMedia,
          icon: const Icon(Icons.photo_camera),
          label: const Text('Add Photos/Videos'),
        ),
        if (mediaFiles.isNotEmpty)
          Wrap(
            spacing: 8.0,
            children: mediaFiles.map((file) => Image.file(file, width: 100, height: 100)).toList(),
          ),
      ],
    );
  }

  Widget _buildSubmitButton(IncidentReportViewModel viewModel, IncidentReportState state) {
    return state.isSubmitting
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: () => viewModel.submitReport(shiftId),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Submit Report'),
          );
  }
}

// --- State Notifier and State classes ---

class IncidentReportState {
  final String incidentType;
  final String severity;
  final List<File> mediaFiles;
  final bool isSubmitting;
  final bool isSubmitted;
  final String? error;

  IncidentReportState({
    this.incidentType = 'Safety Hazard',
    this.severity = 'Medium',
    this.mediaFiles = const [],
    this.isSubmitting = false,
    this.isSubmitted = false,
    this.error,
  });

  IncidentReportState copyWith({
    String? incidentType,
    String? severity,
    List<File>? mediaFiles,
    bool? isSubmitting,
    bool? isSubmitted,
    String? error,
  }) {
    return IncidentReportState(
      incidentType: incidentType ?? this.incidentType,
      severity: severity ?? this.severity,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      error: error,
    );
  }
}

class IncidentReportViewModel extends StateNotifier<IncidentReportState> {
  final Ref _ref;
  final formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();

  IncidentReportViewModel(this._ref) : super(IncidentReportState());

  void onIncidentTypeChanged(String? value) {
    if (value != null) state = state.copyWith(incidentType: value);
  }

  void onSeverityChanged(String? value) {
    if (value != null) state = state.copyWith(severity: value);
  }

  Future<void> pickMedia() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultipleMedia();
    state = state.copyWith(mediaFiles: [...state.mediaFiles, ...pickedFiles.map((f) => File(f.path))]);
  }

  Future<void> submitReport(String shiftId) async {
    if (!formKey.currentState!.validate()) return;

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final location = await _ref.read(locationServiceProvider).getCurrentLocation();
      final userInfo = await _ref.read(authServiceProvider).getCurrentUserInfo();
      final employeeId = userInfo['employeeId'];
      final tenantId = userInfo['tenantId'];

      if (employeeId == null || tenantId == null) {
        throw Exception('User not authenticated');
      }

      await _ref.read(incidentReportRepositoryProvider).createIncidentReportOnline(
        shiftId: shiftId,
        employeeId: employeeId,
        tenantId: tenantId,
        latitude: location.latitude,
        longitude: location.longitude,
        incidentType: state.incidentType,
        description: descriptionController.text,
        severity: state.severity,
        mediaFiles: state.mediaFiles,
      );
      state = state.copyWith(isSubmitting: false, isSubmitted: true);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
