import 'package:flutter/material.dart';

class EntryAnimate extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const EntryAnimate({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.08),
  });

  @override
  State<EntryAnimate> createState() => _EntryAnimateState();
}

class _EntryAnimateState extends State<EntryAnimate> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 400),
        offset: _visible ? Offset.zero : widget.offset,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
