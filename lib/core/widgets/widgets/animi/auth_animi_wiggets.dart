import 'dart:async';
import 'dart:math';

import 'package:classmate/features/authentication_fetures/presentation/widgets/static_widget/charcater_painter.dart';
import 'package:flutter/material.dart';

class FloatingIcon {
  final UniqueKey key;
  final String text;
  final Offset startOffset;
  final Color color;

  FloatingIcon({
    required this.key,
    required this.text,
    required this.startOffset,
    required this.color,
  });
}

class AuthAnimationScreen extends StatefulWidget {
  final Widget child; // The right-side form content
  final double progress; // 0.0 to 1.0 (Text field typing progress)
  final bool isFocused; // Is the top field focused?
  final bool isEyesClosed; // Is the password field hidden/focused?
  final bool isWhistling; // Is whistling actively?
  final bool isAngry; // Trigger angry/error state
  final bool isHappy; // Trigger happy/success state

  const AuthAnimationScreen({
    Key? key,
    required this.child,
    this.progress = 0.0,
    this.isFocused = false,
    this.isEyesClosed = false,
    this.isWhistling = false,
    this.isAngry = false,
    this.isHappy = false,
  }) : super(key: key);

  @override
  State<AuthAnimationScreen> createState() => _AuthAnimationScreenState();
}

