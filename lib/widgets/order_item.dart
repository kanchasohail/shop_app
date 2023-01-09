import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  late final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20 + 200 , 250) : 95,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon:  Icon(_expanded ?  Icons.expand_less : Icons.expand_more),
                onPressed: (){
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _expanded ? min(widget.order.products.length * 20 + 100 , 150) : 0,
              child: ListView(
                children: widget.order.products.map(
                    (product) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(product.title , style: Theme.of(context).textTheme.subtitle1?.copyWith( fontWeight: FontWeight.w500,fontSize: 20 , color: Theme.of(context).accentColor),),
                          Text('${product.quantity} x \$${product.price}' ,style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w500,fontSize: 18 , color: Colors.grey))
                        ],
                      ),
                    )
                ).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
