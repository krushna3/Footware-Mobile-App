import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:footware/Controllers/home_controller.dart';
import 'package:footware/pages/login_page.dart';
import 'package:footware/pages/product_description_page.dart';
import 'package:footware/widgets/drop_down_btn.dart';
import 'package:footware/widgets/multi_select_drop_down.dart';
import 'package:footware/widgets/product_card.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
                child: Text(
              'Footware Store',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
            actions: [
              IconButton(
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(const LoginPage());
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      itemCount: ctrl.productCategories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            ctrl.filterByCategory(
                                ctrl.productCategories[index].name ?? '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Chip(
                                label: Text(
                                    ctrl.productCategories[index].name ??
                                        'Category')),
                          ),
                        );
                      }),
                ),
                Row(
                  children: [
                    Flexible(
                        child: MultiSelectDropDown(
                      items: ['skechers', 'Puma', 'Nike', 'Adidas'],
                      onSelectionChanged: (selectedItems) {
                        ctrl.filterByBrand(selectedItems);
                      },
                    )),
                    Flexible(
                      child: DropDownBtn(
                        items: ['RS: Low to High', 'RS: High to Low'],
                        hintText: 'Sort Items',
                        onSelected: (selectedValue) {
                          ctrl.sortByPrice(
                              ascending: selectedValue == 'RS: Low to High'
                                  ? true
                                  : false);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: ctrl.productShowInUi.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          name: ctrl.productShowInUi[index].name ?? 'No name',
                          imageUrl: ctrl.productShowInUi[index].image ?? 'url',
                          price: ctrl.productShowInUi[index].price ?? 0,
                          offerTag: '20% off',
                          onTap: () {
                            Get.to(ProductDescriptionPage(), arguments: {
                              'data': ctrl.productShowInUi[index]
                            });
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
