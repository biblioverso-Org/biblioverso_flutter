import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../profile/profile_screen.dart';
import '../reservations/reservations_screen.dart';
import '../search/search_screen.dart';
import 'widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    final pages = [
      const HomeContent(),       // index 0
      const SearchScreen(),      // index 1
      const ReservationsScreen(),// index 2
      const ProfileScreen(),     // index 3
    ];

    return Scaffold(
      body: pages[vm.selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            color: Colors.white,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, vm, Icons.home, "Inicio", 0),
                  _buildNavItem(context, vm, Icons.search, "Buscar", 1),
                  const SizedBox(width: 50), // espacio para botón central
                  _buildNavItem(context, vm, Icons.bookmark, "Reservas", 2),
                  _buildNavItem(context, vm, Icons.person, "Perfil", 3),
                ],
              ),
            ),
          ),
          Positioned(
            top: -25,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha:0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.document_scanner_outlined, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, HomeViewModel vm, IconData icon, String label, int index) {
    final isSelected = vm.selectedIndex == index;
    return GestureDetector(
      key: Key('navItem_$index'), // ✅ Key para testing
      onTap: () => vm.onTabTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.deepPurple : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.deepPurple : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
