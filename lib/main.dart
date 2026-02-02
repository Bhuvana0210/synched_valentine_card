import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'he_said_yes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synched',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        fontFamily: 'Georgia',
        useMaterial3: true,
      ),
      home: const MyValentine(title: 'Synched'),
    );
  }
}

class MyValentine extends StatefulWidget {
  const MyValentine({super.key, required this.title});
  final String title;

  @override
  State<MyValentine> createState() => _MyValentineState();
}

class _MyValentineState extends State<MyValentine> {
  double _noButtonScale = 1.0;
  Offset? _noButtonPosition;
  Offset _cursorPosition = Offset.zero;
  final math.Random _random = math.Random();
  final GlobalKey _buttonAreaKey = GlobalKey();
  
  // Predefined safe positions for the No button
  List<Offset> _safePositions = [];
  
  // Detection distance in pixels (~1.3cm)
  static const double detectionDistance = 50.0;
  
  void _calculateSafePositions(double areaWidth, double areaHeight) {
    // Define the 'Natural' starting position for the No button (Right of Yes) - UPDATED GAP
    final double originalX = (areaWidth / 2) + 40; // Increased from +10 to +40
    final double originalY = 45;

    _safePositions = [
      Offset(20, 10),               // Point 1 (Top-Left)
      Offset(20, areaHeight - 60),  // Point 2 (Bottom-Left)
      Offset(areaWidth - 140, areaHeight / 2 + 10), // Point 3 (Mid-Right)
      Offset(areaWidth - 130, 10),  // Point 4 (Top-Right)
      Offset(areaWidth - 130, areaHeight - 60), // Point 5 (Bottom-Right)
      Offset(originalX, originalY), // Point 6 (The Original "Natural" Position)
    ];
  }
  
  bool _isCursorTooClose(Offset buttonPos, Offset cursorPos) {
    // Check if cursor is within detection distance from button boundary
    final buttonLeft = buttonPos.dx;
    final buttonRight = buttonPos.dx + 120; // button width
    final buttonTop = buttonPos.dy;
    final buttonBottom = buttonPos.dy + 50; // button height
    
    // Expand the detection area by detectionDistance in all directions
    final expandedLeft = buttonLeft - detectionDistance;
    final expandedRight = buttonRight + detectionDistance;
    final expandedTop = buttonTop - detectionDistance;
    final expandedBottom = buttonBottom + detectionDistance;
    
    return cursorPos.dx >= expandedLeft &&
           cursorPos.dx <= expandedRight &&
           cursorPos.dy >= expandedTop &&
           cursorPos.dy <= expandedBottom;
  }
  
  Offset _findFarthestPosition(Offset cursorPos) {
    if (_safePositions.isEmpty) return Offset(10, 10);
    
    // Find the position farthest from cursor
    double maxDistance = 0;
    Offset bestPosition = _safePositions[0];
    
    for (final pos in _safePositions) {
      final dx = pos.dx + 60 - cursorPos.dx; // +60 to get button center
      final dy = pos.dy + 25 - cursorPos.dy; // +25 to get button center
      final distance = math.sqrt(dx * dx + dy * dy);
      
      if (distance > maxDistance) {
        maxDistance = distance;
        bestPosition = pos;
      }
    }
    
    return bestPosition;
  }
  
  void _moveNoButton() {
    final RenderBox? renderBox =
        _buttonAreaKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (renderBox != null) {
      final areaWidth = renderBox.size.width;
      final areaHeight = renderBox.size.height;
      
      // Calculate safe positions if not done yet
      if (_safePositions.isEmpty) {
        _calculateSafePositions(areaWidth, areaHeight);
      }
      
      // Find the position farthest from current cursor
      final newPosition = _findFarthestPosition(_cursorPosition);
      
      setState(() {
        _noButtonPosition = newPosition;
      });
    }
  }
  
