class HomeDeliveryHelpers {
  
  //? Assign Status Image depends On Status Name
static String assetsImage({required String? status}) {
  String imagePath = '';
  switch (status) {
    case 'delivery_man_assigned':
      imagePath = 'assets/images/new_order.png';
      break;
    case 'delivery_man_going':
      imagePath = 'assets/images/to_customer.png';
      break;
    case 'to_provider':
      imagePath = 'assets/images/not_yet.png';
      break;
    case 'from_provider':
      imagePath = 'assets/images/should.png';
      break;
    case 'to_customer':
      imagePath = 'assets/images/to_customer.png';
      break;
    default:
      imagePath = 'assets/images/R.png';
  }
  return imagePath;
}
} 