import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/paint_on_image.dart';
import 'package:z_delivery_man/screens/order_item_images_screen/state.dart';
import 'package:z_delivery_man/shared/widgets/components.dart';

import 'cubit.dart';

class OrderItemImagesScreen extends StatefulWidget {
  String? itemName;
   OrderItemImagesScreen({Key? key,required this.itemName}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderItemImagesScreenState createState() => _OrderItemImagesScreenState();
}

class _OrderItemImagesScreenState extends State<OrderItemImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderItemImagesCubit, OrderItemImagesState>(
      listener: (context, state) {
        if (state is OrderItemImagesSuccessState) {
          showToast(
              message: 'تم اضافه الصوره بنجاح', state: ToastStates.SUCCESS);
        } else if (state is OrderItemImagesFailedState) {
          showToast(message: 'حدث خطأ !!', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        final cubit = OrderItemImagesCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.itemName ?? '',style: const TextStyle(color: Colors.white),),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
              ),
              children: [
                ...cubit.imagesLocalFiles
                    .map((e) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaintOnImage(image: e),
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder:
                                  const AssetImage('assets/images/q.png'),
                              image: FileImage(e),
                            ),
                          ),
                        ))
                    .toList()
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            width: 40.w,
            height: 20.h,
            child: FloatingActionButton(
              
              onPressed: () async {
                await cubit.pickImageFromCamera();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('اضافه صوره'),
                  Icon(Icons.add_a_photo_outlined),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
