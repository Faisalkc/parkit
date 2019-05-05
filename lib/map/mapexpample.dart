// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class PlaceMarkerBody extends StatefulWidget {
  const PlaceMarkerBody();

  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  PlaceMarkerBodyState();

  static final LatLng center = const LatLng(-33.86711, 151.1947171);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _add() async{

    final notesReference= FirebaseDatabase.instance.reference().child('parkit');
   await  notesReference.once().then((DataSnapshot snapshot)
        {
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key,values) {
            String markerIdVal = 'marker_id_$key';
            MarkerId markerId = MarkerId(markerIdVal);
            final Marker marker = Marker(
              markerId: markerId,
              position: LatLng(
                double.parse(values['lat'].toString()),
                double.parse(values['log'].toString())
              ),
              infoWindow: InfoWindow(title: values['name'].toString(), snippet: '*'),
              onTap: () {
                _onMarkerTapped(markerId);
              },
            );
            setState(() {
              markers[markerId] = marker;
            });

          });
        });


  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final LatLng current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  void _changeAnchor() {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        anchorParam: newAnchor,
      );
    });
  }

  Future<void> _changeInfoAnchor() async {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.infoWindow.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          anchorParam: newAnchor,
        ),
      );
    });
  }

  Future<void> _toggleDraggable() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        draggableParam: !marker.draggable,
      );
    });
  }

  Future<void> _toggleFlat() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        flatParam: !marker.flat,
      );
    });
  }

  Future<void> _changeInfo() async {
    final Marker marker = markers[selectedMarker];
    final String newSnippet = marker.infoWindow.snippet + '*';
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  Future<void> _changeAlpha() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.alpha;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        alphaParam: current < 0.1 ? 1.0 : current * 0.75,
      );
    });
  }

  Future<void> _changeRotation() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.rotation;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        rotationParam: current == 330.0 ? 0.0 : current + 30.0,
      );
    });
  }

  Future<void> _toggleVisible() async {
    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        visibleParam: !marker.visible,
      );
    });
  }

  Future<void> _changeZIndex() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.zIndex;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        zIndexParam: current == 12.0 ? 0.0 : current + 1.0,
      );
    });
  }

  void _setMarkerIcon(BitmapDescriptor assetIcon) {
    if (selectedMarker == null) {
      return;
    }

    final Marker marker = markers[selectedMarker];
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        iconParam: assetIcon,
      );
    });
  }

  Future<BitmapDescriptor> _getAssetIcon(BuildContext context) async {
    final Completer<BitmapDescriptor> bitmapIcon =
    Completer<BitmapDescriptor>();
    final ImageConfiguration config = createLocalImageConfiguration(context);

    const AssetImage('assets/red_square.png')
        .resolve(config)
        .addListener((ImageInfo image, bool sync) async {
      final ByteData bytes =
      await image.image.toByteData(format: ImageByteFormat.png);
      final BitmapDescriptor bitmap =
      BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
      bitmapIcon.complete(bitmap);
    });

    return await bitmapIcon.future;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-33.852, 151.211),
                zoom: 11.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add'),
                          onPressed: _add,
                        ),
                        FlatButton(
                          child: const Text('remove'),
                          onPressed: _remove,
                        ),
                        FlatButton(
                          child: const Text('change info'),
                          onPressed: _changeInfo,
                        ),
                        FlatButton(
                          child: const Text('change info anchor'),
                          onPressed: _changeInfoAnchor,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('change alpha'),
                          onPressed: _changeAlpha,
                        ),
                        FlatButton(
                          child: const Text('change anchor'),
                          onPressed: _changeAnchor,
                        ),
                        FlatButton(
                          child: const Text('toggle draggable'),
                          onPressed: _toggleDraggable,
                        ),
                        FlatButton(
                          child: const Text('toggle flat'),
                          onPressed: _toggleFlat,
                        ),
                        FlatButton(
                          child: const Text('change position'),
                          onPressed: _changePosition,
                        ),
                        FlatButton(
                          child: const Text('change rotation'),
                          onPressed: _changeRotation,
                        ),
                        FlatButton(
                          child: const Text('toggle visible'),
                          onPressed: _toggleVisible,
                        ),
                        FlatButton(
                          child: const Text('change zIndex'),
                          onPressed: _changeZIndex,
                        ),
                        FlatButton(
                          child: const Text('set marker icon'),
                          onPressed: () {
                            _getAssetIcon(context).then(
                                  (BitmapDescriptor icon) {
                                _setMarkerIcon(icon);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}