import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';

/// Pantalla para agregar una nueva reseña.
/// Incluye 6 sliders de calificación (general, limpieza, ubicación,
/// calidad/precio, comunicación, precisión), campo de comentario,
/// pros, contras, placeholder para fotos y botón de enviar.
class AddReviewScreen extends StatefulWidget {
  final String roomId;
  final String roomTitle;

  const AddReviewScreen({
    super.key,
    required this.roomId,
    required this.roomTitle,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double _overallRating = 0;
  double _cleanlinessRating = 0;
  double _locationRating = 0;
  double _valueRating = 0;
  double _communicationRating = 0;
  double _accuracyRating = 0;

  final _commentController = TextEditingController();
  final _prosController = TextEditingController();
  final _consController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    _prosController.dispose();
    _consController.dispose();
    super.dispose();
  }

  bool get _isValid => _overallRating >= 1 && _commentController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva reseña'),
        actions: [
          TextButton.icon(
            onPressed: _isValid && !_isSubmitting ? _submitReview : null,
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text('Publicar'),
            style: TextButton.styleFrom(
              foregroundColor: _isValid ? WasiColors.primary : WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Room Info ──
            _buildRoomInfo(),
            const SizedBox(height: 20),

            // ── Overall Rating ──
            _buildOverallRating(),
            const SizedBox(height: 24),

            // ── Detailed Ratings ──
            _buildSectionTitle('Calificación detallada'),
            const SizedBox(height: 8),
            _buildRatingSlider(
              label: 'Limpieza',
              value: _cleanlinessRating,
              onChanged: (v) => setState(() => _cleanlinessRating = v),
            ),
            _buildRatingSlider(
              label: 'Ubicación',
              value: _locationRating,
              onChanged: (v) => setState(() => _locationRating = v),
            ),
            _buildRatingSlider(
              label: 'Calidad/precio',
              value: _valueRating,
              onChanged: (v) => setState(() => _valueRating = v),
            ),
            _buildRatingSlider(
              label: 'Comunicación',
              value: _communicationRating,
              onChanged: (v) => setState(() => _communicationRating = v),
            ),
            _buildRatingSlider(
              label: 'Precisión',
              value: _accuracyRating,
              onChanged: (v) => setState(() => _accuracyRating = v),
            ),
            const SizedBox(height: 24),

            // ── Comment ──
            _buildSectionTitle('Tu opinión'),
            const SizedBox(height: 8),
            _buildCommentField(),
            const SizedBox(height: 20),

            // ── Pros ──
            _buildSectionTitle('Pros (lo positivo)'),
            const SizedBox(height: 8),
            _buildProsField(),
            const SizedBox(height: 20),

            // ── Cons ──
            _buildSectionTitle('Contras (lo negativo)'),
            const SizedBox(height: 8),
            _buildConsField(),
            const SizedBox(height: 20),

            // ── Photos ──
            _buildSectionTitle('Fotos'),
            const SizedBox(height: 8),
            _buildPhotoPicker(),
            const SizedBox(height: 32),

            // ── Submit Button ──
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ── Room Info ──────────────────────────────────────────────────────

  Widget _buildRoomInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WasiColors.surfaceVariantLight,
        borderRadius: WasiRadius.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: WasiColors.primaryContainer,
              borderRadius: BorderRadius.circular(WasiRadius.md),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: WasiColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.roomTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: WasiColors.textPrimaryLight,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Overall Rating ─────────────────────────────────────────────────

  Widget _buildOverallRating() {
    return Column(
      children: [
        const Text(
          'Calificación general',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final starValue = (i + 1).toDouble();
            return GestureDetector(
              onTap: () => setState(() => _overallRating = starValue),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedScale(
                  scale: _overallRating == starValue ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    starValue <= _overallRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 44,
                    color: starValue <= _overallRating
                        ? WasiColors.accent
                        : WasiColors.outlineLight,
                  ),
                ),
              ),
            );
          }),
        ),
        if (_overallRating > 0) ...[
          const SizedBox(height: 8),
          Text(
            _overallRatingLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _overallRatingColor,
            ),
          ),
        ],
      ],
    );
  }

  String get _overallRatingLabel {
    if (_overallRating >= 5) return '¡Excelente!';
    if (_overallRating >= 4) return 'Muy bueno';
    if (_overallRating >= 3) return 'Regular';
    if (_overallRating >= 2) return 'Deficiente';
    return 'Malo';
  }

  Color get _overallRatingColor {
    if (_overallRating >= 4) return WasiColors.success;
    if (_overallRating >= 3) return WasiColors.accent;
    return WasiColors.error;
  }

  // ── Section Title ──────────────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: WasiColors.textPrimaryLight,
      ),
    );
  }

  // ── Rating Slider ──────────────────────────────────────────────────

  Widget _buildRatingSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: WasiColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: WasiColors.accent,
                inactiveTrackColor: WasiColors.outlineLight.withValues(alpha: 0.3),
                thumbColor: WasiColors.accentDark,
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: value,
                min: 0,
                max: 5,
                divisions: 5,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Text(
              value > 0 ? value.toInt().toString() : '—',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: value > 0 ? WasiColors.accent : WasiColors.textTertiaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Comment Field ──────────────────────────────────────────────────

  Widget _buildCommentField() {
    return TextField(
      controller: _commentController,
      maxLines: 5,
      maxLength: 500,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Cuénta tu experiencia viviendo en esta habitación...',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: WasiColors.textTertiaryLight,
        ),
        filled: true,
        fillColor: WasiColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: WasiRadius.input,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: WasiRadius.input,
          borderSide: const BorderSide(color: WasiColors.primary, width: 1.5),
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  // ── Pros/Cons Fields ───────────────────────────────────────────────

  Widget _buildProsField() {
    return TextField(
      controller: _prosController,
      maxLines: 3,
      maxLength: 200,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Ej: Buena ubicación, propietaria amable...',
        hintStyle: const TextStyle(
          fontSize: 13,
          color: WasiColors.textTertiaryLight,
        ),
        filled: true,
        fillColor: WasiColors.successContainer.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: WasiRadius.input,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: WasiRadius.input,
          borderSide: const BorderSide(color: WasiColors.success, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildConsField() {
    return TextField(
      controller: _consController,
      maxLines: 3,
      maxLength: 200,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Ej: Algo de humedad, internet lento...',
        hintStyle: const TextStyle(
          fontSize: 13,
          color: WasiColors.textTertiaryLight,
        ),
        filled: true,
        fillColor: WasiColors.errorContainer.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: WasiRadius.input,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: WasiRadius.input,
          borderSide: const BorderSide(color: WasiColors.error, width: 1.5),
        ),
      ),
    );
  }

  // ── Photo Picker ───────────────────────────────────────────────────

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selector de fotos próximamente')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: WasiColors.surfaceVariantLight,
          borderRadius: WasiRadius.card,
          border: Border.all(
            color: WasiColors.outlineLight,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 36,
              color: WasiColors.textTertiaryLight,
            ),
            SizedBox(height: 8),
            Text(
              'Toca para agregar fotos',
              style: TextStyle(
                fontSize: 13,
                color: WasiColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Submit Button ──────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isValid && !_isSubmitting ? _submitReview : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: WasiColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: WasiColors.outlineLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: WasiRadius.button,
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Publicar reseña',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  // ── Submit Logic ───────────────────────────────────────────────────

  Future<void> _submitReview() async {
    if (!_isValid) return;

    setState(() => _isSubmitting = true);

    // Simular envío
    await Future.delayed(const Duration(seconds: 1));

    final pros = _prosController.text.trim();
    final cons = _consController.text.trim();

    final review = Review(
      id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
      roomId: widget.roomId,
      userId: 'user-001',
      userName: 'Valentina Rojas Poma',
      userAvatar: 'VR',
      rating: _overallRating.toInt(),
      cleanlinessRating: _cleanlinessRating.toInt(),
      locationRating: _locationRating.toInt(),
      valueRating: _valueRating.toInt(),
      communicationRating: _communicationRating.toInt(),
      accuracyRating: _accuracyRating.toInt(),
      comment: _commentController.text.trim(),
      pros: pros.isNotEmpty ? pros.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList() : [],
      cons: cons.isNotEmpty ? cons.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList() : [],
      timestamp: DateTime.now(),
      isVerified: true,
    );

    if (mounted) {
      context.read<ReviewProvider>().addReview(review);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reseña publicada exitosamente!'),
          backgroundColor: WasiColors.success,
        ),
      );
    }
  }
}
