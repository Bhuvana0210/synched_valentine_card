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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // 🌸 Background
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

          // Floating hearts (background only)
          ...List.generate(24, (i) {
            return Positioned(
              left: (i * 70.0) % MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height * (i / 24),
              child: Icon(
                Icons.favorite,
                color: Colors.white.withOpacity(0.25),
                size: 18 + (i % 3) * 8,
              ),
            );
          }),

          SafeArea(
            child: Column(
              children: [
                // 🔝 App Bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.shade500,
                        Colors.purple.shade400
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Yay! 💕',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // 🌷 Main Card
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  isSmallScreen ? double.infinity : 1000,
                            ),
                            padding: EdgeInsets.all(
                                isSmallScreen ? 24 : 28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // ❤️ TOP HEART (hover pop)
                                AnimatedBuilder(
                                  animation: _rotationAnimation,
                                  builder: (_, __) {
                                    return HoverHeart(
                                      child: Transform.rotate(
                                        angle: math.sin(
                                                _rotationAnimation.value) *
                                            0.08,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.pink.shade400,
                                                Colors.red.shade400,
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            size:
                                                isSmallScreen ? 18 : 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Title
                                Text(
                                  widget.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        isSmallScreen ? 22 : 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade700,
                                    fontFamily: 'Georgia',
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Divider
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 2,
                                      color: Colors.pink.shade300,
                                    ),
                                    const SizedBox(width: 10),
                                    Icon(
                                      Icons.favorite,
                                      size: 14,
                                      color: Colors.pink.shade400,
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 36,
                                      height: 2,
                                      color: Colors.pink.shade300,
                                      
                                    ),
                                    
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // 💌 LETTER (darker text + darker border)
                                Container(
                                  padding:
                                      const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade100,
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    border: Border.all(
                                      color:
                                          Colors.pink.shade400,
                                      width: 1.3,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Dear Flexxx,',
                                        style: TextStyle(
                                          fontSize: isSmallScreen
                                              ? 17
                                              : 19,
                                          fontWeight:
                                              FontWeight.w600,
                                          color: Colors
                                              .pink.shade800,
                                          fontFamily: 'Georgia',
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'You just made my heart skip a beat! 💗\n\n'
                                        'From the moment I saw you, I knew you were special. '
                                        'Your smile lights up my world like the brightest star, '
                                        'and being with you feels like coming home.\n\n'
                                        'Thank you for choosing me, for saying yes, '
                                        'and for making this Valentine\'s Day absolutely perfect.\n\n'
                                        'Here\'s to us, to love, and to forever! 🌹',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize:
                                              isSmallScreen
                                                  ? 13
                                                  : 15,
                                          height: 1.35,
                                          color: Colors
                                              .pink.shade900,
                                          fontFamily:
                                              'Georgia',
                                          fontStyle:
                                              FontStyle.italic,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // 💕 EMOJI HEARTS (hover pop)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _emoji('💕', isSmallScreen),
                                      const SizedBox(width: 12),
                                      _emoji('💖', isSmallScreen),
                                      const SizedBox(width: 12),
                                      _emoji('💝', isSmallScreen),
                                      const SizedBox(width: 12),
                                      _emoji('💗', isSmallScreen),
                                      const SizedBox(width: 12),
                                      _emoji('💓', isSmallScreen),
                              ],
                            ),

                                const SizedBox(height: 14),

                                // Footer
                                Text(
                                  '✨ Forever Yours ✨',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.pink.shade400,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Georgia',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emoji(String emoji, bool isSmall) {
    return HoverHeart(
      child: Container(
        padding: EdgeInsets.all(isSmall ? 6 : 8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Text(
          emoji,
          style: TextStyle(fontSize: isSmall ? 18 : 22),
        ),
      ),
    );
  }
}

/// ❤️ Hover pop effect widget
class HoverHeart extends StatefulWidget {
  final Widget child;
  const HoverHeart({super.key, required this.child});

  @override
  State<HoverHeart> createState() => _HoverHeartState();
}

class _HoverHeartState extends State<HoverHeart> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: _hovered
            ? (Matrix4.identity()..scale(1.15))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.5),
                    blurRadius: 18,
                    spreadRadius: 3,
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
