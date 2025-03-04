import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';

import 'package:another_xlider/models/trackbar.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';

import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/core/others/base_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
//******* */

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with TickerProviderStateMixin {
  double _distanceValue = 50.0;
  List<double> _ageRangeValues = [18.0, 30.0];

  ///
  ///
  ///
  String _currentLocation = 'select current location'; // Default location

  void _updateLocation(String location) {
    setState(() {
      _currentLocation = location;
    });
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    TabController(length: 3, vsync: this);
    return ChangeNotifierProvider(
      create: (context) => BaseViewModel(),
      child: Consumer<BaseViewModel>(
        builder: (context, model, child) => DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  50.verticalSpace,

                  ///  header
                  _header(),
                  10.verticalSpace,
                  Divider(),

                  50.verticalSpace,
                  _tababr(),
                  30.verticalSpace,
                  //  _Location(),
                  _selectLocation(),
                  30.verticalSpace,
                  //// selecting age and distance range
                  _buildFilterContent()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter',
            style: style25B.copyWith(
                fontSize: 34, fontWeight: FontWeight.w700, color: headingColor),
          ),
          Text(
            'Done',
            style: style25.copyWith(fontSize: 17.sp, color: indicatorColor),
          )
        ],
      ),
    );
  }

  _tababr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Show me ",
          style: style17.copyWith(
            color: lightGreyColor5,
          ),
        ),
        20.verticalSpacingDiameter,
        Container(
          height: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1), color: tabBarColor),

          ///
          ///   tab bar
          ///
          child: TabBar(
            labelStyle: TextStyle(color: whiteColor),
            labelColor: whiteColor,
            unselectedLabelColor: tabBarTextColor,

            tabAlignment: TabAlignment.start,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              gradient: LinearGradient(
                colors: [lightPinkColor, lightOrangeColor],
              ),
            ),
            isScrollable: true,
            //  labelPadding: EdgeInsets.symmetric(horizontal: 30),
            tabs: [
              ///
              ///  tab 1
              ///
              Container(
                height: 50.h,
                child: Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Guys',
                      style: style25.copyWith(
                          fontSize: 17.sp,
                          color: tabBarTextColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),

              ///
              /// tab 2
              ///
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Girls',
                    style: style25.copyWith(
                        fontSize: 17.sp,
                        color: tabBarTextColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),

              ///
              /// tab 3
              ///
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Both',
                    style: style25.copyWith(
                        fontSize: 17.sp,
                        color: tabBarTextColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _Location() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location",
          style: style17.copyWith(
            color: lightGreyColor5,
          ),
        ),
        20.verticalSpacingDiameter,
        TextFormField(
          decoration: authFieldDecoration.copyWith(),
        ),
      ],
    );
  }

  Widget _buildFilterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        30.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Distance',
              style: style17.copyWith(color: lightGreyColor5),
            ),
            Text(
              '${_distanceValue.toInt()} km',
              style: style25.copyWith(
                  fontSize: 17,
                  color: lightGreyColor3,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        30.verticalSpace,
        FlutterSlider(
          values: [_distanceValue],
          max: 100,
          min: 0,
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 8.4,
            inactiveTrackBarHeight: 8.4,
            activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                colors: [lightPinkColor, lightOrangeColor],
              ),
            ),
            inactiveTrackBar: BoxDecoration(
              color: Colors.grey[300], // Adjust as needed
            ),
          ),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [lightPinkColor, lightOrangeColor],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(4), // Adjust padding for circle size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [lightPinkColor, lightOrangeColor],
                  ),
                ),
              ),
            ),
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            _distanceValue = lowerValue;
            setState(() {});
          },
        ),
        30.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Age range',
              style: style17.copyWith(color: lightGreyColor5),
            ),
            Text(
              '${_ageRangeValues[0].toInt()} - ${_ageRangeValues[1].toInt()}',
              style: style25.copyWith(
                  fontSize: 17,
                  color: lightGreyColor3,
                  fontWeight: FontWeight.w300),
            ),
          ],
        ),
        30.verticalSpace,
        FlutterSlider(
          values: _ageRangeValues,
          max: 50,
          min: 18,
          rangeSlider: true,
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 8.4,
            inactiveTrackBarHeight: 8.4,
            activeTrackBar: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightPinkColor, lightOrangeColor],
              ),
            ),
            inactiveTrackBar: BoxDecoration(
              color: Colors.grey[300], // Adjust as needed
            ),
          ),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [lightPinkColor, lightOrangeColor],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(4), // Adjust padding for circle size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [lightPinkColor, lightOrangeColor],
                  ),
                ),
              ),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [lightPinkColor, lightOrangeColor],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(4), // Adjust padding for circle size
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [lightPinkColor, lightOrangeColor],
                  ),
                ),
              ),
            ),
          ),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            _ageRangeValues = [lowerValue, upperValue];
            setState(() {});
          },
        ),
        SizedBox(height: 24),
      ],
    );
  }

  //***************   container for selecting location    ****************
  ///
  _selectLocation() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        // Use InkWell for tap detection
        onTap: () {
          _showLocationBottomSheet(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Current location ($_currentLocation)'),
            Icon(Icons.send),
          ],
        ),
      ),
    );
  }

  ///                  location selection using bottom sheet
  ///
  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Peshawar,KPK, Pakistan'),
                onTap: () {
                  _updateLocation('Peshawar, KPK, Pakistan');
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                title: Text('Another Location'),
                onTap: () {
                  _updateLocation('Another Location');
                  Navigator.pop(context);
                },
              ),
              // Add more location options here
            ],
          ),
        );
      },
    );
  }
}
