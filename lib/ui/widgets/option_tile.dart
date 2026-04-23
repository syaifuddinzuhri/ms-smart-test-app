import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.shade300,
              width: 2,
            ),
            color: isSelected ? Colors.green.shade50 : Colors.white,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: isSelected ? Colors.green : Colors.grey.shade300,
                child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 15),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }
}