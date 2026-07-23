import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constant/app_color.dart';

// Provider to manage ad banner visibility
final showAdProvider = StateProvider<bool>((ref) => true);

class PromoAdWidget extends ConsumerWidget {
  const PromoAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative background gradients/blobs
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColor.nokiaBlue.withOpacity(0.03),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -80,
              bottom: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColor.nokiaBlue.withOpacity(0.02),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Ad Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  
                  // 🎓 Premium Custom Logo Container
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.nokiaBlue, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.nokiaBlue.withOpacity(0.1),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Mortarboard Icon
                          Icon(
                            Icons.school,
                            size: 46,
                            color: AppColor.nokiaBlue,
                          ),
                          const SizedBox(height: 4),
                          // Tiny logo text inside
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.nokiaBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "CLASS MASTER",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Logo Title text
                  Text(
                    "classMaster",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColor.nokiaBlue,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Heading text
                  const Text(
                    "All your academic updates,\nall in one place.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Description body text
                  Text(
                    "Get instant access to notices, routines, job circulars and important information — anytime, anywhere.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Decorative divider
                  Container(
                    width: 60,
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColor.nokiaBlue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),

            // Close button (X) on Top Right
            Positioned(
              top: 12,
              right: 12,
              child: ClipOval(
                child: Material(
                  color: Colors.grey.shade100,
                  child: InkWell(
                    onTap: () {
                      ref.read(showAdProvider.notifier).state = false;
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
