// ignore_for_file: constant_identifier_names
class EndPoints {
    // static const String baseUrl = 'http://zdev.z-laundry.com/public/api/v1/'; // for dev
 static String baseUrl =
    'http://app.z-laundry.com/public/api/v1/'; // for production
  static const LOGIN = 'dm/login';
  static const LOGOUT = 'dm/logout';
  static const GET_ORDERS = 'dm/orders';
  static const GET_ORDERS_PER_TIMESLOT = 'dm/orders/perTimeSlot';
  static const POST_ORDERS_NEXT_STATUS = 'dm/orders';
  static const updateLocation = 'dm/tracking';
  static const POST_ORDERS_NEXT_STATUS_PROVIDER = 'provider/orders';
  static const POST_COLLECT_ORDER = 'dm/orders';
  static const GET_ORDER_DETAILS = 'dm/orders';
  static const GET_PROVIDER_ORDER_DETAILS = 'provider/orders';
  static const POST_ASSOCIATE_ITEMS = 'provider/orders';
  static const DELETE_ASSOCIATE_IMAGE = 'provider/orders';
  static const GET_STATUS_ORDER = 'dm/statusOrders';
  static const GET_ORDERS_PER_STATUS = 'dm/ordersPerStatus';
  static const Get_STATUS_PROVIDER = 'provider/orders';
  static const Get_OrdersPreStatus = 'provider/orders/getOrdersPreStatus';
  static const Get_PREFERENCSE = 'preferences';



  //-------------Quailty Manager-------------------
  static const GET_Providers = 'provider/show-provider-orders-per-today';
}
