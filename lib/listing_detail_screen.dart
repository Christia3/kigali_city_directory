import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/listing_model.dart';

class ListingDetailScreen extends StatelessWidget {
  final Listing listing;
  const ListingDetailScreen(this.listing, {super.key});

  openMaps() async {
    final url =
        "https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}";
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listing.name)),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(listing.latitude, listing.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(listing.id),
                  position: LatLng(listing.latitude, listing.longitude),
                )
              },
            ),
          ),
          ElevatedButton(
            onPressed: openMaps,
            child: const Text("Navigate"),
          )
        ],
      ),
    );
  }
}