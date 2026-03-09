import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';
import '../../models/listing_model.dart';
import '../../services/auth_service.dart';
import 'add_listing_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const DirectoryTab(),
      const MyListingsTab(),
      const MapTab(),
      const SettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Kigali Directory")),

      body: screens[currentIndex],

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddListingScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Directory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Listings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

/*  DIRECTORY TAB  */

class DirectoryTab extends StatelessWidget {
  const DirectoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingProvider>();
    final listings = provider.filteredListings;

    return Column(
      children: [
        //  Search bar
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search places...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: provider.updateSearch,
          ),
        ),

        //  Category filter
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _chip(context, "All"),
              _chip(context, "Hospital"),
              _chip(context, "Restaurant"),
              _chip(context, "Café"),
              _chip(context, "Park"),
              _chip(context, "Library"),
            ],
          ),
        ),

        const SizedBox(height: 10),

        //  Listings
        Expanded(
          child: listings.isEmpty
              ? const Center(child: Text("No results found"))
              : ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final ListingModel item = listings[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle:
                            Text("${item.category} • ${item.address}"),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String category) {
    final provider = context.watch<ListingProvider>();
    final selected = provider.selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(category),
        selected: selected,
        onSelected: (_) => provider.updateCategory(category),
      ),
    );
  }
}

/*  MY LISTINGS TAB  */

class MyListingsTab extends StatelessWidget {
  const MyListingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ListingProvider>();
    final uid = AuthService().currentUser!.uid;

    final myListings =
        provider.listings.where((e) => e.createdBy == uid).toList();

    if (myListings.isEmpty) {
      return const Center(child: Text("No listings created by you"));
    }

    return ListView.builder(
      itemCount: myListings.length,
      itemBuilder: (context, index) {
        final item = myListings[index];

        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.address),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await provider.deleteListing(item.id);
              },
            ),
          ),
        );
      },
    );
  }
}

/*  MAP TAB  */

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Map integration coming next"));
  }
}

/*  SETTINGS TAB  */

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged in as: ${user?.email}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await AuthService().logout();
            },
            child: const Text("Logout"),
          )
        ],
      ),
    );
  }
}