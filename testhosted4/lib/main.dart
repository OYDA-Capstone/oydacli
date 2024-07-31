import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: BuildWithOyda(),
      ),
    ),
  ));
}

class BuildWithOyda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background grid and shapes
        Container(
          color: Colors.black,
          child: CustomPaint(
            painter: BackgroundPainter(),
            child: Container(),
          ),
        ),
        // Text "BUILD WITH"
        Align(
          alignment: Alignment(0, -0.2),
          child: Text(
            'BUILD WITH',
            style: TextStyle(
              color: Colors.lightBlue,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Text "OYDA"
        Align(
          alignment: Alignment(0, 0.2),
          child: Text(
            'OYDA',
            style: TextStyle(
              color: Colors.purple,
              fontSize: 70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw purple cube on the left
    paint.color = Colors.purple;
    canvas.drawRect(Rect.fromLTWH(50, 100, 100, 100), paint);

    // Draw gradient triangle on the left
    paint.shader = LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(50, 400, 100, 100));
    canvas.drawPath(trianglePath(50, 400, 100), paint);

    // Draw gradient triangle on the right
    paint.shader = LinearGradient(
      colors: [Colors.pink, Colors.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(size.width - 150, 500, 100, 100));
    canvas.drawPath(trianglePath(size.width - 150, 500, 100), paint);

    // Draw blue circle on the right
    paint.shader = null;
    paint.color = Colors.blue;
    canvas.drawCircle(Offset(size.width - 100, 300), 50, paint);

    // Draw additional shapes
    // Draw a red rectangle at the bottom
    paint.color = Colors.red;
    canvas.drawRect(
        Rect.fromLTWH(size.width / 2 - 50, size.height - 150, 100, 100), paint);

    // Draw a green circle at the top
    paint.color = Colors.green;
    canvas.drawCircle(Offset(size.width / 2, 50), 50, paint);

    // Draw a yellow ellipse in the center
    paint.color = Colors.yellow;
    canvas.drawOval(
        Rect.fromLTWH(size.width / 2 - 75, size.height / 2 - 25, 150, 50),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  Path trianglePath(double x, double y, double size) {
    return Path()
      ..moveTo(x, y)
      ..lineTo(x + size, y)
      ..lineTo(x, y + size)
      ..close();
  }
}
