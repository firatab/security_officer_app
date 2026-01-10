import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/patrol_tour_model.dart';

class TaskInputWidget extends StatefulWidget {
  final PatrolTaskModel task;
  final String? value;
  final bool isCompleted;
  final void Function(String? value, bool isCompleted) onChanged;

  const TaskInputWidget({
    super.key,
    required this.task,
    this.value,
    required this.isCompleted,
    required this.onChanged,
  });

  @override
  State<TaskInputWidget> createState() => _TaskInputWidgetState();
}

class _TaskInputWidgetState extends State<TaskInputWidget> {
  late TextEditingController _textController;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.value);
    if (widget.task.taskType == 'photo') {
      _photoPath = widget.value;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isCompleted ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isCompleted ? Colors.green[200]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: widget.isCompleted ? Colors.green[700] : null,
                  ),
                ),
              ),
              if (widget.task.isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Required',
                    style: TextStyle(fontSize: 10, color: Colors.red[700]),
                  ),
                ),
              if (widget.isCompleted) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle, size: 18, color: Colors.green[600]),
              ],
            ],
          ),

          if (widget.task.description != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.task.description!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Task input based on type
          _buildTaskInput(),
        ],
      ),
    );
  }

  Widget _buildTaskInput() {
    switch (widget.task.taskType) {
      case 'checkbox':
        return _buildCheckboxInput();
      case 'text':
        return _buildTextInput();
      case 'number':
        return _buildNumberInput();
      case 'select':
        return _buildSelectInput();
      case 'photo':
        return _buildPhotoInput();
      default:
        return _buildCheckboxInput();
    }
  }

  Widget _buildCheckboxInput() {
    return InkWell(
      onTap: () {
        final newValue = widget.value != 'true';
        widget.onChanged(newValue.toString(), newValue);
      },
      child: Row(
        children: [
          Checkbox(
            value: widget.value == 'true',
            onChanged: (value) {
              widget.onChanged(value.toString(), value ?? false);
            },
          ),
          const Text('Mark as done'),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return TextFormField(
      controller: _textController,
      decoration: const InputDecoration(
        hintText: 'Enter your response...',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      maxLines: 2,
      onChanged: (value) {
        widget.onChanged(value, value.trim().isNotEmpty);
      },
    );
  }

  Widget _buildNumberInput() {
    return TextFormField(
      controller: _textController,
      decoration: const InputDecoration(
        hintText: 'Enter a number...',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      onChanged: (value) {
        widget.onChanged(value, value.trim().isNotEmpty);
      },
    );
  }

  Widget _buildSelectInput() {
    final options = widget.task.options ?? [];

    if (options.isEmpty) {
      return const Text('No options available');
    }

    return DropdownButtonFormField<String>(
      value: widget.value,
      decoration: const InputDecoration(
        hintText: 'Select an option',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        widget.onChanged(value, value != null);
      },
    );
  }

  Widget _buildPhotoInput() {
    if (_photoPath != null) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_photoPath!),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.refresh),
                label: const Text('Retake'),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _photoPath = null;
                  });
                  widget.onChanged(null, false);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Remove', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _takePhoto,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Take Photo'),
      ),
    );
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
      widget.onChanged(image.path, true);
    }
  }
}
