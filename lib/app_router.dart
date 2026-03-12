import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/info_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/detail_screen.dart';
import 'models/item_model.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ResponsiveScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: '/info',
          builder: (context, state) => const InfoScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return DetailScreen(itemId: id);
          },
        ),
      ],
    ),
  ],
);

// 响应式布局 Scaffold
class ResponsiveScaffold extends StatefulWidget {
  final Widget child;
  
  const ResponsiveScaffold({super.key, required this.child});
  
  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int _selectedIndex = 0;
  
  final List<NavigationItem> _navItems = [
    NavigationItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: '首页', path: '/'),
    NavigationItem(icon: Icons.image_outlined, selectedIcon: Icons.image, label: '画廊', path: '/gallery'),
    NavigationItem(icon: Icons.info_outline, selectedIcon: Icons.info, label: '信息', path: '/info'),
    NavigationItem(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: '设置', path: '/settings'),
  ];
  
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_navItems[index].path);
  }
  
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final isTablet = MediaQuery.of(context).size.width > 450 && MediaQuery.of(context).size.width <= 800;
    
    // 更新当前选中索引基于路由
    final location = GoRouterState.of(context).uri.path;
    _selectedIndex = _navItems.indexWhere((item) => 
      location == item.path || location.startsWith(item.path != '/' ? item.path : '/detail')
    );
    if (_selectedIndex == -1) _selectedIndex = 0;
    
    if (isDesktop) {
      // 桌面布局：左侧导航栏
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              minExtendedWidth: 200,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: _navItems.map((item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: Text(item.label),
              )).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: widget.child),
          ],
        ),
      );
    } else if (isTablet) {
      // 平板布局：可折叠导航栏
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: _navItems.map((item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: Text(item.label),
              )).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: widget.child),
          ],
        ),
      );
    } else {
      // 手机布局：底部导航栏
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _navItems.map((item) => NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          )).toList(),
        ),
      );
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;
  
  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });
}
