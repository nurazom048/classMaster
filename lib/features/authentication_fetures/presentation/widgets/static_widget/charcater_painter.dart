// ----- Custom Painter for Characters -----
import 'dart:math';

import 'package:flutter/material.dart';
// ============================================================================
// PART 1: REUSABLE ANIMATION WRAPPER WIDGET
// Use this for Login, Signup, Password Reset, etc.
// ============================================================================

class CharacterPainter extends CustomPainter {
  final Offset pointerOffset;
  final double emailProgress;
  final bool isEmailFocused;
  final bool isEyesClosed;
  final bool isWhistling;
  final bool isAngry;
  final bool isHappy;
  final double bodyBobOffset;

  CharacterPainter({
    required this.pointerOffset,
    required this.emailProgress,
    required this.isEmailFocused,
    required this.isEyesClosed,
    required this.isWhistling,
    required this.isAngry,
    required this.isHappy,
    required this.bodyBobOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Scale canvas to fit 400x400 reference area inside the available size
    final double scale = min(size.width / 400, size.height / 400);
    canvas.save();
    canvas.translate(
      (size.width - 400 * scale) / 2,
      size.height - 400 * scale,
    ); // Center horizontally, align bottom
    canvas.scale(scale, scale);
    canvas.translate(0, 20); // Base translation

    final Paint bluePaint =
        Paint()
          ..color = const Color(0xFF5A47F9)
          ..style = PaintingStyle.fill;
    final Paint blackPaint =
        Paint()
          ..color = const Color(0xFF1C1C1C)
          ..style = PaintingStyle.fill;
    final Paint yellowPaint =
        Paint()
          ..color = const Color(0xFFFAC515)
          ..style = PaintingStyle.fill;
    final Paint orangePaint =
        Paint()
          ..color = const Color(0xFFF86737)
          ..style = PaintingStyle.fill;
    final Paint strokePaint =
        Paint()
          ..color = const Color(0xFF1C1C1C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
    final Paint whiteStrokePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    // Apply bobbing/jumping to characters
    canvas.translate(0, bodyBobOffset);

    // 1. Blue Character
    canvas.save();
    canvas.translate(100, 80);
    Path bluePath =
        Path()
          ..moveTo(0, 30)
          ..lineTo(70, 0)
          ..lineTo(70, 320)
          ..lineTo(0, 320)
          ..close();
    canvas.drawPath(bluePath, bluePaint);
    _drawEyes(canvas, const Offset(20, 80), const Offset(50, 70), 7, 3, false);
    _drawMouth(canvas, const Offset(35, 100), strokePaint);
    canvas.restore();

    // 2. Black Character
    canvas.save();
    canvas.translate(160, 170);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 60, 230),
        const Radius.circular(15),
      ),
      blackPaint,
    );
    _drawEyes(
      canvas,
      const Offset(15, 30),
      const Offset(45, 30),
      6,
      2.5,
      false,
    );
    _drawMouth(canvas, const Offset(30, 46), whiteStrokePaint);
    canvas.restore();

    // 3. Yellow Character
    canvas.save();
    canvas.translate(210, 230);
    Path yellowPath =
        Path()
          ..moveTo(0, 50)
          ..quadraticBezierTo(0, 0, 50, 0)
          ..lineTo(50, 170)
          ..lineTo(0, 170)
          ..close();
    canvas.drawPath(yellowPath, yellowPaint);
    _drawEyes(canvas, const Offset(35, 40), null, 5, 2, false);
    _drawMouth(canvas, const Offset(48, 60), strokePaint, isSideView: true);
    canvas.restore();

    // 4. Orange Character (Blob)
    canvas.save();
    canvas.translate(40, 240);
    Path orangePath =
        Path()
          ..moveTo(60, 0)
          ..cubicTo(100, 0, 130, 30, 130, 80)
          ..cubicTo(130, 130, 100, 160, 60, 160)
          ..cubicTo(20, 160, 0, 130, 0, 80)
          ..cubicTo(0, 30, 20, 0, 60, 0)
          ..close();
    canvas.drawPath(orangePath, orangePaint);
    _drawEyes(canvas, const Offset(40, 60), const Offset(80, 60), 6, 4.5, true);
    _drawMouth(canvas, const Offset(60, 85), strokePaint..strokeWidth = 3);
    canvas.restore();

