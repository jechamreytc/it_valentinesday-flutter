import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class Match extends StatefulWidget {
  const Match({Key? key}) : super(key: key);

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> with SingleTickerProviderStateMixin {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 10));
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _confettiController.play();

    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 3), // Set animation duration to 3 seconds
    )..forward().whenComplete(() {
        // Stop the animation after it completes
        _animationController.dispose();
      });

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Adjust curve for a pop-up effect
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Stack(
        children: [
          // Confetti widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,

              shouldLoop: false,
              colors: [
                Colors.red,
                Colors.pink,
                Colors.white
              ], // Confetti colors
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Heart animation
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value * 1.5, // Adjust scale factor
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 220, // Adjust size of the heart icon
                          ),
                          Positioned(
                            child: Container(
                              width: 180, // Adjust width to fit text
                              child: Text(
                                'Congratulations!\nYou are Match!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.red.withOpacity(0.5),
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                    height: 30), // Add spacing between heart and characters
                // Single image of boy and girl holding hands with heart
                Image.asset(
                  'assets/images/valentines4-removebg-preview.png',
                  width: 200, // Adjust width as needed
                  height: 200, // Adjust height as needed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
