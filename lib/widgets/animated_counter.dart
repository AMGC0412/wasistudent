import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Contador animado que cuenta desde 0 hasta un valor objetivo con duración.
class AnimatedCounter extends StatefulWidget {
  final int target;
  final Duration duration;
  final TextStyle? style;
  final String suffix;
  final String prefix;
  final Curve curve;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 1200),
    this.style,
    this.suffix = '',
    this.prefix = '',
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _previousTarget = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _previousTarget = oldWidget.target;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ??
        Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: WasiColors.primary,
            );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentValue =
            (_previousTarget + (widget.target - _previousTarget) * _controller.value)
                .round();
        return Text(
          '${widget.prefix}$currentValue${widget.suffix}',
          style: effectiveStyle,
        );
      },
    );
  }
}
