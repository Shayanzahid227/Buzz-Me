// import 'package:card_swiper/card_swiper.dart';
// import 'package:code_structure/ui/screens/discover/discover_screen_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class DiscoverScreen extends StatefulWidget {
//   const DiscoverScreen({super.key});

//   @override
//   State<DiscoverScreen> createState() => _DiscoverScreenState();
// }

// class _DiscoverScreenState extends State<DiscoverScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => DiscoverSCreenViewModel(),
//       child: Consumer<DiscoverSCreenViewModel>(
//         builder: (context, model, child) => Scaffold(
//           body: Column(
//             children: [
//               60.verticalSpace,
//               Swiper(
//                 loop: true,
//                 itemCount: model.imageList.length,
//                 itemHeight: 400.h,
//                 itemWidth: 250.w,
//                 layout: SwiperLayout.TINDER,
//                 indicatorLayout: PageIndicatorLayout.SCALE,
//                 customLayoutOption: CustomLayoutOption(
//                   startIndex: -1,
//                   stateCount: 3,
//                 )
//                   ..addRotate([
//                     -45.0 / 180,
//                     0.0,
//                     45.0 / 180,
//                   ])
//                   ..addTranslate([
//                     const Offset(-370.0, -40.0),
//                     const Offset(0.0, 0.0),
//                     const Offset(370.0, -40.0),
//                   ]),
//                 onIndexChanged: (index) {},
//                 pagination: SwiperPagination(
//                   alignment: Alignment.bottomCenter,
//                   builder: DotSwiperPaginationBuilder(
//                     color: Colors.grey,
//                     activeColor: Colors.black,
//                   ),
//                 ),
//                 scrollDirection: Axis.vertical,
//                 axisDirection: AxisDirection.down,
//                 viewportFraction: 2.0,
//                 scale: 20.0,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     height: 400.h,
//                     width: 400.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.purple.shade100,
//                       image: DecorationImage(
//                         image: NetworkImage(model.imageList[index].toString()),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   } // Widget build(BuildContext context)
// } // class _DiscoverScreenState

//******************************************************/

// import 'package:card_swiper/card_swiper.dart';
// import 'package:code_structure/custom_widgets/buzz%20me/discover_screen.dart';
// import 'package:code_structure/ui/screens/discover/discover_screen_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class ExampleScreen extends StatelessWidget {
//   const ExampleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => DiscoverSCreenViewModel(),
//       child: Consumer<DiscoverSCreenViewModel>(
//         builder: (context, model, child) => Scaffold(
//           appBar: AppBar(
//             title: const Text('Profile Card Example'),
//           ),
//           body: Container(
//             height: double.infinity,
//             width: double.infinity,
//             decoration: BoxDecoration(),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 3,
//                     blurRadius: 7,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.7,
//                     child: Swiper(
//                       layout: SwiperLayout.TINDER,
//                       itemWidth: 300.w,
//                       itemHeight: 800.h,
//                       itemCount: model.discoverList.length,
//                       axisDirection: AxisDirection.down,
//                       scrollDirection: Axis.vertical,
//                       itemBuilder: (context, index) {
//                         return CustomdiscoverWidget(
//                             Object_discoverModel: model.discoverList[index]);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//******************************************************/
import 'package:card_swiper/card_swiper.dart';
import 'package:code_structure/core/constants/app_assest.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/custom_widgets/buzz%20me/discover_screen.dart';
import 'package:code_structure/custom_widgets/buzz%20me/header.dart';
import 'package:code_structure/ui/screens/discover/discover_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiscoverSCreenViewModel(),
      child: Consumer<DiscoverSCreenViewModel>(
        builder: (context, model, child) => Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets().discoverBack),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  20.h.verticalSpace,
                  customHeader(
                    heading: 'Discover',
                    headingColor: whiteColor,
                    image: AppAssets().fbIcon,
                  ),
                  20.verticalSpace,
                  _allUsers(context, model),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _allUsers(BuildContext context, DiscoverSCreenViewModel model) {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
    //   child: Container(
    //     height: MediaQuery.of(context).size.height / 1.4,
    //     decoration: BoxDecoration(color: whiteColor),
    //     child: Swiper(
    //       itemCount: model.discoverList.length,
    //       itemHeight: MediaQuery.of(context).size.height / 1.6,
    //       itemWidth: double.infinity,
    //       itemBuilder: (context, index) {
    //         return Container(
    //           height: 400,
    //           width: 400,
    //           child: CustomDiscoverWIdget(
    //               discoverModel: model.discoverList[index]),
    //         );
    //       },
    //     ),
    //   ),
    // );
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height * 0.73,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            width: double.infinity,
            child: model.matchEngine != null
                ? SwipeCards(
                    matchEngine: model.matchEngine!,
                    itemBuilder: (BuildContext context, int index) {
                      return ColorFiltered(
                        colorFilter: index == 0
                            ? ColorFilter.mode(Colors.grey.withOpacity(0.1),
                                BlendMode.multiply)
                            : index == 1
                                ? ColorFilter.mode(
                                    Colors.transparent, BlendMode.multiply)
                                : ColorFilter.mode(
                                    Colors.grey.withOpacity(0.14),
                                    BlendMode.multiply),
                        child: CustomDiscoverWIdget(
                            discoverModel: model.discoverList[index]),
                      );
                    },
                    onStackFinished: () {
                      // Handle when all cards are swiped
                      model.resetCards();
                    },
                    itemChanged: (SwipeItem item, int index) {
                      // Handle item change if needed
                    },
                    upSwipeAllowed: true,
                    leftSwipeAllowed: true,
                    rightSwipeAllowed: true,
                    fillSpace: false,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}
