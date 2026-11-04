import 'package:flutter/material.dart';
import 'package:marketplace_mobile/widgets/admin/loading_screen.dart';

import '../../core/utils/result.dart';
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

  late List<OrderItemModel> _orderItems;
  Map<String, List<OrderItemModel>> groupedItems = {};
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _groupOrderItems(List<OrderItemModel> list) async {
    if (list.isNotEmpty) {
      for (final item in list) {
        groupedItems.putIfAbsent(item.storeId, () => []).add(item);
      }
    }
  }

  Future<void> _fetchOrderItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _orderItems = [];
    });

    final Result<List<OrderItemModel>> result =
        await AdminService.getOrderItemsByOrderId(order.id);

    switch (result) {
      case Ok<List<OrderItemModel>>():
        setState(() {
          _orderItems = result.value;
        });

        await _groupOrderItems(_orderItems);

        setState(() {
          _isLoading = false;
        });
      case Error<List<OrderItemModel>>():
        setState(() {
          _errorMessage = result.error.toString();
          _isLoading = false;
        });
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
