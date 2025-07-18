import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _emojis = ["😡", "😕", "😊", "😍"];
  int selectedEmoji = -1;
  TextEditingController feedbackController = TextEditingController();
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _buttonController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  void submitFeedback() {
    if (selectedEmoji == -1 || feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an emoji and write feedback",
              style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _buttonController.forward().then((_) {
      _buttonController.reverse();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thank you for your feedback!",
              style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        selectedEmoji = -1;
        feedbackController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent[50],
        elevation: 0,
        title: const Text('  Feedback', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildGlassContainer(
              child: Column(
                children: [
                  Text("How was your experience?",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_emojis.length, (index) {
                      bool isSelected = selectedEmoji == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = index;
                          });
                        },
                        child: AnimatedScale(
                          scale: isSelected ? 1.3 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _emojis[index],
                            style: TextStyle(fontSize: 36.sp),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    controller: feedbackController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Write your feedback...",
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      onPressed: submitFeedback,
                      child: const Text("Submit",
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: child,
        ),
      ),
    );
  }
}
