import 'package:flutter/material.dart';
import 'package:flutter_rick_and_morty/common/app_colors.dart';
import 'package:flutter_rick_and_morty/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty/presentation/pages/person_detail_screen.dart';
import 'package:flutter_rick_and_morty/presentation/widgets/person_cache_image_widget.dart';

class PersonCard extends StatelessWidget {
  final PersonEntity person;

  const PersonCard({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(person: person),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cellBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            PersonCacheImage(width: 166, height: 166, imageUrl: person.image),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: person.status == 'Alive'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${person.status} - ${person.species}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Last location:',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    person.location.name,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Origin',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.greyBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    person.origin.name,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
