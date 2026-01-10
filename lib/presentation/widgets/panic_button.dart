import 'package:flutter/material.dart';

class PanicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSending;

  const PanicButton({super.key, required this.onPressed, this.isSending = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ElevatedButton(
        onPressed: isSending ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          elevation: 8,
        ),
        child: isSending
            ? const CircularProgressIndicator(color: Colors.white)
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 40),
                  SizedBox(height: 4),
                  Text('SOS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
      ),
    );
  }
}
