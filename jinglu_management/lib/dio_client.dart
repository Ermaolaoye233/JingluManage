import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:jinglu_management/models/product.dart';
import 'package:jinglu_management/models/loginUser.dart';
import 'package:jinglu_management/models/user.dart';
import 'package:jinglu_management/models/order.dart';
import 'package:jinglu_management/models/productType.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'dart:convert';

class DioClient {
  final Dio _dio = Dio();

  final _baseUrl = 'http://192.168.31.120:5000/api/';

  // Users
  Future<User?> userLogin({required LoginUser loginUser}) async {
    User? retrievedUser;

    // try {
    Response response =
        await _dio.post(_baseUrl + 'Users/login', data: loginUser.toJson());

    print('login response ${response.data}');
    List<dynamic> list = json.decode(response.data);
    retrievedUser = User.fromJson(list[0]);

    return retrievedUser;
  }

  Future<User?> getUserDescription({required int userID}) async {
    User? retrievedUser;
    try {
      Response response =
          await _dio.get(_baseUrl + 'Users/description/' + userID.toString());
      List<dynamic> list = json.decode(response.data);
      retrievedUser = User.fromJson(list[0]);

      return retrievedUser;
    } on DioError catch (error) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
  }


  // Products
  Future<Product?> getProductDescription({required String id}) async {
    Product? product;
    try {
      Response productData =
          await _dio.get(_baseUrl + 'Products/description/$id');
      print('Product info:${productData.data}');
      List<dynamic> list = json.decode(productData.data);
      product = Product.fromJson(list[0]);
    } on DioError catch (error) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
    return product;
  }

  Future<List<Product>?> getListProductDescription(
      {required String userInput}) async {
    List<Product>? products = [];
    try {
      Response productData =
          await _dio.get(_baseUrl + 'Products/Flist/$userInput');
      print('Product Info:${productData.data}');
      List<dynamic> list = json.decode(productData.data);
      list.forEach((element) {
        products.add(Product.fromJson(element));
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
    return products;
  }

  Future<List<Product>?> getListProductLatest() async {
    List<Product>? products = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        'id': prefs.getInt('userID'),
        'jwt': prefs.getString('jwt'),
      };
      print(data.toString());
      Response response =
          await _dio.post(_baseUrl + 'Products/descriptionLatest', data: data);
      print('product response ${response.data}');
      List<dynamic> list = json.decode(response.data);
      list.forEach((element) {
        products.add(Product.fromJson(element));
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
    return products;
  }

  // Orders
  Future<List<Order>?> getListOrderByProduct({required int productID}) async {
    List<Order>? orders = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        'id': prefs.getInt('userID'),
        'jwt': prefs.getString('jwt'),
        'productID': productID,
      };
      print(data.toString());
      Response response =
          await _dio.post(_baseUrl + 'Orders/descriptionByProduct', data: data);
      print('order response ${response.data}');
      List<dynamic> list = json.decode(response.data);
      list.forEach((element) {
        print(orders.toString());
        orders.add(Order.fromJson(element));
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }

    return orders;
  }

  Future<List<Order>?> getListOrderByUser({required int userID}) async {
    List<Order>? orders = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        'id': prefs.getInt('userID'),
        'jwt': prefs.getString('jwt'),
        'userID': userID,
      };
      print(data.toString());
      Response response =
          await _dio.post(_baseUrl + 'Orders/descriptionByUser', data: data);
      print('order response ${response.data}');
      List<dynamic> list = json.decode(response.data);
      list.forEach((element) {
        print(orders.toString());
        orders.add(Order.fromJson(element));
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }

    return orders;
  }

  Future<List<Order>?> getListOrderByTime({required DateTime date}) async {
    List<Order>? orders = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        'id': prefs.getInt('userID'),
        'jwt': prefs.getString('jwt'),
        'date': formatDate(date, [yyyy, '-', mm, '-', dd]),
        'prodSpec': 0,
        'userSpec': 0
      };
      print(data.toString());
      Response response =
          await _dio.post(_baseUrl + 'Orders/descriptionByDay', data: data);
      print('order response ${response.data}');
      List<dynamic> list = json.decode(response.data);
      list.forEach((element) {
        orders.add(Order.fromJson(element));
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
    return orders;
  }

  Future<List<Order>?> getListOrderLatest() async {
    List<Order>? orders = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        'id': prefs.getInt('userID'),
        'jwt': prefs.getString('jwt'),
      };
      print(data.toString());
      Response response =
          await _dio.post(_baseUrl + 'Orders/descriptionLatest', data: data);
      print('order response ${response.data}');
      List<dynamic> list = json.decode(response.data);
      list.forEach((element) {
        orders.add(Order.fromJson(element));
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
    return orders;
  }

  // Types
  Future<List<ProductType>?> getListProductType() async {
    List<ProductType>? types = [];
    try{
      Response response = await _dio.get(_baseUrl + 'Types/getAll');
      print('order response ${response.data}');
      List<dynamic> list = json.decode(response.data);
      list.forEach((element) {
        types.add(ProductType.fromJson(element));
        print(types.toString());
      });
    } on DioError catch (error) {
      // The request was made and teh server responded with a status code
      // that falls out of the range of 2xx and is also not 304
      if (error.response != null) {
        print('Dio Error!');
        print('STATUS: ${error.response?.statusCode}');
        print('DATA: ${error.response?.data}');
        print('HEADERS: ${error.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(error.message);
      }
    }
    return types;
  }
}
