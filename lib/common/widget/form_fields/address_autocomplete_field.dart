import 'package:ewastecare/data/repositories/address/address_repository.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WasteAddressAutocompleteField extends StatelessWidget {
  const WasteAddressAutocompleteField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.prefixIcon = const Icon(Icons.location_on_outlined),
    this.hintText,
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?) validator;
  final Widget prefixIcon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final repository = Get.put(AddressRepository());

    return StreamBuilder<List<String>>(
      stream: repository.watchAddresses(),
      builder: (context, snapshot) {
        final addresses = snapshot.data ?? const <String>[];

        if (snapshot.hasError || addresses.isEmpty) {
          return TextFormField(
            controller: controller,
            validator: validator,
            expands: false,
            decoration: InputDecoration(
              labelText: labelText,
              prefixIcon: prefixIcon,
              hintText: hintText,
            ),
          );
        }

        return Autocomplete<String>(
          initialValue: TextEditingValue(text: controller.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) {
              return addresses;
            }

            return addresses.where((address) {
              return address.toLowerCase().contains(query);
            });
          },
          onSelected: (String selection) {
            controller.text = selection;
          },
          displayStringForOption: (String option) => option,
          fieldViewBuilder:
              (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  validator: (value) {
                    final validationMessage = validator(value);
                    if (validationMessage != null) {
                      return validationMessage;
                    }

                    final trimmedValue = value?.trim() ?? '';
                    if (trimmedValue.isEmpty) {
                      return null;
                    }

                    final isKnownAddress = addresses.any(
                      (address) =>
                          address.toLowerCase() == trimmedValue.toLowerCase(),
                    );
                    if (!isKnownAddress) {
                      return WasteTexts.selectAddressFromList.tr;
                    }

                    return null;
                  },
                  expands: false,
                  onChanged: (value) => controller.text = value,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                  decoration: InputDecoration(
                    labelText: labelText,
                    prefixIcon: prefixIcon,
                    hintText: hintText,
                  ),
                );
              },
          optionsViewBuilder:
              (
                BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
        );
      },
    );
  }
}
