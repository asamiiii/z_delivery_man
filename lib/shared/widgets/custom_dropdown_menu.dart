import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Generic Custom Dropdown widget
class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) displayText;
  final void Function(T? selectedItem) onChanged;
  final String? hintText;
  final String? mainTitle;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.displayText,
    required this.onChanged,
    this.hintText,
    this.mainTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (mainTitle != null)
          Row(
            children: [
              Text(
                mainTitle!,
                // style: AppTextStyles.font14Regular.copyWith(
                //   color: AppColors.darkGrey3,
                // ),
              ),
            ],
          ),
        if (mainTitle != null)
          const SizedBox(
            height: 8,
          ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              // color: AppColors.lightGrey2, // Set the border color
              width: 1, // Set the border width
            ),
          ),
          child: DropdownButton<T>(
            itemHeight: 48,
            underline: const SizedBox(),
            dropdownColor: Colors.white,
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.arrow_downward),
            ),
            value: selectedItem,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(hintText ?? 'No Hint Txt'),
            ),
            isExpanded: true,
            onChanged: onChanged,
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(displayText(item)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
