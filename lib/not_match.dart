import 'dart:math';
import 'package:flutter/material.dart';

class NotMatch extends StatefulWidget {
  const NotMatch({Key? key}) : super(key: key);

  @override
  _NotMatchState createState() => _NotMatchState();
}

class _NotMatchState extends State<NotMatch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late String randomSentence;

  @override
  void initState() {
    super.initState();

    // List of sentences to display randomly
    final sentences = [
      "Dili nalang ta partner kay wala ka naligo",
      "Pasensya, dili tika gusto ma partner kay wala ka nag-toothbrush",
      "Dili man jud ta mag match kay naa man koy lain",
      "Match rata pero dili ta match og feelings maong pangita ug lain",
      "Pasayloa ko, dili tika gusto ma partner kay busy ka permi sa lain",
      "Sorry dili tika gusto ma partner kay sige rakag dula ug DOTA",
      "Dili lang sa ta mag partner kay diko ganahan sa imung smile",
      "Dili man ta match kay wala may kita",
      "Sorry pero bati kag nawong",
      "Pasayloa ko dili sa ta mag partner kay mas buotan pa ang akung iro",
      "Opsss there’s an error, I expected this error"
    ];

    // Select a random sentence
    randomSentence = sentences[Random().nextInt(sentences.length)];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 100,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset(
                        'assets/images/valentines4-removebg-preview.png',
                        width: 220,
                        height: 220,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 430,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Icon(
                        Icons.heart_broken,
                        color: Colors.redAccent,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 270,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            width: 250, // Adjusted width to fit longer text
                            child: Text(
                              '"${randomSentence}"', // Display the randomly selected sentence
                              style: TextStyle(
                                color: const Color.fromARGB(255, 215, 138, 138),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color:
                                        const Color.fromARGB(255, 207, 77, 77)
                                            .withOpacity(0.5),
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
