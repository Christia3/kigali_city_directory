import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';

class DirectoryScreen extends StatelessWidget {
  static const categories = [
    "All",
    "Hospital",
    "Police Station",
    "Restaurant",
    "Café",
    "Park",
    "Tourist Attraction"
  ];

  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ListingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Kigali Directory")),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Search place...",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: provider.setSearch,
          ),

          DropdownButton(
            value: provider.selectedCategory,
            items: categories
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => provider.setCategory(v.toString()),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: provider.listings.length,
              itemBuilder: (context, i) {
                final l = provider.listings[i];
                return ListTile(
                  title: Text(l.name),
                  subtitle: Text(l.category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}