  void _onHover(PointerEvent details) {
    final RenderBox? box =
        _buttonAreaKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final localPosition = box.globalToLocal(details.position);
      _cursorPosition = localPosition;
      
      // Check if cursor is too close to the No button
      if (_noButtonPosition != null &&
          _isCursorTooClose(_noButtonPosition!, localPosition)) {
        _moveNoButton();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final cardWidth = isSmallScreen ? screenWidth * 0.9 : 600.0;

    return Scaffold(
      body: Stack(
        children: [
          // Background with hearts pattern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink.shade200,
                  Colors.pink.shade100,
                  Colors.pink.shade200,
                ],
              ),
            ),
          ),
          // Scattered hearts background
          ...List.generate(20, (index) {
            return Positioned(
              left: (index * 73.5) % screenWidth,
              top: (index * 97.3) % screenHeight,
              child: Transform.rotate(
                angle: (index * 0.5),
                child: Icon(
                  Icons.favorite,
                  color: Colors.white.withOpacity(0.15),
                  size: 30 + (index % 3) * 15,
                ),
              ),
            );
          }),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Stylish AppBar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade400, Colors.pink.shade600],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                // Main Content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: cardWidth,
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.pink.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.pink.shade50,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.pink.shade200,
                                  width: 1.5,
                                ),
                              ),
                              padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Decorative hearts
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.favorite, 
                                          color: Colors.pink.shade200, size: 16),
                                      const SizedBox(width: 8),
                                      Icon(Icons.favorite, 
                                          color: Colors.pink.shade300, size: 12),
                                      const SizedBox(width: 8),
                                      Icon(Icons.favorite, 
                                          color: Colors.pink.shade200, size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Main text
                                  Text(
                                    'Dearest LOVEE,',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 22 : 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.pink.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'will you be my valentine?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.pink.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Main heart with glow effect
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.withOpacity(0.3),
                                          blurRadius: 15,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.pink.shade600,
                                      size: isSmallScreen ? 20 : 28,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Buttons with hover detection - LARGER AREA
                                  MouseRegion(
                                    onHover: _onHover,
                                    child: SizedBox(
                                      key: _buttonAreaKey,
                                      height: 140, // Increased from 120 for more space
                                      child: Stack(
                                        children: [
                                          // Yes button - ALWAYS IN SAME POSITION (left side)
                                          Positioned(
                                            left: (cardWidth * 0.5 - 130 - (isSmallScreen ? 24 : 32)), // Account for card padding
                                            top: 45, // Vertically centered in the 140px height
                                            child: ElevatedButton(
                                              onPressed: () {
                                                try {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                        const HeSaidYes(
                                                                message: "You said YESS! 💖...\n(well you have no option!)"),
                                                                    ),
                                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                           "You said YESS! 💖, well you have no option!"),
                                                      backgroundColor:
                                                          Colors.pink,
                                                    ),
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.pink.shade600,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      isSmallScreen ? 32 : 40,
                                                  vertical:
                                                      isSmallScreen ? 14 : 16,
                                                ),
                                                elevation: 5,
                                                shadowColor: Colors.pink
                                                    .withOpacity(0.5),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                              ),
                                              child: Text(
                                                'Yes! 💕',
                                                style: TextStyle(
                                                  fontSize:
                                                      isSmallScreen ? 16 : 17,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          // No button - starts on right (bigger gap), then moves
                                          AnimatedPositioned(
                                            duration: _noButtonPosition == null 
                                                ? Duration.zero 
                                                : const Duration(milliseconds: 200),
                                            curve: Curves.easeOut,
                                            left: _noButtonPosition?.dx ?? 
                                                (cardWidth * 0.5 + 40 - (isSmallScreen ? 24 : 32)), // UPDATED: +40 for gap
                                            top: _noButtonPosition?.dy ?? 45, // Vertically centered
                                            child: MouseRegion(
                                              onEnter: (_) => _moveNoButton(),
                                              child: GestureDetector(
                                                onTapDown: (_) {
                                                  setState(() =>
                                                      _noButtonScale = 0.95);
                                                  _moveNoButton();
                                                },
                                                onTapUp: (_) {
                                                  setState(() =>
                                                      _noButtonScale = 1.0);
                                                },
                                                onTapCancel: () {
                                                  setState(() =>
                                                      _noButtonScale = 1.0);
                                                },
                                                child: AnimatedScale(
                                                  scale: _noButtonScale,
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      _moveNoButton();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors
                                                          .pink.shade400,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                        horizontal:
                                                            isSmallScreen
                                                                ? 32
                                                                : 40,
                                                        vertical:
                                                            isSmallScreen
                                                                ? 14
                                                                : 16,
                                                      ),
                                                      elevation: 5,
                                                      shadowColor: Colors
                                                          .pink
                                                          .withOpacity(0.5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                        fontSize:
                                                            isSmallScreen
                                                                ? 16
                                                                : 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.5,
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
                                  ),

                                  const SizedBox(height: 20),

                                  // Footer decoration
                                  Text(
                                    '✨ Made with love ✨',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.pink.shade400,
                                      fontStyle: FontStyle.italic,
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
}
