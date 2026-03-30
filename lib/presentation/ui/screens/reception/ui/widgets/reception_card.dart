import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pda/data/models/reception_entity.dart';

class ReceptionCard extends StatelessWidget {
  final ReceptionEntity reception;

  const ReceptionCard({
    Key? key,
    required this.reception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildIdBadge(),
                const SizedBox(width: 12),
                Expanded(child: _buildRefAndDate()),
              ],
            ),
            const SizedBox(height: 12),
            _buildFinancialRow(),
            if (reception.bateau != null || reception.destination != null) ...[
              const SizedBox(height: 10),
              _buildMetaRow(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIdBadge() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Center(
        child: Text(
          '#${reception.id}',
          style: GoogleFonts.poppins(
            color: const Color(0xFFF97316),
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildRefAndDate() {
    final dateStr = reception.dateReception != null
        ? '${reception.dateReception!.day.toString().padLeft(2, '0')}/${reception.dateReception!.month.toString().padLeft(2, '0')}/${reception.dateReception!.year}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reception.displayRef,
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A2E),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (dateStr != null) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 11, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(
                dateStr,
                style: GoogleFonts.poppins(
                    color: const Color(0xFF9CA3AF), fontSize: 11),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          _FinancialCell(
            label: 'Total HT',
            value: reception.totalHt != null
                ? '${_fmt(reception.totalHt!)} MAD'
                : '—',
            color: const Color(0xFF3B82F6),
          ),
          _vDivider(),
          _FinancialCell(
            label: 'TVA',
            value: reception.totalTva != null
                ? '${_fmt(reception.totalTva!)} MAD'
                : '—',
            color: const Color(0xFFF97316),
          ),
          _vDivider(),
          _FinancialCell(
            label: 'Total TTC',
            value: reception.totalTtc != null
                ? '${_fmt(reception.totalTtc!)} MAD'
                : '—',
            color: const Color(0xFF10B981),
          ),
          _vDivider(),
          _FinancialCell(
            label: 'Frais',
            value: reception.fraisTotals != null
                ? '${_fmt(reception.fraisTotals!)} MAD'
                : '—',
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: const Color(0xFFE5E7EB),
      );

  Widget _buildMetaRow() {
    return Row(
      children: [
        if (reception.bateau != null)
          _MetaChip(
            icon: Icons.directions_boat_rounded,
            label: reception.bateau!,
            color: const Color(0xFF3B82F6),
          ),
        if (reception.bateau != null && reception.destination != null)
          const SizedBox(width: 8),
        if (reception.destination != null)
          Expanded(
            child: _MetaChip(
              icon: Icons.location_on_rounded,
              label: reception.destination!,
              color: const Color(0xFF10B981),
            ),
          ),
      ],
    );
  }

  String _fmt(double v) {
    if (v == v.truncate()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }
}

class _FinancialCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FinancialCell(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 9,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GoogleFonts.poppins(
                color: color, fontSize: 10, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
