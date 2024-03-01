import 'package:flutter/material.dart';
import 'package:pawfect_match_app/user_repo.dart';
import 'matches.dart';

class HeartCounter extends StatefulWidget {
  final int count;
  final bool animate;
  final UserRepository userRepository;
  final String userName;

  const HeartCounter({
    Key? key,
    required this.count,
    required this.animate,
    required this.userRepository,
    required this.userName,
  }) : super(key: key);

  @override
  HeartCounterState createState() => HeartCounterState();
}

class HeartCounterState extends State<HeartCounter> with SingleTickerProviderStateMixin {
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
        // When the heart icon is pressed, it navigates the user to matched.dart
        Navigator.push(context, MaterialPageRoute(builder:
            (context) => Matches(userRepository: widget.userRepository, userName: widget.userName)));
        },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(84, 84),
      ),
      child: Stack(
        children: [
          Transform.scale(
            scale: 1.0, // Scale factor
            child: const Icon(
              Icons.favorite, // Heart icon
              size: 60, // Size of icon
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  '${widget.count}',
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
}