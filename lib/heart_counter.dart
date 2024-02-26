import 'package:flutter/material.dart';

class HeartCounter extends StatefulWidget {
  final int count;
  final bool animate;

  const HeartCounter({Key? key, required this.count, required this.animate}) : super(key: key);

  @override
  HeartCounterState createState() => HeartCounterState();
}

class HeartCounterState extends State<HeartCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.75).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      _animationController.forward(from: 0.0);
    }

    return ElevatedButton(
      onPressed: () {
        //////////////////////////////////////////////////////////////////////////////
        // When the heart icon is pressed, it should navigate the user to matched.dart
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(84, 84), // Adjust the size of the button as needed
      ),
      child: Stack(
        children: [
          Transform.scale(
            scale: 1.0, // Adjust the scale factor as needed
            child: const Icon(
              Icons.favorite, // Heart icon
              size: 60, // Adjust the size of the icon as needed
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red, // Background color of the count
                ),
                child: Text(
                  '${widget.count}', // Replace '${widget.count}' with your actual count value
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}