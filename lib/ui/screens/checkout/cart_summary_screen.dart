import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/ui/screens/checkout/payment_method_screen.dart';
import 'package:code_structure/ui/screens/checkout/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:code_structure/core/providers/call_minutes_provider.dart';

class CartSummaryScreen extends StatelessWidget {
  final List<CartItem> items;
  final double discountAmount;

  const CartSummaryScreen({
    super.key,
    required this.items,
    this.discountAmount = 0.0,
  });

  double get subtotal =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get total => subtotal - discountAmount;

  // Calculate total minutes being purchased
  Map<String, int> get minutesPurchased {
    int audioMinutes = 0;
    int videoMinutes = 0;

    for (var item in items) {
      if (item.type == 'audio') {
        audioMinutes += item.totalMinutes;
      } else if (item.type == 'video') {
        videoMinutes += item.totalMinutes;
      }
    }

    return {
      'audio': audioMinutes,
      'video': videoMinutes,
    };
  }

  @override
  Widget build(BuildContext context) {
    final callMinutesProvider = Provider.of<CallMinutesProvider>(context);
    final currentMinutes = callMinutesProvider.callMinutes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Purchase Summary',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Text(
              'Purchase Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Current balance
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade700),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Audio: ${currentMinutes.audioAvailable} min • Video: ${currentMinutes.videoAvailable} min',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // After purchase balance
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'After Purchase',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Audio: ${currentMinutes.audioAvailable + minutesPurchased['audio']!} min • Video: ${currentMinutes.videoAvailable + minutesPurchased['video']!} min',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: items.where((item) => item.price > 0).length,
              itemBuilder: (context, index) {
                // Only show non-free items
                final nonFreeItems =
                    items.where((item) => item.price > 0).toList();
                final item = nonFreeItems[index];

                return Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: item.type == 'audio'
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          item.type == 'audio' ? Icons.call : Icons.videocam,
                          color:
                              item.type == 'audio' ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${item.duration} x ${item.quantity} = ${item.totalMinutes} minutes',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Order summary
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal'),
                    Text('\$${subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount'),
                    Text('\$${discountAmount.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20.h),

                // Checkout button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodScreen(
                          totalAmount: total,
                          audioMinutes: minutesPurchased['audio']!,
                          videoMinutes: minutesPurchased['video']!,
                          paymentMethod: 'stripe',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      gradient: LinearGradient(
                        colors: [lightOrangeColor, lightPinkColor],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Continue to Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
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
