import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Scroll behaviour for the whole app: on web and desktop a mouse drag scrolls
/// the page, the same way a finger does on a phone.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
  };
}

/// A vertical [SingleChildScrollView] whose mouse-wheel scrolling is eased
/// instead of jumping a whole wheel notch at once.
///
/// Flutter moves the scroll position straight to the wheel delta, so every
/// notch lands as a visible jump and anything driven by the scroll offset
/// (parallax, the bucket animation) stutters between those jumps. This widget
/// takes the wheel over by registering with [PointerSignalResolver] before the
/// [Scrollable] does, then glides toward the accumulated target every frame, so
/// the offset changes continuously.
class SmoothScrollView extends StatefulWidget {
  const SmoothScrollView({super.key, this.controller, required this.child});

  final ScrollController? controller;
  final Widget child;

  @override
  State<SmoothScrollView> createState() => _SmoothScrollViewState();
}

class _SmoothScrollViewState extends State<SmoothScrollView>
    with SingleTickerProviderStateMixin {
  /// How fast the view catches up with the wheel target; ~18 is a short, soft
  /// glide. Higher is snappier, lower feels heavier.
  static const double _responsiveness = 18.0;

  late final Ticker _ticker;
  ScrollController? _ownController;
  Duration? _lastTick;
  double? _target;
  bool _running = false;

  ScrollController get _controller =>
      widget.controller ?? (_ownController ??= ScrollController());

  ScrollPosition? get _position {
    final controller = widget.controller ?? _ownController;
    if (controller == null || !controller.hasClients) return null;
    return controller.position;
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    if (_ticker.isActive) _ticker.stop();
    _ticker.dispose();
    _ownController?.dispose();
    super.dispose();
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final position = _position;
    if (position == null || !position.hasContentDimensions) return;
    // Registering first means the Scrollable's own handler is skipped, so the
    // position is only ever moved by the eased loop below.
    GestureBinding.instance.pointerSignalResolver.register(event, _onWheel);
  }

  void _onWheel(PointerSignalEvent event) {
    final scroll = event as PointerScrollEvent;
    final position = _position;
    if (position == null) return;

    final delta = scroll.scrollDelta.dy != 0
        ? scroll.scrollDelta.dy
        : scroll.scrollDelta.dx;
    if (delta == 0) return;

    final from = (_running && _target != null) ? _target! : position.pixels;
    _target = (from + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((_target! - position.pixels).abs() < 0.5) {
      _stop();
      return;
    }
    _start();
  }

  void _start() {
    if (_running) return;
    _running = true;
    _lastTick = null;
    _ticker.start();
  }

  void _stop() {
    if (!_running) return;
    _running = false;
    _target = null;
    if (_ticker.isActive) _ticker.stop();
  }

  void _onTick(Duration elapsed) {
    final position = _position;
    final target = _target;
    if (position == null || target == null) {
      _stop();
      return;
    }

    final previous = _lastTick;
    _lastTick = elapsed;
    final double dt = previous == null
        ? 1 / 60
        : (elapsed - previous).inMicroseconds / Duration.microsecondsPerSecond;

    final minScroll = position.minScrollExtent;
    final maxScroll = position.maxScrollExtent;
    final goal = target.clamp(minScroll, maxScroll);
    final remaining = goal - position.pixels;

    if (remaining.abs() < 0.5) {
      if ((position.pixels - goal).abs() > 0.01) position.jumpTo(goal);
      _stop();
      return;
    }

    // Frame-rate independent easing, so 60Hz and 144Hz feel the same.
    final step =
        remaining * (1 - math.exp(-_responsiveness * math.min(dt, 0.05)));
    position.jumpTo((position.pixels + step).clamp(minScroll, maxScroll));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      // The listener sits inside the scroll view, i.e. deeper than the
      // Scrollable's own pointer-signal listener, so it wins the resolver.
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: _onPointerSignal,
        child: widget.child,
      ),
    );
  }
}
