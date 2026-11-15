import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/navigation_controller.dart';
import '../routes/app_pages.dart';
import '../theme/app_theme.dart';
import 'episodes_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';

class RootScreen extends GetView<NavigationController> {
  const RootScreen({super.key});

  static const _titles = ['Karakter', 'Favorit', 'Episode'];
  static const _pages = [HomeScreen(), FavoritesScreen(), EpisodesScreen()];

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            _titles[controller.selectedIndex.value],
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              tooltip: 'Profil dan pengaturan',
              onPressed: () => Get.toNamed(AppRoutes.profile),
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                child: Text(
                  (authController.currentUser.value?.name ?? 'U')
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Logout',
              onPressed: authController.isBusy.value
                  ? null
                  : authController.logout,
              icon: authController.isBusy.value
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: IndexedStack(
            index: controller.selectedIndex.value,
            children: _pages,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.selectTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Karakter',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Favorit',
            ),
            NavigationDestination(
              icon: Icon(Icons.live_tv_outlined),
              selectedIcon: Icon(Icons.live_tv),
              label: 'Episode',
            ),
          ],
        ),
      ),
    );
  }
}
