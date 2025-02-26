import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/model/discover_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDiscoverWIdget extends StatelessWidget {
  final DiscoverModel discoverModel;
  const CustomDiscoverWIdget({
    required this.discoverModel,
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
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  //   borderRadius: BorderRadius.circular(20),

                  child: Image(
                    height: MediaQuery.of(context).size.height * 0.7,
                    image: NetworkImage('${discoverModel.imageUrl}'),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          '${error.toString()}',
                          style: style16,
                        ),
                      );
                    },
                  )),
              const Spacer(), // Use Spacer to push rows to the bottom
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center horizontally
                children: [
                  Text(
                    '${discoverModel.name}',
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
                        Text('${discoverModel.score}'),
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
                    '${discoverModel.additionalInfo}',
                    style: style16.copyWith(color: Color(0xffC1C0C9)),
                  ),
                  Text(
                    '${discoverModel.location}',
                    style: style16.copyWith(color: Color(0xffC1C0C9)),
                  ),
                ],
              ),
              const SizedBox(height: 15), // Add spacing before avatars
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.66,
          left: MediaQuery.of(context).size.width * 0.4 -
              90, // center the row of circle avatars
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: whiteColor,
                radius: 25,
                child: Icon(
                  Icons.refresh_rounded,
                  size: 30,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 73.h,
                width: 73.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffDB2719),
                  ),
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.video_camera_back,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 73.h,
                width: 73.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffDB2719),
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.call,
                    size: 30,
                  ),
                ),
              ),
              // CircleAvatar(
              //   radius: 35,
              //   child: Icon(Icons.call),
              // ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: whiteColor,
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
