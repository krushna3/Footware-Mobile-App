import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String offerTag;
  final Function() onTap;

  const ProductCard({super.key, required this.name, required this.imageUrl, required this.price, required this.offerTag, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap();
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: 180,
              ),
              SizedBox(height: 10,),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                price.toString(),
                style: TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(offerTag,style: TextStyle(color: Colors.white,fontSize: 12),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
