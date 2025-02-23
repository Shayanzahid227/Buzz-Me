import 'package:code_structure/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDiscoverWIdget extends StatelessWidget {
  const CustomDiscoverWIdget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // height: MediaQuery.of(context).size.height * 0.87,
          // width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Image(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  image: const NetworkImage(
                    'https://s.abcnews.com/images/GMA/billie-eilish-gty-jt-201112_1605208921798_hpMain_16x9_992.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(), // Use Spacer to push rows to the bottom
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center horizontally
                children: [
                  Text(
                    'Billie Eilish',
                    style: style25.copyWith(fontSize: 25),
                  ),
                  5.horizontalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.female),
                        Text('23'),
                        2.horizontalSpace
                      ],
                    ),
                  )
                ],
              ),
              //  const SizedBox(height: 8), // Add some spacing
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center horizontally
                children: [
                  Text(
                    'seattle,',
                    style: style16.copyWith(color: Color(0xffC1C0C9)),
                  ),
                  Text(
                    'USA',
                    style: style16.copyWith(color: Color(0xffC1C0C9)),
                  ),
                ],
              ),
              const SizedBox(height: 15), // Add spacing before avatars
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.67,
          left: MediaQuery.of(context).size.width * 0.4 -
              90, // center the row of circle avatars
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircleAvatar(
                radius: 25,
                child: Icon(
                  Icons.refresh_rounded,
                  size: 30,
                ),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 35,
                child: Icon(
                  Icons.emergency_recording_rounded,
                  size: 40,
                ),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 35,
                child: Icon(Icons.call),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 25,
                child: Icon(Icons.star),
              ),
            ],
          ),
        )
      ],
    );
  }
}
