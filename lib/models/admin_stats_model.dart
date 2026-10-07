class AdminStatsModel {
  Users users;
  Products products;
  Orders orders;

  AdminStatsModel({
    required this.users,
    required this.products,
    required this.orders,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    return AdminStatsModel(
      users: Users.fromJson(json['users']),
      products: Products.fromJson(json['products']),
      orders: Orders.fromJson(json['orders']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'users': users, 'products': products, 'orders': orders};
  }
}

class Users {
  String total;
  String admin;
  String customer;
  String vendor;

  Users({
    required this.total,
    required this.admin,
    required this.customer,
    required this.vendor,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      total: json['total'],
      admin: json['admin'],
      customer: json['customer'],
      vendor: json['vendor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'customer': customer, 'vendor': vendor};
  }
}

class Products {
  String total;
  String pending;
  String active;
  String passive;
  String rejected;

  Products({
    required this.total,
    required this.pending,
    required this.active,
    required this.passive,
    required this.rejected,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      total: json['total'],
      pending: json['pending'],
      active: json['active'],
      passive: json['passive'],
      rejected: json['rejected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'pending': pending,
      'active': active,
      'passive': passive,
      'rejected': rejected,
    };
  }
}

class Orders {
  String total;
  String pending;
  String preparing;
  String completed;
  String cancelled;

  Orders({
    required this.total,
    required this.pending,
    required this.preparing,
    required this.completed,
    required this.cancelled,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      total: json['total'],
      pending: json['pending'],
      preparing: json['preparing'],
      completed: json['completed'],
      cancelled: json['cancelled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'pending': pending,
      'preparing': preparing,
      'completed': completed,
      'cancelled': cancelled,
    };
  }
}
