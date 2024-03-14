import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shop/screens/AddressScreen.dart';
import 'AddAddressScreen.dart';


class LocationPickerScreen extends StatelessWidget {
  var addressCon = Get.put(AddAddressScreenCon());
  var addController = Get.put(AddAddressScreenCon());
  Rx<LatLng> selectLocation = LatLng(0, 0).obs;
  Rx<LatLng> myCoordinate = LatLng(0, 0).obs;
  final RxSet<Marker> _markers = <Marker>{}.obs;
  final locationList = List<Placemark>.empty().obs;
  GoogleMapController? _mapController;


  void addMarker(LatLng tappedPoint) async {
    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId('1'),
      position: tappedPoint,
    ));
    _mapController?.animateCamera(CameraUpdate.newLatLng(tappedPoint));
  }

  void _onMapTap(LatLng tappedPoint) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      tappedPoint.latitude,
      tappedPoint.longitude,
      localeIdentifier: 'vi_VN',
    );
    print(placemarks);
    addressCon.locationCoor = tappedPoint;
    if (placemarks != null && placemarks.isNotEmpty) {
      locationList.value = placemarks;
    }
    addMarker(tappedPoint);

  }

  Future<LatLng> getCurrentCoordinate() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    return LatLng(lat, long);
  }

  void _goToCurrentLocation() async {
    myCoordinate.value = await getCurrentCoordinate();
    addMarker(myCoordinate.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn địa điểm'),
      ),
      body: Stack(
        children: [
          FutureBuilder<LatLng>(
            future: getCurrentCoordinate(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                myCoordinate.value =snapshot.data!;
                return Obx(() => GoogleMap(
                  markers: Set<Marker>.from(_markers),
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    // target: myCoordinate.value,
                    target: LatLng(21.0195796, 106.814874),
                    zoom: 15,
                  ),
                  onTap: _onMapTap,
                ));
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 300,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
              ),
              child:  IconButton(
                onPressed: _goToCurrentLocation,
                icon: Icon(Icons.my_location),
              ),
            )
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Obx(() => locationList.isEmpty ? SizedBox.shrink() : Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Obx(() =>
                    ListView.builder(
                      itemCount: locationList.value.length,
                      itemBuilder: (context, index) {
                        var street = locationList.value[index].street.toString().trim();
                        var locality = locationList.value[index].locality.toString().trim();
                        var subArea = locationList.value[index].subAdministrativeArea.toString().trim();
                        var adminArea = locationList.value[index].administrativeArea.toString().trim();
                        var country = locationList.value[index].country.toString().trim();
                        return GestureDetector(
                          onTap: () {
                            addController.detailAddressTxt.value = '$street $locality $subArea, $adminArea, $country ';
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15,),
                                Text(
                                  '$street $locality',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  '$street $locality $subArea, $adminArea, $country ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                ),
              ))
          ),

        ],
      ),
    );
  }
}

