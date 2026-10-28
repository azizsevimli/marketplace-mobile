import 'package:flutter/material.dart';
import 'package:marketplace_mobile/widgets/admin/loading_screen.dart';

import '../../models/order_item_model.dart';
import '../../models/order_model.dart';
import '../../services/admin_service.dart';
import '../../widgets/admin/admin_appbars.dart';
import '../../widgets/admin/error_screen.dart';
import '../../widgets/admin/order_info_card.dart';
import '../../widgets/admin/order_part_card.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderModel get order => widget.order;

  late List<OrderItemModel> orderItems;
  Map<String, List<OrderItemModel>> groupedItems = {};
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _fetchOrderItems() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        orderItems = [];
      });

      Map<String, dynamic> data = await AdminService.getOrderItemsByOrderId(
        order.id,
      );

      if (data['orderItems'] != null) {
        setState(() {
          orderItems = data['orderItems'];
        });

        await groupOrderItems(orderItems);

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = data['message'];
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> groupOrderItems(List<OrderItemModel> list) async {
    if (list.isNotEmpty) {
      for (final item in list) {
        groupedItems.putIfAbsent(item.storeId, () => []).add(item);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderItems();
  }

  @override
  Widget build(BuildContext context) {
    final entries = groupedItems.entries.toList();
    return Scaffold(
      appBar: adminScreensAppBar(context: context, title: order.id, size: 16.0),
      body: _buildBody(entries),
    );
  }

  Widget _buildBody(List<MapEntry<String, List<OrderItemModel>>> entries) {
    if (_isLoading) {
      return const LoadingScreen();
    }

    if (_errorMessage != null) {
      return ErrorScreen(
        errorMessage: _errorMessage!,
        onPressed: _fetchOrderItems,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        spacing: 16.0,
        children: [
          OrderInfoCard(order: order),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final storeId = entries[index].key;
                final items = entries[index].value;
                return OrderPartCard(
                  index: index,
                  storeId: storeId,
                  items: items,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
