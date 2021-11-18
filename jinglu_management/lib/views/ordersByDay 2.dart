import 'package:flutter/material.dart';
import 'package:jinglu_management/dio_client.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:date_format/date_format.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/views/orderRow.dart';

class OrderListByDay extends StatefulWidget {
  const OrderListByDay({Key? key}) : super(key: key);

  @override
  State<OrderListByDay> createState() => _OrderListByDayState();
}

class _OrderListByDayState extends State<OrderListByDay> {
  final int _value = 1;
  DioClient _client = DioClient();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("订单列表"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: ExpansionTile(
                title: Text(
                  formatDate(date, [yyyy, '年', mm, '月', dd, '日']),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  DateFormat('EEEE', "zh_CN").format(date),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0),
                    child: SizedBox(
                      height: 300,
                      child: SfDateRangePicker(
                        monthViewSettings: DateRangePickerMonthViewSettings(
                            firstDayOfWeek: 1, dayFormat: 'EEE'),
                        headerStyle: DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF263238))),
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs arg) {
                          setState(() {
                            date = arg.value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Order>?>(
              future: _client.getListOrderByTime(date: date),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Order>? orders = snapshot.data;
                  
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }


                  if (orders != null) {
                    if (orders.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("当日没有订单",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey
                        ),),
                      );
                    }
                    return ListView.builder(
                      itemCount: orders.length == 0 ? 0 : orders.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            contentPadding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                            title: OrderRow(order: orders[index],),);
                        }
                      );
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ));
  }
}
