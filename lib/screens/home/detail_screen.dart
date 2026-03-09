import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/listing_model.dart';

class DetailScreen extends StatelessWidget {
  final ListingModel listing;

  const DetailScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(listing.latitude, listing.longitude);

    return Scaffold(
      appBar: AppBar(title: Text(listing.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  GOOGLE MAP
          SizedBox(
            height: 250,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: location, zoom: 15),
              markers: {
                Marker(
                  markerId: const MarkerId("place"),
                  position: location,
                  infoWindow: InfoWindow(title: listing.name),
                ),
              },
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listing.name,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(listing.category),
                const SizedBox(height: 10),
                Text(listing.address),
                Text("Contact: ${listing.contact}"),
                const SizedBox(height: 10),
                Text(listing.description),
                const SizedBox(height: 20),

                //  OPEN GOOGLE MAPS NAVIGATION
                ElevatedButton.icon(
                  onPressed: () async {
                    final url =
                        "https://www.google.com/maps/dir/?api=1&destination=${listing.latitude},${listing.longitude}";
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  },
                  icon: const Icon(Icons.navigation),
                  label: const Text("Navigate"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}