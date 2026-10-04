import 'package:flutter/material.dart';
import '../models/order.dart';
import '../theme/noon_theme.dart';

class OrderTrackerWidget extends StatelessWidget {
  final OrderModel order;

  const OrderTrackerWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'Placed', 'icon': Icons.assignment_turned_in_rounded},
      {'title': 'Packed', 'icon': Icons.inventory_2_rounded},
      {'title': 'Shipped', 'icon': Icons.local_shipping_rounded},
      {'title': 'Out for Delivery', 'icon': Icons.directions_bike_rounded},
      {'title': 'Delivered', 'icon': Icons.check_circle_rounded},
    ];

    int activeIndex = order.currentStep;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID: ${order.orderId}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: activeIndex == 4 ? Colors.green.shade100 : NoonTheme.yellowPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order.statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: activeIndex == 4 ? Colors.green.shade900 : NoonTheme.noonBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Est. Delivery: ${order.estimatedDelivery}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),

          // Stepper Line
          Row(
            children: List.generate(steps.length, (index) {
              bool isDone = index <= activeIndex;
              bool isCurrent = index == activeIndex;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 3,
                            color: index == 0
                                ? Colors.transparent
                                : (index <= activeIndex ? Colors.green : Colors.grey.shade300),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isCurrent ? 28 : 22,
                          height: isCurrent ? 28 : 22,
                          decoration: BoxDecoration(
                            color: isDone ? Colors.green : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: Colors.green.withValues(alpha: 0.4),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            steps[index]['icon'] as IconData,
                            size: isCurrent ? 16 : 12,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 3,
                            color: index == steps.length - 1
                                ? Colors.transparent
                                : (index < activeIndex ? Colors.green : Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[index]['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isDone ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
