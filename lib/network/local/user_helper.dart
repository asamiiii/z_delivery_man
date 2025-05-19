import 'package:z_delivery_man/network/local/cache_helper.dart';
import 'package:z_delivery_man/screens/login/cubit.dart';

class UserHelper{
  static UserType? getUserType( {required String type}){
     var stringType= CacheHelper.getData(key: 'type');
     
     if(stringType==UserType.delivery_man){
      return UserType.delivery_man;
     }
      else if(stringType==UserType.provider){
        return UserType.provider;
      }
      else if(stringType==UserType.quality_manager){
        return UserType.quality_manager;
      }
      else{
        return null;}
  }
}