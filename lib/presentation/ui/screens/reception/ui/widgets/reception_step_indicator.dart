import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReceptionStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const ReceptionStepIndicator({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isCompleted = currentStep > stepIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? const Color(0xFFF97316)
                  : const Color(0xFFE5E7EB),
            ),
          );
        }
        final stepIndex = index ~/ 2;
        final isActive = stepIndex == currentStep;
        final isCompleted = stepIndex < currentStep;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFFF97316)
                    : isActive
                        ? const Color(0xFFFFF3E0)
                        : const Color(0xFFF9FAFB),
                border: Border.all(
                  color: isActive || isCompleted
                      ? const Color(0xFFF97316)
                      : const Color(0xFFE5E7EB),
                  width: 2,
                ),
                boxShadow: isActive || isCompleted
                    ? [
                        BoxShadow(
                          color: const Color(0xFFF97316).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Text(
                        '${stepIndex + 1}',
                        style: GoogleFonts.poppins(
                          color: isActive
                              ? const Color(0xFFF97316)
                              : const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              steps[stepIndex],
              style: GoogleFonts.poppins(
                color: isActive || isCompleted
                    ? const Color(0xFFF97316)
                    : const Color(0xFF9CA3AF),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        );
      }),
    );
  }
}
