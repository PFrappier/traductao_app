import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traductao_app/providers/navbar_provider.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final String location;
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  static const List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.menu_book_outlined),
      activeIcon: Icon(Icons.menu_book),
      label: 'Vocabulaire',
      initialLocation: '/my_vocabulary',
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.quiz_outlined),
      activeIcon: Icon(Icons.quiz),
      label: 'Quiz',
      initialLocation: '/quiz',
    ),
  ];

  late NavBarProvider _navBarProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navBarProvider = context.read<NavBarProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncIndexWithLocation();
      _navBarProvider.addListener(_handleIndexChange);
    });
  }

  void _syncIndexWithLocation() {
    final index = tabs.indexWhere((tab) => widget.location == tab.initialLocation);
    if (index != -1 && index != _navBarProvider.currentIndex) {
      _navBarProvider.setCurrentIndex(index);
    }
  }

  @override
  void dispose() {
    _navBarProvider.removeListener(_handleIndexChange);
    super.dispose();
  }

  void _handleIndexChange() {
    if (!mounted) return;

    final currentIndex = _navBarProvider.currentIndex;

    String location = tabs[currentIndex].initialLocation;
    context.go(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: Consumer<NavBarProvider>(
        builder: (context, value, child) {
          return BottomNavigationBar(
            // showUnselectedLabels: true,
            // type: BottomNavigationBarType.fixed,
            // selectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
            // unselectedItemColor: Theme.of(
            //   context,
            // ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            // backgroundColor: Theme.of(context).colorScheme.surface,
            // elevation: 3,
            // selectedLabelStyle: TextStyle(
            //   color: Theme.of(context).colorScheme.onSurface,
            //   fontSize: 12,
            // ),
            // unselectedLabelStyle: TextStyle(
            //   color: Theme.of(context).colorScheme.onSurfaceVariant,
            //   fontSize: 12,
            // ),
            onTap: (int index) {
              _goOtherTab(context, index, tabs);
            },
            currentIndex: value.currentIndex,
            items: tabs,
          );
        },
      ),
    );
  }

  void _goOtherTab(
    BuildContext context,
    int index,
    List<MyCustomBottomNavBarItem> currentTabs,
  ) {
    if (index == _navBarProvider.currentIndex) return;
    GoRouter router = GoRouter.of(context);
    String location = currentTabs[index].initialLocation;

    _navBarProvider.setCurrentIndex(index);

    router.go(location);
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem({
    required this.initialLocation,
    required super.icon,
    super.label,
    Widget? activeIcon,
  }) : super(activeIcon: activeIcon ?? icon);
}
