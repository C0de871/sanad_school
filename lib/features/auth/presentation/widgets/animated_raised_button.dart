import 'package:flutter/material.dart';

class AnimatedRaisedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color shadowColor;
  final Color foregroundColor;

  const AnimatedRaisedButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    required this.shadowColor,
    required this.foregroundColor,
  });

  @override
  State<AnimatedRaisedButton> createState() => _AnimatedRaisedButtonState();
}

class _AnimatedRaisedButtonState extends State<AnimatedRaisedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _translateAnimation = Tween<double>(
      begin: 0,
      end: 5, // Move up 5 pixels
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double shadowOffset = 5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          // shadowOffset = 0;
        });
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() {
          // shadowOffset = 5;
        });
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() {
          // shadowOffset = 5;
        });
        _controller.reverse();
      },
      onTap: () => _controller.forward(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            // scale: _scaleAnimation.value,
            scale: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: Offset(0, shadowOffset),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Transform(
                transform: Matrix4.identity()
                  // ..scale(_scaleAnimation.value),
                  ..translate(0.0, _translateAnimation.value),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      // shadowOffset = 0;
                    });
                    await _controller.forward();
                    await _controller.reverse();
                    setState(() {
                      // shadowOffset = 5;
                    });
                    widget.onPressed?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(300, 50),
                    backgroundColor: widget.backgroundColor,
                    foregroundColor: widget.foregroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Set the border radius here
                    ),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedRaisedButtonWithChild extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? foregroundColor;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final double lerpValue;
  final double shadowOffset;
  final double borderWidth;
  final bool isDisable;

  const AnimatedRaisedButtonWithChild({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.shadowColor,
    this.foregroundColor,
    required this.child,
    this.borderRadius,
    this.width,
    this.height,
    this.gradient,
    this.onLongPressed,
    this.padding,
    this.lerpValue = 0.3,
    this.shadowOffset = 7,
    this.borderWidth = 0,
    this.isDisable = false,
  });

  @override
  State<AnimatedRaisedButtonWithChild> createState() => _AnimatedRaisedButtonWithChildState();
}

class _AnimatedRaisedButtonWithChildState extends State<AnimatedRaisedButtonWithChild> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _translateAnimation = Tween<double>(
      begin: 0,
      end: widget.shadowOffset, // Move up 5 pixels
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.isDisable) {
          return;
        }
        setState(() {
          // shadowOffset = 0;
        });
        _controller.forward();
      },
      onTapUp: (_) {
        if (widget.isDisable) {
          return;
        }
        setState(() {
          // shadowOffset = 5;
        });
        _controller.reverse();
      },
      onTapCancel: () {
        if (widget.isDisable) {
          return;
        }
        setState(() {
          // shadowOffset = 5;
        });
        _controller.reverse();
      },
      onLongPress: widget.onLongPressed == null
          ? null
          : () {
              if (widget.isDisable) {
                return;
              }
              widget.onLongPressed!();
            },
      onTap: () async {
        if (widget.isDisable) {
          return;
        }
        widget.onPressed?.call();
        await _controller.forward();
        await _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor ?? Color.lerp(widget.gradient?.colors[0] ?? widget.backgroundColor, Theme.of(context).colorScheme.scrim, widget.lerpValue) ?? Colors.transparent,
                  offset: Offset(0, widget.shadowOffset),
                ),
              ],
              borderRadius: widget.borderRadius,
            ),
            child: Transform(
              transform: Matrix4.identity()
                // ..scale(_scaleAnimation.value),
                ..translate(0.0, _translateAnimation.value),
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: widget.borderWidth,
                      color: widget.shadowColor ?? Color.lerp(widget.gradient?.colors[0] ?? widget.backgroundColor, Theme.of(context).colorScheme.scrim, widget.lerpValue) ?? Colors.transparent,
                    ),
                    left: BorderSide(
                      width: widget.borderWidth,
                      color: widget.shadowColor ?? Color.lerp(widget.gradient?.colors[0] ?? widget.backgroundColor, Theme.of(context).colorScheme.scrim, widget.lerpValue) ?? Colors.transparent,
                    ),
                    right: BorderSide(
                      width: widget.borderWidth,
                      color: widget.shadowColor ?? Color.lerp(widget.gradient?.colors[0] ?? widget.backgroundColor, Theme.of(context).colorScheme.scrim, widget.lerpValue) ?? Colors.transparent,
                    ),
                    bottom: BorderSide(
                      width: widget.borderWidth,
                      color: widget.shadowColor ?? Color.lerp(widget.gradient?.colors[0] ?? widget.backgroundColor, Theme.of(context).colorScheme.scrim, widget.lerpValue) ?? Colors.transparent,
                    ),
                  ),
                  color: widget.backgroundColor,
                  gradient: widget.gradient,
                  borderRadius: widget.borderRadius,
                ),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}
