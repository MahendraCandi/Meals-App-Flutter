import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  final Meal meal;

  const MealItem({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      // this border radius will not work because we use Stack which it will ignored the card shape
      // to workaround with this, we could use clipBehaviour
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // this will cut the out of boundary content
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {},
        // Stack is like html z-axis, the widget position can be in behind or in front of other widgets.
        child: Stack(
          children: [
            // first widget will have position in very behind of another widget
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage), // default image
              image: NetworkImage(meal.imageUrl), // get image from url
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            // by using positioned widget, we can set the position of Container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54, // transparent black
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      maxLines: 2, // maximum lines if title is to long
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(children: [
                      Text("test"),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