    canvas.restore(); // Restore base transform
  }

  void _drawEyes(
    Canvas canvas,
    Offset leftEye,
    Offset? rightEye,
    double eyeRadius,
    double pupilRadius,
    bool isOrange,
  ) {
    Paint whitePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    Color pupilColor = const Color(0xFF1C1C1C);
    double currentPupilRadius = pupilRadius;
    if (isAngry) {
      pupilColor = const Color(0xFFDC2626);
      currentPupilRadius *= 1.3;
    } else if (isHappy) {
      pupilColor = const Color(0xFF10B981);
      currentPupilRadius *= 1.2;
    }
    Paint pupilPaint =
        Paint()
          ..color = pupilColor
          ..style = PaintingStyle.fill;

    // Calculate Pupil Offset
    Offset pOffset = Offset.zero;
    if (isWhistling) {
      pOffset = const Offset(0, -4);
    } else if (isAngry || isHappy) {
      pOffset = Offset(0, isAngry ? 2 : -2);
    } else if (isEmailFocused) {
      pOffset = Offset(-2 + (emailProgress * 4), 1);
    } else if (!isEyesClosed) {
      pOffset = Offset(pointerOffset.dx * 2.5, pointerOffset.dy * 2.5);
    }

    void drawSingleEye(Offset center) {
      if (isEyesClosed) {
        if (isOrange) {
          // Orange doesn't have white background, just thin pupils
          canvas.drawOval(
            Rect.fromCenter(center: center, width: eyeRadius * 3, height: 2),
            pupilPaint,
          );
        } else {
          // White line for closed eyes
          canvas.drawOval(
            Rect.fromCenter(center: center, width: eyeRadius * 3, height: 2),
            whitePaint,
          );
        }
      } else {
        if (!isOrange) canvas.drawCircle(center, eyeRadius, whitePaint);
        canvas.drawCircle(center + pOffset, currentPupilRadius, pupilPaint);
      }
    }

    drawSingleEye(leftEye);
    if (rightEye != null) drawSingleEye(rightEye);
  }

  void _drawMouth(
    Canvas canvas,
    Offset center,
    Paint paint, {
    bool isSideView = false,
  }) {
    if (isWhistling) {
      canvas.drawCircle(center, paint.strokeWidth == 3 ? 4 : 2.5, paint);
      return;
    }

    Path mouthPath = Path();
    if (isAngry) {
      paint.color = const Color(0xFFDC2626);
      if (isSideView) {
        mouthPath.moveTo(center.dx - 6, center.dy + 2);
        mouthPath.quadraticBezierTo(
          center.dx - 3,
          center.dy - 2,
          center.dx + 4,
          center.dy,
        );
      } else {
        mouthPath.moveTo(center.dx - 10, center.dy + 5);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy - 5,
          center.dx + 10,
          center.dy + 5,
        );
      }
    } else if (isHappy) {
      paint.color = const Color(0xFF10B981);
      paint.strokeWidth += 1;
      if (isSideView) {
        mouthPath.moveTo(center.dx - 6, center.dy - 2);
        mouthPath.quadraticBezierTo(
          center.dx - 3,
          center.dy + 4,
          center.dx + 4,
          center.dy,
        );
      } else {
        mouthPath.moveTo(center.dx - 10, center.dy - 2);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + 8,
          center.dx + 10,
          center.dy - 2,
        );
      }
    } else {
      // Normal Smile
      if (isSideView) {
        mouthPath.moveTo(center.dx - 6, center.dy);
        mouthPath.lineTo(center.dx + 4, center.dy);
      } else {
        mouthPath.moveTo(center.dx - 10, center.dy);
        mouthPath.quadraticBezierTo(
          center.dx,
          center.dy + 5,
          center.dx + 10,
          center.dy,
        );
      }
    }
    canvas.drawPath(mouthPath, paint);
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) {
    return pointerOffset != oldDelegate.pointerOffset ||
        emailProgress != oldDelegate.emailProgress ||
        isEmailFocused != oldDelegate.isEmailFocused ||
        isEyesClosed != oldDelegate.isEyesClosed ||
        isWhistling != oldDelegate.isWhistling ||
        isAngry != oldDelegate.isAngry ||
        isHappy != oldDelegate.isHappy ||
        bodyBobOffset != oldDelegate.bodyBobOffset;
  }
}

// Painter for Google 'G' Icon to avoid external assets
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Simplistic Google G using paths
    Paint p = Paint()..style = PaintingStyle.fill;

    // Red Top
    p.color = const Color(0xFFEA4335);
    Path p1 =
        Path()
          ..moveTo(w / 2, h * 0.1)
          ..quadraticBezierTo(w * 0.8, h * 0.1, w * 0.9, h * 0.3)
          ..lineTo(w * 0.7, h * 0.4)
          ..quadraticBezierTo(w * 0.6, h * 0.3, w / 2, h * 0.3)
          ..quadraticBezierTo(w * 0.3, h * 0.3, w * 0.2, h * 0.5)
          ..lineTo(0, h * 0.3)
          ..quadraticBezierTo(w * 0.2, h * 0.1, w / 2, h * 0.1);
    canvas.drawPath(p1, p);

    // Yellow Left
    p.color = const Color(0xFFFBBC05);
    Path p2 =
        Path()
          ..moveTo(0, h * 0.3)
          ..lineTo(w * 0.2, h * 0.5)
          ..quadraticBezierTo(w * 0.15, h * 0.6, w * 0.2, h * 0.7)
          ..lineTo(0, h * 0.85)
          ..quadraticBezierTo(w * -0.1, h * 0.6, 0, h * 0.3);
    canvas.drawPath(p2, p);

    // Green Bottom
    p.color = const Color(0xFF34A853);
    Path p3 =
        Path()
          ..moveTo(0, h * 0.85)
          ..lineTo(w * 0.2, h * 0.7)
          ..quadraticBezierTo(w * 0.4, h * 0.9, w * 0.7, h * 0.8)
          ..lineTo(w * 0.9, h * 0.95)
          ..quadraticBezierTo(w * 0.6, h * 1.1, 0, h * 0.85);
    canvas.drawPath(p3, p);

    // Blue Right & Middle
    p.color = const Color(0xFF4285F4);
    Path p4 =
        Path()
          ..moveTo(w * 0.9, h * 0.3)
          ..lineTo(w, h * 0.3)
          ..lineTo(w, h * 0.6)
          ..lineTo(w * 0.5, h * 0.6)
          ..lineTo(w * 0.5, h * 0.45)
          ..lineTo(w * 0.8, h * 0.45)
          ..quadraticBezierTo(w * 0.8, h * 0.7, w * 0.7, h * 0.8)
          ..lineTo(w * 0.9, h * 0.95)
          ..quadraticBezierTo(w * 1.1, h * 0.7, w * 0.9, h * 0.3);
    canvas.drawPath(p4, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