class _AuthAnimationScreenState extends State<AuthAnimationScreen>
    with TickerProviderStateMixin {
  Offset _normalizedPointer = Offset.zero;
  late AnimationController _bobController;
  late AnimationController _shakeController;
  late AnimationController _jumpController;
  final ScrollController _scrollController = ScrollController();

  List<FloatingIcon> _floatingIcons = [];
  Timer? _iconTimer;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Initial check for states
    _checkStateTriggers(null);
  }

  @override
  void didUpdateWidget(covariant AuthAnimationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkStateTriggers(oldWidget);
  }

  void _checkStateTriggers(AuthAnimationScreen? oldWidget) {
    // Angry State
    if (widget.isAngry && (oldWidget == null || !oldWidget.isAngry)) {
      _shakeController.forward(from: 0.0);
      _startIconTimer('angry');
    } else if (!widget.isAngry && (oldWidget != null && oldWidget.isAngry)) {
      _stopIconTimer();
    }

    // Happy State
    if (widget.isHappy && (oldWidget == null || !oldWidget.isHappy)) {
      _jumpController.repeat(reverse: true);
      _startIconTimer('happy');
    } else if (!widget.isHappy && (oldWidget != null && oldWidget.isHappy)) {
      _jumpController.stop();
      _stopIconTimer();
    }

    // Whistling State
    if (widget.isWhistling && (oldWidget == null || !oldWidget.isWhistling)) {
      _startIconTimer('music');
    } else if (!widget.isWhistling &&
        (oldWidget != null && oldWidget.isWhistling)) {
      if (!widget.isAngry && !widget.isHappy) {
        _stopIconTimer();
      }
    }

    // Reset Pointer if in a special state
    if (widget.isWhistling || widget.isAngry || widget.isHappy) {
      _normalizedPointer = Offset.zero;
    }
  }

  @override
  void dispose() {
    _bobController.dispose();
    _shakeController.dispose();
    _jumpController.dispose();
    _scrollController.dispose();
    _iconTimer?.cancel();
    super.dispose();
  }

  void _startIconTimer(String type) {
    _iconTimer?.cancel();
    int ms = type == 'music' ? 400 : (type == 'angry' ? 200 : 150);
    _iconTimer = Timer.periodic(Duration(milliseconds: ms), (timer) {
      _spawnIcon(type);
    });
  }

  void _stopIconTimer() {
    _iconTimer?.cancel();
  }

  void _spawnIcon(String type) {
    final Random rand = Random();
    String text;
    Color color;

    List<Offset> mouthPositions = [
      const Offset(135, 160),
      const Offset(190, 200),
      const Offset(260, 270),
      const Offset(100, 310),
    ];
    Offset startPos = mouthPositions[rand.nextInt(mouthPositions.length)];
    startPos = Offset(
      startPos.dx - 10 + rand.nextDouble() * 20,
      startPos.dy - 30,
    );

    if (type == 'music') {
      List<String> notes = ['♪', '♫', '♬', '♩'];
      text = notes[rand.nextInt(notes.length)];
      List<Color> colors = [
        const Color(0xFF5A47F9),
        const Color(0xFF1C1C1C),
        const Color(0xFFFAC515),
        const Color(0xFFF86737),
      ];
      color = colors[rand.nextInt(colors.length)];
    } else if (type == 'angry') {
      List<String> symbols = ['💢', '🤬', '🗯️', '😡'];
      text = symbols[rand.nextInt(symbols.length)];
      color = Colors.black;
    } else {
      List<String> symbols = ['🎉', '💖', '✨', '😊', '🥳'];
      text = symbols[rand.nextInt(symbols.length)];
      color = Colors.black;
    }

    final newIcon = FloatingIcon(
      key: UniqueKey(),
      text: text,
      startOffset: startPos,
      color: color,
    );

    if (mounted) {
      setState(() {
        _floatingIcons.add(newIcon);
      });
    }

    Future.delayed(Duration(milliseconds: type == 'music' ? 1500 : 1200), () {
      if (mounted) {
        setState(() {
          _floatingIcons.removeWhere((icon) => icon.key == newIcon.key);
        });
      }
    });
  }

  void _handlePointerHover(PointerEvent event) {
    if (widget.isWhistling ||
        widget.isAngry ||
        widget.isHappy ||
        widget.isEyesClosed) {
      return;
    }

    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    setState(() {
      _normalizedPointer = Offset(
        (event.position.dx - centerX) / centerX,
        (event.position.dy - centerY) / centerY,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      body: MouseRegion(
        onHover: _handlePointerHover,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 1000),
              height: isDesktop ? 650 : null,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 30,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                children: [
                  // LEFT SIDE (Graphics Area)
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: Container(
                      height: isDesktop ? double.infinity : 300,
                      color: const Color(0xFFF7F6F1),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          _buildAnimationArea(),
                          _buildFloatingIcons(),
                        ],
                      ),
                    ),
                  ),

                  // RIGHT SIDE (Content Area with Scrollbar)
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: SizedBox(
                      height: isDesktop ? double.infinity : null,
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        radius: const Radius.circular(8),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 30,
                          ),
                          child: widget.child,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationArea() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _bobController,
        _shakeController,
        _jumpController,
      ]),
      builder: (context, child) {
        double shakeOffset = 0;
        if (widget.isAngry) {
          shakeOffset = sin(_shakeController.value * pi * 4) * 10;
        }

        double jumpOffset = 0;
        double bobOffset = 0;
        if (widget.isHappy) {
          jumpOffset = sin(_jumpController.value * pi) * -15;
        } else if (widget.isWhistling) {
          bobOffset = sin(_bobController.value * pi * 2) * -4;
        }

        double bodySwayX = _normalizedPointer.dx * 8;
        double bodySwayY = _normalizedPointer.dy * 8;

        return Transform.translate(
          offset: Offset(shakeOffset + bodySwayX, bodySwayY),
          child: SizedBox(
            width: 400,
            height: 400,
            child: CustomPaint(
              painter: CharacterPainter(
                pointerOffset: _normalizedPointer,
                emailProgress: widget.progress,
                isEmailFocused: widget.isFocused,
                isEyesClosed: widget.isEyesClosed,
                isWhistling: widget.isWhistling,
                isAngry: widget.isAngry,
                isHappy: widget.isHappy,
                bodyBobOffset: bobOffset + jumpOffset,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingIcons() {
    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        children:
            _floatingIcons.map((icon) {
              return TweenAnimationBuilder<double>(
                key: icon.key,
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                builder: (context, value, child) {
                  double yOffset = value * -50;
                  double xOffset = sin(value * pi * 2) * 10;
                  double scale = 1.0;
                  double opacity = 1.0;

                  if (value < 0.2) {
                    opacity = value / 0.2;
                    scale = 0.5 + (0.5 * (value / 0.2));
                  } else if (value > 0.8) {
                    opacity = 1.0 - ((value - 0.8) / 0.2);
                    scale = 1.2 - (0.4 * ((value - 0.8) / 0.2));
                  } else {
                    scale = 1.2;
                  }

                  if (widget.isHappy) {
                    yOffset = value * -60;
                    xOffset = 0;
                  }

                  return Positioned(
                    left: icon.startOffset.dx + xOffset,
                    top: icon.startOffset.dy + yOffset,
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: Text(
                          icon.text,
                          style: TextStyle(
                            fontSize: 24,
                            color: icon.color,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
