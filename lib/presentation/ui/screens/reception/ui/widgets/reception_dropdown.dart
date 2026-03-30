import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceptionDropdown<T> extends StatelessWidget {
  final String hint;
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;

  const ReceptionDropdown({
    Key? key,
    required this.hint,
    required this.label,
    this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF6B7280),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, color: const Color(0xFFF97316), size: 18),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    hint: Text(
                      hint,
                      style: GoogleFonts.poppins(
                          color: const Color(0xFFD1D5DB), fontSize: 13),
                    ),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 350,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFF97316)),
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF1A1A2E), fontSize: 13),
                    items: items,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
