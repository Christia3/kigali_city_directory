import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';

class AddListingScreen extends StatelessWidget {
  AddListingScreen({super.key});

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedCategory = "Hospital";

  final List<String> categories = [
    "Hospital",
    "Police Station",
    "Library",
    "Restaurant",
    "Café",
    "Park",
    "Tourist Attraction"
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Listing")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Place Name"),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: "Contact Number"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: selectedCategory,
              items: categories
                  .map((cat) =>
                      DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
              decoration: const InputDecoration(labelText: "Category"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await provider.addListing(
                  name: nameController.text,
                  category: selectedCategory,
                  address: addressController.text,
                  contact: contactController.text,
                  description: descriptionController.text,
                  latitude: -1.9441,
                  longitude: 30.0619,
                );

                Navigator.pop(context);
              },
              child: const Text("Save Listing"),
            ),
          ],
        ),
      ),
    );
  }
}