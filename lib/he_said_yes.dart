import 'package:flutter/material.dart';
import 'dart:math' as math;

class HeSaidYes extends StatefulWidget {
  final String message;

  const HeSaidYes({super.key, required this.message});

  @override
  State<HeSaidYes> createState() => _HeSaidYesState();
}

class _HeSaidYesState extends State<HeSaidYes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink.shade300,
                  Colors.pink.shade100,
                  Colors.purple.shade100,
                  Colors.pink.shade200,
                ],
              ),
            ),
          ),

          // Floating hearts animation
          ...List.generate(30, (index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 2000 + (index * 100)),
              builder: (context, value, child) {
                return Positioned(
                  left: (index * 67.3) % screenWidth,
                  top: screenHeight * value - 50,
                  child: Transform.rotate(
                    angle: value * 2 * math.pi,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white.withOpacity(0.3),
                      size: 20 + (index % 4) * 10,
                    ),
                  ),
                );
              },
            );
          }),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Stylish AppBar
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade500, Colors.purple.shade400],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Yay! 💕',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                ),

                // Main content area
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Card(
                            elevation: 12,
                            shadowColor: Colors.pink.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: Colors.white,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isSmallScreen ? screenWidth * 0.9 : 800,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.pink.shade200,
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.all(isSmallScreen ? 30 : 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated heart
                                  AnimatedBuilder(
                                    animation: _rotationAnimation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: math.sin(_rotationAnimation.value) * 0.1,
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.pink.shade400,
                                                Colors.red.shade400,
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.pink.withOpacity(0.5),
                                                blurRadius: 25,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: isSmallScreen ? 60 : 80,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 30),

                                  // Success message
                                  Text(
                                    widget.message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24 : 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink.shade700,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Decorative divider
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.pink.shade300,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.pink.shade400,
                                          size: 16,
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.pink.shade300,
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Sweet Valentine message
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.pink.shade100,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Dear Flexxx,',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 18 : 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.pink.shade800,
                                            fontFamily: 'Georgia',
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'You just made my heart skip a beat! 💗\n\n'
                                          'From the moment I saw you, I knew you were special. '
                                          'Your smile lights up my world like the brightest star, '
                                          'and being with you feels like coming home.\n\n'
                                          'Thank you for choosing me, for saying yes, '
                                          'and for making this Valentine\'s Day absolutely perfect. '
                                          'I can\'t wait to create countless beautiful memories together.\n\n'
                                          'Here\'s to us, to love, and to forever! 🌹'
                                          ,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                            height: 1.6,
                                            color: Colors.pink.shade700,
                                            fontFamily: 'Georgia',
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // Cute emoji row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildEmojiCircle('💕', isSmallScreen),
                                      const SizedBox(width: 10),
                                      _buildEmojiCircle('💖', isSmallScreen),
                                      const SizedBox(width: 10),
                                      _buildEmojiCircle('💝', isSmallScreen),
                                      const SizedBox(width: 10),
                                      _buildEmojiCircle('💗', isSmallScreen),
                                      const SizedBox(width: 10),
                                      _buildEmojiCircle('💓', isSmallScreen),
                                    ],
                                  ),

                                  const SizedBox(height: 25),

                                  // Footer
                                  Text(
                                    '✨ Forever Yours ✨',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.pink.shade400,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: 'Georgia',
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiCircle(String emoji, bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 8 : 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: isSmall ? 20 : 24),
      ),
    );
  }
}