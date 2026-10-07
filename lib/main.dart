import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const IITUCampusApp());
  } catch (error) {
    runApp(
      FirebaseStartupErrorApp(
        message: error.toString(),
      ),
    );
  }
}

class FirebaseStartupErrorApp extends StatelessWidget {
  final String message;

  const FirebaseStartupErrorApp({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFF7F7F9),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 48,
                      color: Color(0xFFB71930),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Firebase could not start',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Check the Firebase configuration and your internet connection, then restart the app.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF74777F),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

const Color iituRed = Color(0xFFB71930);
const Color iituDarkRed = Color(0xFF851124);

const Color darkText = Color(0xFF18191D);
const Color greyText = Color(0xFF74777F);

const Color pageBackground = Color(0xFFF7F7F9);
const Color softGrey = Color(0xFFF1F2F5);
const Color softRed = Color(0xFFFCECEF);
const Color borderColor = Color(0xFFE4E5EA);

const Color navy = Color(0xFF071D2C);
const Color successGreen = Color(0xFF268A5B);

// ============================================================
// ROUTE NAMES
// ============================================================

// Requirement: route names are defined once and reused everywhere.
class AppRoutes {
  static const home = '/';
  static const timetable = '/timetable';
  static const services = '/services';
  static const events = '/events';
  static const campus = '/campus';
  static const profile = '/profile';
  static const serviceDetail = '/service-detail';
}

// Prevents accidental duplicate routes when a navigation control is tapped rapidly.
DateTime? _lastNavigationAt;

bool _navigationAllowed() {
  final now = DateTime.now();
  if (_lastNavigationAt != null &&
      now.difference(_lastNavigationAt!) < const Duration(milliseconds: 450)) {
    return false;
  }
  _lastNavigationAt = now;
  return true;
}

Future<T?> safePushNamed<T>(
    BuildContext context,
    String route, {
      Object? arguments,
    }) {
  if (!_navigationAllowed()) {
    return Future<T?>.value(null);
  }
  return Navigator.pushNamed<T>(context, route, arguments: arguments);
}

Future<T?> safePush<T>(BuildContext context, Route<T> route) {
  if (!_navigationAllowed()) {
    return Future<T?>.value(null);
  }
  return Navigator.push<T>(context, route);
}

// ============================================================
// APP
// ============================================================

class IITUCampusApp extends StatelessWidget {
  const IITUCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IITU Campus',
      initialRoute: AppRoutes.home,

      theme: base.copyWith(
        scaffoldBackgroundColor: pageBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: iituRed,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          base.textTheme,
        ).apply(
          bodyColor: darkText,
          displayColor: darkText,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F7F9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 16,
          ),
          labelStyle: const TextStyle(
            color: greyText,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF9A9DA5),
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: iituRed,
              width: 1.4,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: iituRed,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(
              color: iituRed,
              width: 1.4,
            ),
          ),
        ),
      ),

      // Requirement: minimum four named routes.
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.timetable: (_) => const TimetableScreen(),
        AppRoutes.services: (_) => const ServicesScreen(),
        AppRoutes.events: (_) => const EventsScreen(),
        AppRoutes.campus: (_) => const CampusScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },

      // Requirement: pass an object to a details route.
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.serviceDetail) {
          final argument = settings.arguments;

          if (argument is CampusService) {
            return MaterialPageRoute(
              builder: (_) => ServiceDetailScreen(
                service: argument,
              ),
              settings: settings,
            );
          }
        }

        return null;
      },

      // Requirement: fallback for an unknown route.
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => UnknownRouteScreen(
            routeName: settings.name ?? 'Unknown route',
          ),
        );
      },
    );
  }
}

// ============================================================
// MODELS
// ============================================================

class CampusService {
  final String name;
  final String description;
  final String location;
  final String openingHours;
  final String contact;
  final String status;
  final IconData icon;
  final Color color;

  const CampusService({
    required this.name,
    required this.description,
    required this.location,
    required this.openingHours,
    required this.contact,
    required this.status,
    required this.icon,
    this.color = iituRed,
  });
}

class CampusEvent {
  final String title;
  final String category;
  final String date;
  final String time;
  final String venue;
  final String image;
  final String description;
  final List<String> expectations;

  const CampusEvent({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.venue,
    required this.image,
    required this.description,
    required this.expectations,
  });
}

class ClassItem {
  final int day;
  final int timeSlot;
  final String module;
  final String room;
  final String time;
  final bool nextClass;

  const ClassItem({
    required this.day,
    required this.timeSlot,
    required this.module,
    required this.room,
    required this.time,
    this.nextClass = false,
  });
}

class PlannerItem {
  final String title;
  final DateTime date;
  final TimeOfDay time;
  bool completed;

  PlannerItem({
    required this.title,
    required this.date,
    required this.time,
    this.completed = false,
  });
}

// ============================================================
// SAMPLE DATA
// ============================================================

const campusServices = [
  CampusService(
    name: 'IT Helpdesk',
    description:
    'Technical support for university accounts, Wi-Fi, devices and digital services.',
    location: 'Room 205',
    openingHours: '09:00 – 18:00',
    contact: 'helpdesk@iitu.edu.kz',
    status: 'Open',
    icon: Icons.support_agent_outlined,
    color: Color(0xFF3B82F6),
  ),
  CampusService(
    name: 'Student Affairs',
    description:
    'Support with student documents, campus life and general university questions.',
    location: 'Student Centre',
    openingHours: '09:00 – 17:30',
    contact: 'student.affairs@iitu.edu.kz',
    status: 'Open',
    icon: Icons.groups_outlined,
    color: Color(0xFFF59E0B),
  ),
  CampusService(
    name: 'Library Services',
    description:
    'Library access, borrowing support, study rooms and academic resources.',
    location: 'Level 3',
    openingHours: '08:30 – 20:00',
    contact: 'library@iitu.edu.kz',
    status: 'Open',
    icon: Icons.local_library_outlined,
    color: Color(0xFF7C3AED),
  ),
  CampusService(
    name: 'Academic Office',
    description:
    'Academic documents, course information and administrative support.',
    location: 'Room 312',
    openingHours: '09:00 – 17:00',
    contact: 'academic@iitu.edu.kz',
    status: 'Open',
    icon: Icons.school_outlined,
    color: Color(0xFF0F9D8A),
  ),
  CampusService(
    name: 'Finance Office',
    description:
    'Questions about tuition payments, invoices and student financial records.',
    location: 'Room 118',
    openingHours: '09:00 – 17:00',
    contact: 'finance@iitu.edu.kz',
    status: 'Open',
    icon: Icons.account_balance_wallet_outlined,
    color: Color(0xFF2E8B57),
  ),
  CampusService(
    name: 'Career Center',
    description:
    'Internships, CV support, career events and employment opportunities.',
    location: 'Room 405',
    openingHours: '10:00 – 18:00',
    contact: 'career@iitu.edu.kz',
    status: 'Open',
    icon: Icons.work_outline_rounded,
    color: Color(0xFF4F46E5),
  ),
];

const campusEvents = [
  CampusEvent(
    title: 'Almaty Student Hackathon',
    category: 'Hackathon',
    date: '12 October 2026',
    time: '10:00 – 18:00',
    venue: 'Almaty',
    image: 'assets/images/event_hackathon.jpg',
    description:
    'A full-day student hackathon focused on technology, teamwork and innovative digital solutions.',
    expectations: [
      'Team-based innovation challenge',
      'Mentorship from industry specialists',
      'Networking opportunities',
      'Final project presentations',
    ],
  ),
  CampusEvent(
    title: 'Cybersecurity Workshop',
    category: 'Workshop',
    date: '18 October 2026',
    time: '14:00 – 17:00',
    venue: 'IITU Campus',
    image: 'assets/images/event_cybersecurity.jpg',
    description:
    'A practical session on cybersecurity, networks and modern digital security tools.',
    expectations: [
      'Practical security exercises',
      'Network-security demonstrations',
      'Discussion of real security risks',
      'Q&A session',
    ],
  ),
  CampusEvent(
    title: 'Career & Internship Fair',
    category: 'Career',
    date: '24 October 2026',
    time: '11:00 – 16:00',
    venue: 'IITU Main Hall',
    image: 'assets/images/event_career.jpg',
    description:
    'Meet employers and explore internships, graduate opportunities and career pathways.',
    expectations: [
      'Meet recruiters',
      'Explore internship programmes',
      'Ask employers questions',
      'Build professional connections',
    ],
  ),
];

const classItems = [
  ClassItem(
    day: 1,
    timeSlot: 0,
    module: 'Network Security',
    room: 'Room 304',
    time: '09:00',
    nextClass: true,
  ),
  ClassItem(
    day: 2,
    timeSlot: 1,
    module: 'Cloud Computing',
    room: 'Lab 212',
    time: '11:00',
  ),
  ClassItem(
    day: 0,
    timeSlot: 2,
    module: 'Machine Learning',
    room: 'Room 406',
    time: '14:00',
  ),
  ClassItem(
    day: 3,
    timeSlot: 3,
    module: 'ERP Programming',
    room: 'Room 302',
    time: '16:00',
  ),
  ClassItem(
    day: 4,
    timeSlot: 1,
    module: 'Data Science',
    room: 'Room 218',
    time: '11:00',
  ),
];

// ============================================================
// COMMON APP SHELL
// ============================================================

class CampusScaffold extends StatelessWidget {
  final String currentRoute;
  final Widget child;
  final String? title;

  const CampusScaffold({
    super.key,
    required this.currentRoute,
    required this.child,
    this.title,
  });

  void _navigate(
      BuildContext context,
      String route,
      ) {
    if (route == currentRoute) {
      return;
    }

    if (route == AppRoutes.home) {
      Navigator.popUntil(
        context,
        ModalRoute.withName(AppRoutes.home),
      );
      return;
    }

    // Navigation between registered routes uses Navigator.pushNamed().
    safePushNamed(
      context,
      route,
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Campus search'),
          content: const TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Search IITU Campus',
              hintText: 'Try: Library, Events, IT Helpdesk',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No new notifications right now.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  int _mobileIndex() {
    switch (currentRoute) {
      case AppRoutes.events:
        return 1;
      case AppRoutes.campus:
        return 2;
      case AppRoutes.services:
        return 3;
      case AppRoutes.profile:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        automaticallyImplyLeading: !desktop,
        leading: desktop &&
            currentRoute != AppRoutes.home &&
            Navigator.canPop(context)
            ? IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        )
            : null,
        toolbarHeight: desktop ? 72 : 68,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              width: desktop ? 145 : 110,
              height: 42,
              child: const AppAssetImage(
                path: 'assets/images/iitu_logo.png',
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
            if (desktop && title != null) ...[
              const SizedBox(width: 24),
              Container(
                width: 1,
                height: 26,
                color: borderColor,
              ),
              const SizedBox(width: 18),
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Search',
            onPressed: () => _showSearchDialog(context),
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _showNotifications(context),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => _navigate(
              context,
              AppRoutes.profile,
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 18),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: softRed,
                backgroundImage: AssetImage(
                  'assets/images/profile_irada.png',
                ),
              ),
            ),
          ),
        ],
      ),

      // On mobile the left navigation becomes a Drawer.
      drawer: desktop
          ? null
          : Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iituDarkRed,
                    iituRed,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(
                      'assets/images/profile_irada.png',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Akvarzhanova Irada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Network Security · 3rd Year',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            DrawerNavTile(
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                _navigate(context, AppRoutes.home);
              },
            ),
            DrawerNavTile(
              icon: Icons.calendar_month_outlined,
              title: 'Schedule & Planner',
              onTap: () {
                Navigator.pop(context);
                _navigate(context, AppRoutes.timetable);
              },
            ),
            DrawerNavTile(
              icon: Icons.event_outlined,
              title: 'Events',
              onTap: () {
                Navigator.pop(context);
                _navigate(context, AppRoutes.events);
              },
            ),
            DrawerNavTile(
              icon: Icons.map_outlined,
              title: 'Campus',
              onTap: () {
                Navigator.pop(context);
                _navigate(context, AppRoutes.campus);
              },
            ),
            DrawerNavTile(
              icon: Icons.support_agent_outlined,
              title: 'Services',
              onTap: () {
                Navigator.pop(context);
                _navigate(context, AppRoutes.services);
              },
            ),
            DrawerNavTile(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                _navigate(context, AppRoutes.profile);
              },
            ),
          ],
        ),
      ),

      // Desktop keeps a permanent left menu. The page itself is still
      // opened with Navigator routes; this sidebar is only the control UI.
      body: SafeArea(
        top: false,
        child: desktop
            ? Row(
          children: [
            DesktopSidebar(
              currentRoute: currentRoute,
              onNavigate: (route) => _navigate(context, route),
            ),
            Expanded(child: child),
          ],
        )
            : child,
      ),

      bottomNavigationBar: desktop
          ? null
          : BottomNavigationBar(
        currentIndex: _mobileIndex(),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: iituRed,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) {
          switch (index) {
            case 0:
              _navigate(context, AppRoutes.home);
              break;
            case 1:
              _navigate(context, AppRoutes.events);
              break;
            case 2:
              _navigate(context, AppRoutes.campus);
              break;
            case 3:
              _navigate(context, AppRoutes.services);
              break;
            case 4:
              _navigate(context, AppRoutes.profile);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Campus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            activeIcon: Icon(Icons.support_agent),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DesktopSidebar extends StatelessWidget {
  final String currentRoute;
  final ValueChanged<String> onNavigate;

  const DesktopSidebar({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CAMPUS MENU',
                style: TextStyle(
                  color: greyText,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                SidebarNavItem(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  active: currentRoute == AppRoutes.home,
                  onTap: () => onNavigate(AppRoutes.home),
                ),
                SidebarNavItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Schedule',
                  active: currentRoute == AppRoutes.timetable,
                  onTap: () => onNavigate(AppRoutes.timetable),
                ),
                SidebarNavItem(
                  icon: Icons.event_outlined,
                  label: 'Events',
                  active: currentRoute == AppRoutes.events,
                  onTap: () => onNavigate(AppRoutes.events),
                ),
                SidebarNavItem(
                  icon: Icons.map_outlined,
                  label: 'Campus',
                  active: currentRoute == AppRoutes.campus,
                  onTap: () => onNavigate(AppRoutes.campus),
                ),
                SidebarNavItem(
                  icon: Icons.support_agent_outlined,
                  label: 'Services',
                  active: currentRoute == AppRoutes.services,
                  onTap: () => onNavigate(AppRoutes.services),
                ),
                SidebarNavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  active: currentRoute == AppRoutes.profile,
                  onTap: () => onNavigate(AppRoutes.profile),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 18),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: softRed,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: iituRed.withOpacity(0.10),
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage(
                    'assets/images/profile_irada.png',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Irada',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Network Security',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: greyText,
                          fontSize: 8.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const SidebarNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<SidebarNavItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = widget.active || hover;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: widget.active
                  ? softRed
                  : hover
                  ? const Color(0xFFF8F8FA)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.active
                    ? iituRed.withOpacity(0.22)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 19,
                  color: highlighted ? iituRed : greyText,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: highlighted ? iituRed : darkText,
                    fontSize: 11.5,
                    fontWeight:
                    widget.active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CampusScaffold(
      currentRoute: AppRoutes.home,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeroHomeSection(),

            MaxWidth(
              child: Column(
                children: [
                  const SizedBox(height: 55),

                  const AcademicStrip(),

                  const SizedBox(height: 18),

                  HomeReminderCard(
                    onTap: () {
                      safePushNamed(
                        context,
                        AppRoutes.timetable,
                      );
                    },
                  ),

                  const SizedBox(height: 95),

                  SectionHeading(
                    eyebrow: 'STUDENT SPACE',
                    title: 'Everything you need, around you.',
                    subtitle:
                    'Open your schedule, events, campus services and student tools from one dashboard.',
                  ),

                  const SizedBox(height: 32),

                  DashboardGrid(
                    onSchedule: () {
                      safePushNamed(
                        context,
                        AppRoutes.timetable,
                      );
                    },
                    onServices: () {
                      safePushNamed(
                        context,
                        AppRoutes.services,
                      );
                    },
                    onEvents: () {
                      safePushNamed(
                        context,
                        AppRoutes.events,
                      );
                    },
                    onCampus: () {
                      safePushNamed(
                        context,
                        AppRoutes.campus,
                      );
                    },
                  ),

                  const SizedBox(height: 105),

                  StudentSupportPromo(
                    onTap: () {
                      safePushNamed(
                        context,
                        AppRoutes.services,
                      );
                    },
                  ),

                  const SizedBox(height: 105),

                  HomeEventsPreview(
                    onViewAll: () {
                      safePushNamed(
                        context,
                        AppRoutes.events,
                      );
                    },
                  ),

                  const SizedBox(height: 100),

                  const CampusLifeSection(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// HERO
// ============================================================

class HeroHomeSection extends StatefulWidget {
  const HeroHomeSection({super.key});

  @override
  State<HeroHomeSection> createState() => _HeroHomeSectionState();
}

class _HeroHomeSectionState extends State<HeroHomeSection> {
  static const List<String> _heroImages = [
    'assets/images/hero_campus.png',
    'assets/images/iitu_campus2.png',
    'assets/images/iitu_campus3.png',
  ];

  int _currentImage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // A slow automatic hero slider keeps the Home page alive without
    // distracting from the text or navigation.
    _timer = Timer.periodic(
      const Duration(seconds: 6),
          (_) {
        if (!mounted) return;
        setState(() {
          _currentImage = (_currentImage + 1) % _heroImages.length;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _animatedImage() {
    final path = _heroImages[_currentImage];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1100),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: TweenAnimationBuilder<double>(
        key: ValueKey(path),
        duration: const Duration(milliseconds: 5600),
        curve: Curves.easeOutCubic,
        tween: Tween<double>(
          begin: 1.035,
          end: 1.0,
        ),
        builder: (
            context,
            scale,
            child,
            ) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AppAssetImage(
          path: path,
        ),
      ),
    );
  }

  Widget _indicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        _heroImages.length,
            (index) {
          final active = index == _currentImage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(left: 6),
            width: active ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: active ? iituRed : Colors.white.withOpacity(0.78),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final desktop = constraints.maxWidth >= 850;

        if (!desktop) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    50,
                    24,
                    45,
                  ),
                  child: HeroCopy(
                    mobile: true,
                  ),
                ),
                SizedBox(
                  height: 330,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRect(
                        child: _animatedImage(),
                      ),
                      Positioned(
                        right: 18,
                        bottom: 18,
                        child: _indicators(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 620,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: _animatedImage(),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.98),
                      Colors.white.withOpacity(0.75),
                      Colors.white.withOpacity(0.10),
                    ],
                    stops: const [
                      0,
                      0.32,
                      0.61,
                      1,
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 690,
                  child: Padding(
                    padding: EdgeInsets.only(left: 52),
                    child: HeroCopy(),
                  ),
                ),
              ),
              Positioned(
                right: 28,
                bottom: 26,
                child: _indicators(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HeroCopy extends StatelessWidget {
  final bool mobile;

  const HeroCopy({
    super.key,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        RevealWidget(
          delay: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: softRed,
              borderRadius:
              BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  color: iituRed,
                  size: 15,
                ),
                SizedBox(width: 7),
                Text(
                  'INTERNATIONAL INFORMATION TECHNOLOGY UNIVERSITY',
                  style: TextStyle(
                    color: iituRed,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 27),

        RevealWidget(
          delay: 170,
          child: Text(
            'Your Campus.\nYour Future.\nYour IITU.',
            style: TextStyle(
              fontSize: mobile ? 44 : 60,
              height: 1.02,
              letterSpacing:
              mobile ? -1.7 : -2.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 21),

        RevealWidget(
          delay: 260,
          child: SizedBox(
            width: 520,
            child: Text(
              'A smarter way to explore academic life, student services, events and opportunities at IITU.',
              style: TextStyle(
                color: greyText,
                fontSize: mobile ? 14 : 16,
                height: 1.65,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        RevealWidget(
          delay: 350,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.campus,
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: iituRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 17,
            ),
            label: const Text(
              'Explore Campus',
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// HOME ACADEMIC STRIP
// ============================================================

class AcademicStrip extends StatelessWidget {
  const AcademicStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final desktop =
              constraints.maxWidth >= 760;

          const greeting = Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Irada.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.7,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Here’s your academic overview for today.',
                style: TextStyle(
                  color: greyText,
                  fontSize: 12,
                ),
              ),
            ],
          );

          const values = Wrap(
            spacing: 26,
            runSpacing: 18,
            children: [
              AcademicMiniValue(
                label: 'SEMESTER',
                value: '5',
              ),
              AcademicMiniValue(
                label: 'GPA',
                value: '3.5',
              ),
              AcademicMiniValue(
                label: 'CREDITS',
                value: '90',
              ),
              AcademicMiniValue(
                label: 'ATTENDANCE',
                value: '92%',
              ),
            ],
          );

          if (!desktop) {
            return const Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                greeting,
                SizedBox(height: 24),
                values,
              ],
            );
          }

          return const Row(
            children: [
              Expanded(
                child: greeting,
              ),
              values,
            ],
          );
        },
      ),
    );
  }
}

class HomeReminderCard extends StatelessWidget {
  final VoidCallback onTap;

  const HomeReminderCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: softRed,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: iituRed.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                color: iituRed,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEXT CLASS REMINDER',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Network Security · Tuesday 09:00 · Room 304',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: iituRed,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD GRID
// ============================================================

class DashboardGrid extends StatelessWidget {
  final VoidCallback onSchedule;
  final VoidCallback onServices;
  final VoidCallback onEvents;
  final VoidCallback onCampus;

  const DashboardGrid({
    super.key,
    required this.onSchedule,
    required this.onServices,
    required this.onEvents,
    required this.onCampus,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        double width;

        if (constraints.maxWidth >= 900) {
          width =
              (constraints.maxWidth - 42) / 4;
        } else if (constraints.maxWidth >=
            600) {
          width =
              (constraints.maxWidth - 14) / 2;
        } else {
          width = constraints.maxWidth;
        }

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: width,
              child: DashboardCard(
                icon:
                Icons.calendar_month_outlined,
                title: 'Schedule',
                subtitle:
                'Timetable, calendar and planner.',
                onTap: onSchedule,
              ),
            ),
            SizedBox(
              width: width,
              child: DashboardCard(
                icon:
                Icons.support_agent_outlined,
                title: 'Services',
                subtitle:
                'Get help from campus services.',
                onTap: onServices,
              ),
            ),
            SizedBox(
              width: width,
              child: DashboardCard(
                icon: Icons.event_outlined,
                title: 'Events',
                subtitle:
                'Workshops, hackathons and careers.',
                onTap: onEvents,
              ),
            ),
            SizedBox(
              width: width,
              child: DashboardCard(
                icon: Icons.map_outlined,
                title: 'Campus',
                subtitle:
                'Explore university locations.',
                onTap: onCampus,
              ),
            ),
          ],
        );
      },
    );
  }
}

class DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<DashboardCard> createState() =>
      _DashboardCardState();
}

class _DashboardCardState
    extends State<DashboardCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius:
        BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 190,
          ),
          height: 180,
          padding: const EdgeInsets.all(23),
          decoration: BoxDecoration(
            color:
            hover ? softRed : Colors.white,
            borderRadius:
            BorderRadius.circular(24),
            border: Border.all(
              color:
              hover ? iituRed : borderColor,
            ),
            boxShadow: hover
                ? [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.045),
                blurRadius: 24,
                offset:
                const Offset(0, 10),
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: hover
                      ? Colors.white
                      : softRed,
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: Icon(
                  widget.icon,
                  color: iituRed,
                ),
              ),

              const Spacer(),

              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                widget.subtitle,
                style: const TextStyle(
                  color: greyText,
                  fontSize: 10.5,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOME SUPPORT PROMO
// ============================================================

class StudentSupportPromo extends StatelessWidget {
  final VoidCallback onTap;

  const StudentSupportPromo({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          eyebrow: 'STUDENT SUPPORT',
          title: 'Help when you need it.',
          subtitle:
          'Quick access to campus support without searching through university departments.',
        ),

        const SizedBox(height: 35),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(36),
          decoration: BoxDecoration(
            color: const Color(0xFFFBFBFC),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: LayoutBuilder(
            builder: (
                context,
                constraints,
                ) {
              final desktop =
                  constraints.maxWidth >= 850;

              final features = const [
                SupportFeature(
                  Icons.flash_on_outlined,
                  'Quick Help',
                  'Find the right service quickly.',
                ),
                SupportFeature(
                  Icons.report_problem_outlined,
                  'Common Issues',
                  'Wi-Fi, ID card, dormitory and documents.',
                ),
                SupportFeature(
                  Icons.receipt_long_outlined,
                  'Request Status',
                  'See your latest request status.',
                ),
                SupportFeature(
                  Icons.support_agent_outlined,
                  'Service Request',
                  'Submit an issue online.',
                ),
              ];

              final mockup = Container(
                width: 290,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(28),
                  border: Border.all(
                    color: borderColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.045),
                      blurRadius: 30,
                      offset:
                      const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 34,
                      child: AppAssetImage(
                        path:
                        'assets/images/iitu_logo.png',
                        fit: BoxFit.contain,
                        alignment:
                        Alignment.centerLeft,
                      ),
                    ),
                    const SizedBox(height: 21),
                    const Text(
                      'IITU Student Support',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'How can we help?',
                      style: TextStyle(
                        color: greyText,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SmallSupportRow(
                      icon: Icons.wifi,
                      text: 'Wi-Fi / Internet',
                    ),
                    const SmallSupportRow(
                      icon: Icons.badge_outlined,
                      text: 'Student ID Card',
                    ),
                    const SmallSupportRow(
                      icon:
                      Icons.description_outlined,
                      text: 'Academic Documents',
                    ),
                    const SizedBox(height: 13),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style:
                        ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: iituRed,
                          foregroundColor:
                          Colors.white,
                        ),
                        child:
                        const Text('Get Help'),
                      ),
                    ),
                  ],
                ),
              );

              if (!desktop) {
                return Column(
                  children: [
                    mockup,
                    const SizedBox(height: 25),
                    ...features.map(
                          (feature) =>
                          SupportPromoRow(
                            feature: feature,
                          ),
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SupportPromoRow(
                          feature: features[0],
                        ),
                        SupportPromoRow(
                          feature: features[1],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 36),
                  mockup,
                  const SizedBox(width: 36),
                  Expanded(
                    child: Column(
                      children: [
                        SupportPromoRow(
                          feature: features[2],
                        ),
                        SupportPromoRow(
                          feature: features[3],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: iituRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 17,
            ),
            label: const Text(
              'Get Student Support',
            ),
          ),
        ),
      ],
    );
  }
}

class SupportFeature {
  final IconData icon;
  final String title;
  final String text;

  const SupportFeature(
      this.icon,
      this.title,
      this.text,
      );
}

class SupportPromoRow extends StatelessWidget {
  final SupportFeature feature;

  const SupportPromoRow({
    super.key,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: softRed,
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              feature.icon,
              color: iituRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.text,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 9.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmallSupportRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SmallSupportRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iituRed,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOME EVENTS PREVIEW
// ============================================================

class HomeEventsPreview extends StatelessWidget {
  final VoidCallback onViewAll;

  const HomeEventsPreview({
    super.key,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: SectionHeading(
                eyebrow: 'UPCOMING',
                title: 'What’s happening next?',
                subtitle:
                'Discover student events and opportunities.',
              ),
            ),
            TextButton.icon(
              onPressed: onViewAll,
              icon: const Icon(
                Icons.arrow_forward,
                size: 15,
              ),
              label: const Text(
                'View all',
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            double width;

            if (constraints.maxWidth >= 900) {
              width =
                  (constraints.maxWidth - 28) / 3;
            } else if (constraints.maxWidth >=
                600) {
              width =
                  (constraints.maxWidth - 14) / 2;
            } else {
              width = constraints.maxWidth;
            }

            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: campusEvents.map(
                    (event) {
                  return SizedBox(
                    width: width,
                    child: EventPreviewCard(
                      event: event,
                      onTap: onViewAll,
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// CAMPUS LIFE
// ============================================================

class CampusLifeSection extends StatelessWidget {
  const CampusLifeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          eyebrow: 'CAMPUS LIFE',
          title: 'Designed for more than classes.',
          subtitle:
          'Study, collaborate, research and explore university life.',
        ),

        const SizedBox(height: 30),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final desktop =
                constraints.maxWidth >= 850;

            if (!desktop) {
              return const Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: CampusImageCard(
                      image:
                      'assets/images/campus_building.jpg',
                      title:
                      'Academic Building',
                      subtitle:
                      'Modern spaces for learning.',
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 250,
                    child: CampusImageCard(
                      image:
                      'assets/images/campus_lab.png',
                      title:
                      'Technology Labs',
                      subtitle:
                      'Build. Test. Innovate.',
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 250,
                    child: CampusImageCard(
                      image:
                      'assets/images/campus_library.jpg',
                      title: 'Library',
                      subtitle:
                      'Read. Research. Focus.',
                    ),
                  ),
                ],
              );
            }

            return const SizedBox(
              height: 470,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CampusImageCard(
                      image:
                      'assets/images/campus_building.jpg',
                      title:
                      'Academic Building',
                      subtitle:
                      'Modern spaces for learning and collaboration.',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: CampusImageCard(
                            image:
                            'assets/images/campus_lab.png',
                            title:
                            'Technology Labs',
                            subtitle:
                            'Build. Test. Innovate.',
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: CampusImageCard(
                            image:
                            'assets/images/campus_library.jpg',
                            title: 'Library',
                            subtitle:
                            'Read. Research. Focus.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// TIMETABLE / SCHEDULE & PLANNER
// ============================================================

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() =>
      _TimetableScreenState();
}

class _TimetableScreenState
    extends State<TimetableScreen> {
  final TextEditingController _plannerController =
  TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime =
  const TimeOfDay(hour: 18, minute: 0);

  final List<PlannerItem> _plannerItems = [];

  @override
  void dispose() {
    _plannerController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 2,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
    }
  }

  Future<void> _chooseTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
    }
  }

  void _addPlannerItem() {
    final title =
    _plannerController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a planner title.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _plannerItems.add(
        PlannerItem(
          title: title,
          date: _selectedDate,
          time: _selectedTime,
        ),
      );

      _plannerController.clear();
    });
  }

  String _dateText(
      DateTime date,
      ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return CampusScaffold(
      currentRoute: AppRoutes.timetable,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          55,
          24,
          90,
        ),
        child: MaxWidth(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'STUDENT SCHEDULE',
                title: 'Schedule & Planner',
                subtitle:
                'View your weekly timetable, choose dates and plan university tasks.',
              ),

              const SizedBox(height: 32),

              LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  final desktop =
                      constraints.maxWidth >= 920;

                  final timetable = WeeklyTimetable(
                    plannerItems: _plannerItems,
                  );

                  final planner = Column(
                    children: [
                      CalendarPanel(
                        selectedDate:
                        _selectedDate,
                        onDateSelected:
                            (date) {
                          setState(() {
                            _selectedDate =
                                date;
                          });
                        },
                      ),

                      const SizedBox(height: 17),

                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            26,
                          ),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            const Text(
                              'ADD TO PLANNER',
                              style: TextStyle(
                                color: iituRed,
                                fontSize: 9,
                                fontWeight:
                                FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Plan your day',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 17),

                            TextField(
                              controller:
                              _plannerController,
                              decoration:
                              const InputDecoration(
                                labelText: 'Title',
                                hintText:
                                'Finish ML assignment',
                              ),
                            ),

                            const SizedBox(height: 13),

                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      17,
                                    ),
                                    onTap:
                                    _chooseDate,
                                    child: InputLikeBox(
                                      icon: Icons
                                          .calendar_month_outlined,
                                      text: _dateText(
                                        _selectedDate,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: InkWell(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      17,
                                    ),
                                    onTap:
                                    _chooseTime,
                                    child: InputLikeBox(
                                      icon: Icons
                                          .access_time_outlined,
                                      text:
                                      _selectedTime
                                          .format(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            SizedBox(
                              width: double.infinity,
                              child:
                              ElevatedButton(
                                onPressed:
                                _addPlannerItem,
                                style:
                                ElevatedButton
                                    .styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                  iituRed,
                                  foregroundColor:
                                  Colors.white,
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  'Add to Planner',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  if (!desktop) {
                    return Column(
                      children: [
                        timetable,
                        const SizedBox(height: 22),
                        planner,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: timetable,
                      ),
                      const SizedBox(width: 22),
                      SizedBox(
                        width: 360,
                        child: planner,
                      ),
                    ],
                  );
                },
              ),

              if (_plannerItems.isNotEmpty) ...[
                const SizedBox(height: 30),

                const Text(
                  'Your planner',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 15),

                ..._plannerItems.map(
                      (item) {
                    return PlannerItemCard(
                      item: item,
                      onToggle: () {
                        setState(() {
                          item.completed =
                          !item.completed;
                        });
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklyTimetable extends StatelessWidget {
  final List<PlannerItem> plannerItems;

  const WeeklyTimetable({
    super.key,
    required this.plannerItems,
  });

  static const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  static const times = [
    '09:00',
    '11:00',
    '14:00',
    '16:00',
    '18:00',
  ];

  ClassItem? _findItem(
      int day,
      int slot,
      ) {
    for (final item in classItems) {
      if (item.day == day &&
          item.timeSlot == slot) {
        return item;
      }
    }

    return null;
  }

  DateTime _startOfWeek(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    return cleanDate.subtract(Duration(days: cleanDate.weekday - 1));
  }

  bool _isThisWeek(DateTime date) {
    final start = _startOfWeek(DateTime.now());
    final end = start.add(const Duration(days: 7));
    final taskDate = DateTime(date.year, date.month, date.day);
    return !taskDate.isBefore(start) && taskDate.isBefore(end);
  }

  int _closestTimeSlot(TimeOfDay time) {
    final taskMinutes = time.hour * 60 + time.minute;
    const slots = [9 * 60, 11 * 60, 14 * 60, 16 * 60, 18 * 60];

    var closestIndex = 0;
    var smallestDifference = (taskMinutes - slots.first).abs();

    for (var i = 1; i < slots.length; i++) {
      final difference = (taskMinutes - slots[i]).abs();
      if (difference < smallestDifference) {
        smallestDifference = difference;
        closestIndex = i;
      }
    }

    return closestIndex;
  }

  List<PlannerItem> _tasksForCell(int day, int slot) {
    return plannerItems.where((task) {
      final taskDay = task.date.weekday - 1;
      return _isThisWeek(task.date) &&
          taskDay == day &&
          _closestTimeSlot(task.time) == slot;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKLY TIMETABLE',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'This week',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius:
                  BorderRadius.circular(30),
                ),
                child: const Text(
                  '5 classes',
                  style: TextStyle(
                    color: iituRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 850,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 66,
                      ),
                      ...days.map(
                            (day) => Expanded(
                          child: Container(
                            height: 45,
                            alignment:
                            Alignment.center,
                            decoration:
                            const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: borderColor,
                                ),
                              ),
                            ),
                            child: Text(
                              day,
                              style:
                              const TextStyle(
                                color: greyText,
                                fontSize: 10.5,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  ...List.generate(
                    times.length,
                        (slot) {
                      return Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 66,
                            height: 132,
                            alignment:
                            Alignment.topCenter,
                            padding:
                            const EdgeInsets
                                .only(
                              top: 14,
                            ),
                            decoration:
                            const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: borderColor,
                                ),
                                bottom: BorderSide(
                                  color: borderColor,
                                ),
                              ),
                            ),
                            child: Text(
                              times[slot],
                              style:
                              const TextStyle(
                                color: greyText,
                                fontSize: 10,
                              ),
                            ),
                          ),

                          ...List.generate(
                            days.length,
                                (day) {
                              final item =
                              _findItem(
                                day,
                                slot,
                              );
                              final tasks = _tasksForCell(day, slot);

                              return Expanded(
                                child: Container(
                                  height: 132,
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: borderColor),
                                      bottom: BorderSide(color: borderColor),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      if (item != null)
                                        Expanded(
                                          child: ClassCard(item: item),
                                        )
                                      else if (tasks.isEmpty)
                                        const Expanded(child: SizedBox()),
                                      if (tasks.isNotEmpty) ...[
                                        if (item != null)
                                          const SizedBox(height: 5),
                                        PlannerTaskMiniCard(task: tasks.first),
                                        if (tasks.length > 1)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3),
                                            child: Text(
                                              '+${tasks.length - 1} more',
                                              style: const TextStyle(
                                                color: Color(0xFF4169A1),
                                                fontSize: 8,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final ClassItem item;

  const ClassCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: item.nextClass
            ? softRed
            : const Color(0xFFF3F4F7),
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: item.nextClass
              ? iituRed
              : borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          if (item.nextClass)
            const Text(
              'NEXT CLASS',
              style: TextStyle(
                color: iituRed,
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),

          if (item.nextClass)
            const SizedBox(height: 4),

          Text(
            item.module,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          Text(
            item.room,
            style: const TextStyle(
              color: greyText,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }
}

class PlannerTaskMiniCard extends StatelessWidget {
  final PlannerItem task;

  const PlannerTaskMiniCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    const taskBlue = Color(0xFF4169A1);
    const taskBackground = Color(0xFFEAF2FF);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: task.completed ? 0.5 : 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: taskBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: taskBlue.withOpacity(0.30)),
        ),
        child: Row(
          children: [
            Icon(
              task.completed
                  ? Icons.check_circle_rounded
                  : Icons.assignment_outlined,
              size: 13,
              color: taskBlue,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TASK',
                    style: TextStyle(
                      color: taskBlue,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              task.time.format(context),
              style: const TextStyle(
                color: taskBlue,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CALENDAR PANEL
// ============================================================

class CalendarPanel extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime>
  onDateSelected;

  const CalendarPanel({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final first =
    DateTime(
      selectedDate.year,
      selectedDate.month,
      1,
    );

    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;

    final offset = first.weekday % 7;

    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final totalCells = 42;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB71930),
            Color(0xFF8B1123),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${monthNames[selectedDate.month - 1]} ${selectedDate.year}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  final previous =
                  DateTime(
                    selectedDate.year,
                    selectedDate.month - 1,
                    1,
                  );

                  onDateSelected(previous);
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  final next =
                  DateTime(
                    selectedDate.year,
                    selectedDate.month + 1,
                    1,
                  );

                  onDateSelected(next);
                },
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Row(
            children: [
              CalendarDayLabel('Sun'),
              CalendarDayLabel('Mon'),
              CalendarDayLabel('Tue'),
              CalendarDayLabel('Wed'),
              CalendarDayLabel('Thu'),
              CalendarDayLabel('Fri'),
              CalendarDayLabel('Sat'),
            ],
          ),

          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: totalCells,
            itemBuilder: (
                context,
                index,
                ) {
              final day =
                  index - offset + 1;

              if (day < 1 ||
                  day > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(
                selectedDate.year,
                selectedDate.month,
                day,
              );

              final selected =
                  date.year ==
                      selectedDate.year &&
                      date.month ==
                          selectedDate.month &&
                      date.day ==
                          selectedDate.day;

              return InkWell(
                borderRadius:
                BorderRadius.circular(50),
                onTap: () {
                  onDateSelected(date);
                },
                child: Container(
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: selected
                          ? iituRed
                          : Colors.white,
                      fontSize: 10,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CalendarDayLabel extends StatelessWidget {
  final String text;

  const CalendarDayLabel(
      this.text, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class InputLikeBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const InputLikeBox({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: greyText,
            size: 17,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlannerItemCard extends StatelessWidget {
  final PlannerItem item;
  final VoidCallback onToggle;

  const PlannerItemCard({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.completed,
            activeColor: iituRed,
            onChanged: (_) => onToggle(),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    decoration: item.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.date.day}/${item.date.month}/${item.date.year} · ${item.time.format(context)}',
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SERVICES SCREEN
// ============================================================

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() =>
      _ServicesScreenState();
}

class _ServicesScreenState
    extends State<ServicesScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController(
    text: 'Amina Rahman',
  );

  final TextEditingController _idController =
  TextEditingController(
    text: 'S204198',
  );

  final TextEditingController _emailController =
  TextEditingController(
    text: 'amina.rahman@student.iitu.kz',
  );

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _subjectController =
  TextEditingController();

  final TextEditingController _detailsController =
  TextEditingController();

  final TextEditingController _otherController =
  TextEditingController();

  String? _category;
  String? _urgency;
  String? _contactMethod;
  DateTime? _preferredDate;
  bool _declaration = false;

  // Values populated by FormState.save() before the Firestore write.
  String _studentName = '';
  String _studentId = '';
  String _email = '';
  String _phone = '';
  String _subject = '';
  String _description = '';

  // Firebase submission state.
  bool _isSubmitting = false;
  String? _submissionPhase;
  String? _lastRequestId;
  Timer? _pendingSyncTimer;

  static const serviceCategories = [
    'Lost Student ID Card',
    'Wi-Fi / Internet',
    'Dormitory Issue',
    'Library Access',
    'Academic Documents',
    'Payment Question',
    'Student Account / Login',
    'Campus Facilities',
    'Security / Access',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _nameController.addListener(
      _refresh,
    );
    _idController.addListener(
      _refresh,
    );
    _emailController.addListener(
      _refresh,
    );
    _subjectController.addListener(
      _refresh,
    );
    _detailsController.addListener(
      _refresh,
    );
    _otherController.addListener(
      _refresh,
    );
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pendingSyncTimer?.cancel();
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _detailsController.dispose();
    _otherController.dispose();

    super.dispose();
  }

  double get _progress {
    int total = 10;
    int completed = 0;

    if (_nameController.text
        .trim()
        .isNotEmpty) {
      completed++;
    }

    if (_idController.text.trim().length >=
        5) {
      completed++;
    }

    if (_emailController.text
        .trim()
        .contains('@')) {
      completed++;
    }

    if (_category != null) {
      completed++;
    }

    if (_subjectController.text.trim().length >=
        5) {
      completed++;
    }

    if (_detailsController.text.trim().length >=
        20) {
      completed++;
    }

    if (_urgency != null) {
      completed++;
    }

    if (_contactMethod != null) {
      completed++;
    }

    if (_preferredDate != null) {
      completed++;
    }

    if (_declaration) {
      completed++;
    }

    if (_category == 'Other') {
      total++;

      if (_otherController.text.trim().length >=
          10) {
        completed++;
      }
    }

    return completed / total;
  }

  String _formatDate(
      DateTime? date,
      ) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _choosePreferredDate(
      FormFieldState<DateTime> field,
      ) async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: _preferredDate ?? now,
      firstDate: DateTime(
        now.year,
        now.month,
        now.day,
      ),
      lastDate: DateTime(
        now.year + 2,
      ),
    );

    if (result != null) {
      setState(() {
        _preferredDate = result;
      });

      field.didChange(result);
    }
  }

  Future<void> _openService(
      CampusService service,
      ) async {
    // Requirement: pass selected data to the details route.
    final result = await safePushNamed(
      context,
      AppRoutes.serviceDetail,
      arguments: service,
    );

    if (!mounted) {
      return;
    }

    // Requirement: the previous route receives a returned result.
    if (result == 'requested') {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${service.name} request recorded.',
          ),
          backgroundColor: successGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    // Prevent duplicate Firestore writes from repeated taps.
    if (_isSubmitting || _lastRequestId != null) {
      return;
    }

    final valid =
        _formKey.currentState?.validate() ??
            false;

    if (!valid) {
      return;
    }

    // save() runs the onSaved callbacks of the TextFormField widgets.
    _formKey.currentState!.save();

    if (_preferredDate == null ||
        !_declaration ||
        _category == null ||
        _urgency == null ||
        _contactMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete the date, choices and declaration.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submissionPhase = 'Saving...';
    });

    // If a network write takes longer, keep waiting for the same document
    // reference and show Pending sync instead of reporting false success.
    _pendingSyncTimer?.cancel();
    _pendingSyncTimer = Timer(
      const Duration(seconds: 4),
          () {
        if (mounted && _isSubmitting) {
          setState(() {
            _submissionPhase = 'Pending sync...';
          });
        }
      },
    );

    try {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser ??
          (await auth.signInAnonymously()).user;

      if (user == null) {
        throw StateError(
          'Anonymous sign-in was not completed.',
        );
      }

      final ref = FirebaseFirestore.instance
          .collection('campusRequests')
          .doc();

      var storedDescription = _description.trim();
      if (_category == 'Other' &&
          _otherController.text.trim().isNotEmpty) {
        storedDescription =
        'Other issue: ${_otherController.text.trim()}\n$storedDescription';
      }

      await ref.set({
        'ownerUid': user.uid,
        'studentName': _studentName.trim(),
        'studentId': _studentId.trim(),
        'email': _email.trim(),
        'phone': _phone.trim(),
        'serviceCategory': _category!,
        'subject': _subject.trim(),
        'description': storedDescription,
        'urgency': _urgency!,
        'preferredContact': _contactMethod!,
        'preferredDate':
        Timestamp.fromDate(_preferredDate!),
        'declaration': _declaration,
        'status': 'submitted',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _pendingSyncTimer?.cancel();

      if (!mounted) {
        return;
      }

      setState(() {
        _lastRequestId = ref.id;
        _submissionPhase = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Submitted. Reference: ${ref.id}',
          ),
          backgroundColor: successGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );

      await _showSubmissionSuccessDialog(ref.id);
    } on FirebaseException catch (error) {
      _pendingSyncTimer?.cancel();

      if (!mounted) {
        return;
      }

      final message =
      error.code == 'permission-denied'
          ? 'Access denied. Check sign-in and database rules.'
          : error.code == 'operation-not-allowed'
          ? 'Anonymous sign-in is not enabled in Firebase.'
          : 'Submission failed. Keep your inputs and try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      _pendingSyncTimer?.cancel();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to submit the request.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      _pendingSyncTimer?.cancel();

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _submissionPhase = null;
        });
      }
    }
  }

  Future<void> _showSubmissionSuccessDialog(
      String requestId,
      ) async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(27),
          ),
          title: const Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                Color(0xFFEAF7F0),
                child: Icon(
                  Icons.check_rounded,
                  color: successGreen,
                  size: 32,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Request submitted',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints:
            const BoxConstraints(maxWidth: 430),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:
                    const Color(0xFFEAF7F0),
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REQUEST REFERENCE',
                        style: TextStyle(
                          color: successGreen,
                          fontSize: 9.5,
                          fontWeight:
                          FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        requestId,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SummaryLine(
                  label: 'Issue',
                  value: _category ?? '-',
                ),
                SummaryLine(
                  label: 'Subject',
                  value: _subject,
                ),
                SummaryLine(
                  label: 'Urgency',
                  value: _urgency ?? '-',
                ),
                SummaryLine(
                  label: 'Contact',
                  value: _contactMethod ?? '-',
                ),
                SummaryLine(
                  label: 'Preferred date',
                  value:
                  _formatDate(_preferredDate),
                ),
                const SummaryLine(
                  label: 'Status',
                  value: 'submitted',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Done'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _loadAndShowRequest(requestId);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: iituRed,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(
                Icons.cloud_download_outlined,
                size: 17,
              ),
              label: const Text(
                'View Saved Request',
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatStoredDate(
      dynamic value,
      ) {
    if (value is Timestamp) {
      return _formatDate(value.toDate());
    }

    if (value is DateTime) {
      return _formatDate(value);
    }

    return '-';
  }

  Future<Map<String, dynamic>?> _loadRequest(
      String requestId,
      ) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser ??
        (await auth.signInAnonymously()).user;

    if (user == null) {
      throw StateError(
        'Anonymous sign-in was not completed.',
      );
    }

    final snapshot = await FirebaseFirestore
        .instance
        .collection('campusRequests')
        .doc(requestId)
        .get(
      const GetOptions(
        source: Source.server,
      ),
    );

    return snapshot.data();
  }

  Future<void> _loadAndShowRequest(
      String requestId,
      ) async {
    final cleanId = requestId.trim();

    if (cleanId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a request reference.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Loading saved request from Firestore...',
        ),
        duration: Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      final data = await _loadRequest(cleanId);

      if (!mounted) {
        return;
      }

      if (data == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'No request was found with this reference.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (
            dialogContext,
            ) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(27),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.cloud_done_outlined,
                  color: successGreen,
                ),
                SizedBox(width: 10),
                Text(
                  'Saved Request',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 430,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  SummaryLine(
                    label: 'Reference',
                    value: cleanId,
                  ),
                  SummaryLine(
                    label: 'Service',
                    value:
                    '${data['serviceCategory'] ?? '-'}',
                  ),
                  SummaryLine(
                    label: 'Subject',
                    value:
                    '${data['subject'] ?? '-'}',
                  ),
                  SummaryLine(
                    label: 'Status',
                    value:
                    '${data['status'] ?? '-'}',
                  ),
                  SummaryLine(
                    label: 'Preferred date',
                    value: _formatStoredDate(
                      data['preferredDate'],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                      const Color(0xFFEAF7F0),
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: successGreen,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Retrieved directly from the Firestore server.',
                            style: TextStyle(
                              color:
                              successGreen,
                              fontSize: 10.5,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } on FirebaseException catch (error) {
      if (!mounted) {
        return;
      }

      final message =
      error.code == 'permission-denied'
          ? 'This request cannot be read by the current anonymous user.'
          : 'Could not retrieve the saved request from the server.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not retrieve the saved request.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showRetrieveRequestDialog() async {
    final controller =
    TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (
          dialogContext,
          ) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(24),
          ),
          title: const Text(
            'Retrieve saved request',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration:
              const InputDecoration(
                labelText:
                'Request reference',
                hintText:
                'Paste the Firestore document ID',
                prefixIcon: Icon(
                  Icons.tag_rounded,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final requestId =
                controller.text.trim();

                Navigator.pop(
                  dialogContext,
                );

                if (requestId.isNotEmpty) {
                  _loadAndShowRequest(
                    requestId,
                  );
                }
              },
              style:
              ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: iituRed,
                foregroundColor:
                Colors.white,
              ),
              child: const Text('Retrieve'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    // Reset starts a new request but does not delete the saved Firestore document.
    _nameController.text =
    'Amina Rahman';
    _idController.text = 'S204198';
    _emailController.text =
    'amina.rahman@student.iitu.kz';

    _phoneController.clear();
    _subjectController.clear();
    _detailsController.clear();
    _otherController.clear();

    setState(() {
      _category = null;
      _urgency = null;
      _contactMethod = null;
      _preferredDate = null;
      _declaration = false;

      _studentName = '';
      _studentId = '';
      _email = '';
      _phone = '';
      _subject = '';
      _description = '';

      _lastRequestId = null;
      _submissionPhase = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress =
    (_progress * 100).round();

    return CampusScaffold(
      currentRoute: AppRoutes.services,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          55,
          24,
          90,
        ),
        child: MaxWidth(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'CAMPUS SERVICES',
                title: 'Support across IITU.',
                subtitle:
                'Choose a university service to view details or submit a student service request.',
              ),

              const SizedBox(height: 30),

              LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  double width;

                  if (constraints.maxWidth >=
                      900) {
                    width =
                        (constraints.maxWidth -
                            28) /
                            3;
                  } else if (constraints
                      .maxWidth >=
                      600) {
                    width =
                        (constraints.maxWidth -
                            14) /
                            2;
                  } else {
                    width =
                        constraints.maxWidth;
                  }

                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children:
                    campusServices.map(
                          (service) {
                        return SizedBox(
                          width: width,
                          child:
                          ServiceCard(
                            service:
                            service,
                            onTap: () {
                              _openService(
                                service,
                              );
                            },
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),

              const SizedBox(height: 85),

              const SectionHeading(
                eyebrow: 'SERVICE REQUEST',
                title: 'How can we help?',
                subtitle:
                'Submit a request and the appropriate IITU team can review your information.',
              ),

              const SizedBox(height: 28),

              AbsorbPointer(
                absorbing: _isSubmitting,
                child: Form(
                  key: _formKey,
                  autovalidateMode:
                  AutovalidateMode
                      .onUserInteraction,
                  child: Column(
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.all(
                          21,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            23,
                          ),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Request completion',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '$progress%',
                                  style:
                                  const TextStyle(
                                    color: iituRed,
                                    fontSize: 11,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TweenAnimationBuilder<
                                double>(
                              duration:
                              const Duration(
                                milliseconds: 320,
                              ),
                              tween: Tween(
                                begin: 0,
                                end: _progress,
                              ),
                              builder: (
                                  context,
                                  value,
                                  child,
                                  ) {
                                return ClipRRect(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                  child:
                                  LinearProgressIndicator(
                                    value: value,
                                    minHeight: 7,
                                    color: iituRed,
                                    backgroundColor:
                                    softGrey,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      FormSection(
                        number: '01',
                        title:
                        'Student details',
                        child:
                        _studentFields(),
                      ),

                      const SizedBox(height: 18),

                      FormSection(
                        number: '02',
                        title:
                        'Request details',
                        child:
                        _requestFields(),
                      ),

                      const SizedBox(height: 18),

                      FormSection(
                        number: '03',
                        title:
                        'Preferences',
                        child:
                        _preferenceFields(),
                      ),

                      const SizedBox(height: 18),

                      FormSection(
                        number: '04',
                        title:
                        'Confirmation',
                        child: Column(
                          children: [
                            FormField<bool>(
                              initialValue:
                              false,
                              validator:
                                  (value) {
                                if (value !=
                                    true) {
                                  return 'Please confirm the information.';
                                }

                                return null;
                              },
                              builder:
                                  (field) {
                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    CheckboxListTile(
                                      value:
                                      _declaration,
                                      activeColor:
                                      iituRed,
                                      contentPadding:
                                      EdgeInsets
                                          .zero,
                                      controlAffinity:
                                      ListTileControlAffinity
                                          .leading,
                                      title:
                                      const Text(
                                        'I confirm that the information above is correct.',
                                        style:
                                        TextStyle(
                                          fontSize:
                                          12,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                        ),
                                      ),
                                      onChanged:
                                          (value) {
                                        final selected =
                                            value ??
                                                false;

                                        setState(
                                                () {
                                              _declaration =
                                                  selected;
                                            });

                                        field
                                            .didChange(
                                          selected,
                                        );
                                      },
                                    ),

                                    if (field
                                        .hasError)
                                      Text(
                                        field
                                            .errorText!,
                                        style:
                                        const TextStyle(
                                          color:
                                          iituRed,
                                          fontSize:
                                          10.5,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      Wrap(
                        spacing: 11,
                        runSpacing: 11,
                        crossAxisAlignment:
                        WrapCrossAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                            _isSubmitting ||
                                _lastRequestId !=
                                    null
                                ? null
                                : _submitForm,
                            style:
                            ElevatedButton
                                .styleFrom(
                              elevation: 0,
                              backgroundColor:
                              iituRed,
                              foregroundColor:
                              Colors.white,
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 22,
                                vertical: 16,
                              ),
                            ),
                            icon: _isSubmitting
                                ? const SizedBox(
                              width: 17,
                              height: 17,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                Colors.white,
                              ),
                            )
                                : const Icon(
                              Icons.send_rounded,
                              size: 17,
                            ),
                            label: Text(
                              _isSubmitting
                                  ? (_submissionPhase ??
                                  'Saving...')
                                  : _lastRequestId !=
                                  null
                                  ? 'Submitted'
                                  : 'Submit Request',
                            ),
                          ),

                          OutlinedButton.icon(
                            onPressed:
                            _isSubmitting
                                ? null
                                : _resetForm,
                            style:
                            OutlinedButton
                                .styleFrom(
                              foregroundColor:
                              darkText,
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal: 22,
                                vertical: 16,
                              ),
                            ),
                            icon: const Icon(
                              Icons
                                  .refresh_rounded,
                              size: 17,
                            ),
                            label: const Text(
                              'Reset',
                            ),
                          ),

                          TextButton.icon(
                            onPressed:
                            _isSubmitting
                                ? null
                                : _showRetrieveRequestDialog,
                            icon: const Icon(
                              Icons
                                  .cloud_download_outlined,
                              size: 18,
                            ),
                            label: const Text(
                              'Retrieve request',
                            ),
                          ),
                        ],
                      ),

                      if (_lastRequestId != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                            const Color(0xFFEAF7F0),
                            borderRadius:
                            BorderRadius.circular(
                              18,
                            ),
                            border: Border.all(
                              color: successGreen
                                  .withOpacity(0.16),
                            ),
                          ),
                          child: Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            crossAxisAlignment:
                            WrapCrossAlignment.center,
                            children: [
                              const Icon(
                                Icons
                                    .verified_rounded,
                                color: successGreen,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  const Text(
                                    'SERVER-CONFIRMED REQUEST',
                                    style:
                                    TextStyle(
                                      color:
                                      successGreen,
                                      fontSize:
                                      9.5,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                      letterSpacing:
                                      0.7,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SelectableText(
                                    _lastRequestId!,
                                    style:
                                    const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight
                                          .w600,
                                    ),
                                  ),
                                ],
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  _loadAndShowRequest(
                                    _lastRequestId!,
                                  );
                                },
                                icon: const Icon(
                                  Icons
                                      .cloud_done_outlined,
                                  size: 17,
                                ),
                                label: const Text(
                                  'View Saved Request',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentFields() {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final desktop =
            constraints.maxWidth >= 700;

        final width = desktop
            ? (constraints.maxWidth - 14) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: width,
              child: TextFormField(
                controller: _nameController,
                textInputAction:
                TextInputAction.next,
                decoration:
                const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(
                    Icons.person_outline,
                  ),
                ),
                onSaved: (value) {
                  _studentName =
                      value?.trim() ?? '';
                },
                validator: (value) {
                  final text =
                      value?.trim() ?? '';

                  if (text.isEmpty) {
                    return 'Please enter your full name.';
                  }

                  if (text.length < 3 ||
                      text.length > 100) {
                    return 'Name must be 3 to 100 characters.';
                  }

                  if (!text.contains(' ')) {
                    return 'Please enter at least two names.';
                  }

                  return null;
                },
              ),
            ),

            SizedBox(
              width: width,
              child: TextFormField(
                controller: _idController,
                textInputAction:
                TextInputAction.next,
                decoration:
                const InputDecoration(
                  labelText: 'Student ID',
                  prefixIcon: Icon(
                    Icons.badge_outlined,
                  ),
                ),
                onSaved: (value) {
                  _studentId =
                      value?.trim() ?? '';
                },
                validator: (value) {
                  final id =
                      value?.trim() ?? '';

                  if (id.length < 5) {
                    return 'Student ID must have at least 5 characters.';
                  }

                  if (id.length > 30) {
                    return 'Student ID must be at most 30 characters.';
                  }

                  return null;
                },
              ),
            ),

            SizedBox(
              width: width,
              child: TextFormField(
                controller:
                _emailController,
                keyboardType:
                TextInputType
                    .emailAddress,
                textInputAction:
                TextInputAction.next,
                decoration:
                const InputDecoration(
                  labelText:
                  'Campus email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
                onSaved: (value) {
                  _email =
                      value?.trim() ?? '';
                },
                validator: (value) {
                  final email =
                      value?.trim() ?? '';

                  if (email.isEmpty) {
                    return 'Please enter your campus email.';
                  }

                  if (email.length > 150) {
                    return 'Email must be at most 150 characters.';
                  }

                  final emailPattern = RegExp(
                    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                  );

                  if (!emailPattern.hasMatch(email)) {
                    return 'Enter a valid email address.';
                  }

                  return null;
                },
              ),
            ),

            SizedBox(
              width: width,
              child: TextFormField(
                controller:
                _phoneController,
                keyboardType:
                TextInputType.phone,
                decoration:
                const InputDecoration(
                  labelText:
                  'Phone number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                  ),
                ),
                onSaved: (value) {
                  _phone =
                      value?.trim() ?? '';
                },
                validator: (value) {
                  final phone =
                      value?.trim() ?? '';

                  if (phone.isEmpty) {
                    if (_contactMethod ==
                        'Phone') {
                      return 'Phone number is required when Phone is selected.';
                    }

                    return null;
                  }

                  if (phone.length > 25) {
                    return 'Phone number is too long.';
                  }

                  final allowed =
                  RegExp(r'^\+?[0-9 ()-]+$');

                  if (!allowed.hasMatch(phone)) {
                    return 'Use digits and an optional leading + sign.';
                  }

                  final digits = phone
                      .replaceAll(
                    RegExp(r'\D'),
                    '',
                  );

                  if (digits.length < 7 ||
                      digits.length > 15) {
                    return 'Enter 7 to 15 phone digits.';
                  }

                  return null;
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _requestFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _category,
          isExpanded: true,
          decoration:
          const InputDecoration(
            labelText:
            'Service category',
            prefixIcon: Icon(
              Icons
                  .support_agent_outlined,
            ),
          ),
          items: serviceCategories
              .map(
                (item) =>
                DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
          )
              .toList(),
          onChanged: (value) {
            setState(() {
              _category = value;

              if (value != 'Other') {
                _otherController.clear();
              }
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a category.';
            }

            return null;
          },
        ),

        AnimatedSwitcher(
          duration:
          const Duration(milliseconds: 250),
          child: _category == 'Other'
              ? Padding(
            key: const ValueKey(
              'other',
            ),
            padding:
            const EdgeInsets.only(
              top: 14,
            ),
            child: TextFormField(
              controller:
              _otherController,
              maxLength: 180,
              maxLines: 3,
              decoration:
              const InputDecoration(
                labelText:
                'Describe the other issue',
              ),
              validator: (value) {
                if (_category !=
                    'Other') {
                  return null;
                }

                if ((value
                    ?.trim()
                    .length ??
                    0) <
                    10) {
                  return 'Please describe the issue.';
                }

                return null;
              },
            ),
          )
              : const SizedBox.shrink(
            key: ValueKey(
              'no-other',
            ),
          ),
        ),

        const SizedBox(height: 14),

        TextFormField(
          controller:
          _subjectController,
          decoration:
          const InputDecoration(
            labelText:
            'Request subject',
            prefixIcon: Icon(
              Icons.short_text,
            ),
          ),
          maxLength: 100,
          onSaved: (value) {
            _subject =
                value?.trim() ?? '';
          },
          validator: (value) {
            final subject =
                value?.trim() ?? '';

            if (subject.length < 5) {
              return 'Use at least 5 characters.';
            }

            if (subject.length > 100) {
              return 'Subject must be at most 100 characters.';
            }

            return null;
          },
        ),

        const SizedBox(height: 14),

        TextFormField(
          controller:
          _detailsController,
          maxLines: 5,
          maxLength: 300,
          decoration:
          const InputDecoration(
            labelText:
            'Request details',
            alignLabelWithHint: true,
          ),
          onSaved: (value) {
            _description =
                value?.trim() ?? '';
          },
          validator: (value) {
            final description =
                value?.trim() ?? '';

            if (description.length < 20) {
              return 'Please provide at least 20 characters.';
            }

            if (description.length > 500) {
              return 'Request details must be at most 500 characters.';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _preferenceFields() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const Text(
          'Urgency',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            ChoicePill(
              label: 'Low',
              selected:
              _urgency == 'Low',
              onTap: () {
                setState(() {
                  _urgency = 'Low';
                });
              },
            ),
            ChoicePill(
              label: 'Normal',
              selected:
              _urgency == 'Normal',
              onTap: () {
                setState(() {
                  _urgency = 'Normal';
                });
              },
            ),
            ChoicePill(
              label: 'High',
              selected:
              _urgency == 'High',
              onTap: () {
                setState(() {
                  _urgency = 'High';
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 22),

        const Text(
          'Preferred contact',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            ChoicePill(
              label: 'Email',
              selected:
              _contactMethod ==
                  'Email',
              onTap: () {
                setState(() {
                  _contactMethod =
                  'Email';
                });
              },
            ),
            ChoicePill(
              label: 'Phone',
              selected:
              _contactMethod ==
                  'Phone',
              onTap: () {
                setState(() {
                  _contactMethod =
                  'Phone';
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 22),

        FormField<String>(
          validator: (_) {
            if (_urgency == null) {
              return 'Please select urgency.';
            }

            if (_contactMethod == null) {
              return 'Please select a contact method.';
            }

            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                if (field.hasError)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Text(
                      field.errorText!,
                      style:
                      const TextStyle(
                        color: iituRed,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        FormField<DateTime>(
          validator: (value) {
            if (_preferredDate == null) {
              return 'Please choose a preferred response date.';
            }

            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius:
                  BorderRadius.circular(
                    17,
                  ),
                  onTap: () {
                    _choosePreferredDate(
                      field,
                    );
                  },
                  child: InputLikeBox(
                    icon: Icons
                        .calendar_month_outlined,
                    text: _formatDate(
                      _preferredDate,
                    ),
                  ),
                ),

                if (field.hasError)
                  Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      field.errorText!,
                      style:
                      const TextStyle(
                        color: iituRed,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ============================================================
// SERVICE DETAILS
// ============================================================

class ServiceDetailScreen
    extends StatelessWidget {
  final CampusService service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          service.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            55,
            24,
            80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 850,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.all(
                      30,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(
                        30,
                      ),
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          alignment:
                          Alignment.center,
                          decoration:
                          BoxDecoration(
                            color: service.color.withOpacity(0.12),
                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                          ),
                          child: Icon(
                            service.icon,
                            color: service.color,
                            size: 30,
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          service.name,
                          style: const TextStyle(
                            fontSize: 31,
                            fontWeight:
                            FontWeight.w600,
                            letterSpacing: -1,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          service.description,
                          style:
                          const TextStyle(
                            color: greyText,
                            fontSize: 13,
                            height: 1.65,
                          ),
                        ),

                        const SizedBox(height: 30),

                        DetailInformationRow(
                          icon: Icons
                              .location_on_outlined,
                          label: 'Location',
                          value:
                          service.location,
                        ),

                        DetailInformationRow(
                          icon:
                          Icons.access_time,
                          label:
                          'Opening hours',
                          value: service
                              .openingHours,
                        ),

                        DetailInformationRow(
                          icon:
                          Icons.email_outlined,
                          label: 'Contact',
                          value:
                          service.contact,
                        ),

                        DetailInformationRow(
                          icon: Icons
                              .check_circle_outline,
                          label: 'Status',
                          value:
                          service.status,
                        ),

                        const SizedBox(height: 28),

                        SizedBox(
                          width: double.infinity,
                          child:
                          ElevatedButton.icon(
                            // Requirement:
                            // pop() returns a result
                            // to the previous Services route.
                            onPressed: () {
                              Navigator.pop(
                                context,
                                'requested',
                              );
                            },
                            style:
                            ElevatedButton
                                .styleFrom(
                              elevation: 0,
                              backgroundColor:
                              iituRed,
                              foregroundColor:
                              Colors.white,
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                vertical: 16,
                              ),
                            ),
                            icon: const Icon(
                              Icons
                                  .support_agent_outlined,
                            ),
                            label: const Text(
                              'Request Support',
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child:
                          OutlinedButton(
                            // Requirement:
                            // pop() reveals the
                            // existing previous route.
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            child: const Text(
                              'Return to Services',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EVENTS SCREEN
// ============================================================

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  void _openEvent(
      BuildContext context,
      CampusEvent event,
      ) {
    // Requirement: at least one route is opened
    // directly with Navigator.push + MaterialPageRoute.
    safePush(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EventDetailScreen(
              event: event,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CampusScaffold(
      currentRoute: AppRoutes.events,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          55,
          24,
          90,
        ),
        child: MaxWidth(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'WHAT’S HAPPENING',
                title: 'Upcoming Events',
                subtitle:
                'Discover academic, career and student opportunities at IITU.',
              ),

              const SizedBox(height: 30),

              LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  double width;

                  if (constraints.maxWidth >=
                      900) {
                    width =
                        (constraints.maxWidth -
                            28) /
                            3;
                  } else if (constraints
                      .maxWidth >=
                      600) {
                    width =
                        (constraints.maxWidth -
                            14) /
                            2;
                  } else {
                    width =
                        constraints.maxWidth;
                  }

                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children:
                    campusEvents.map(
                          (event) {
                        return SizedBox(
                          width: width,
                          child:
                          EventFullCard(
                            event: event,
                            onTap: () {
                              _openEvent(
                                context,
                                event,
                              );
                            },
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EVENT DETAIL SCREEN
// ============================================================

class EventDetailScreen extends StatefulWidget {
  final CampusEvent event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailScreen> createState() =>
      _EventDetailScreenState();
}

class _EventDetailScreenState
    extends State<EventDetailScreen> {
  bool registered = false;

  Future<void> _register() async {
    final result =
    await showDialog<bool>(
      context: context,
      builder: (
          context,
          ) {
        return const EventRegistrationDialog();
      },
    );

    if (result == true && mounted) {
      setState(() {
        registered = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Event registration completed.',
          ),
          backgroundColor: successGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Event Details',
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            35,
            24,
            80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 1000,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // Extension feature:
                  // Hero animation from event list to details.
                  Hero(
                    tag:
                    'event-${widget.event.title}',
                    child: Container(
                      height: 410,
                      width: double.infinity,
                      clipBehavior:
                      Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppAssetImage(
                            path:
                            widget.event.image,
                          ),

                          Container(
                            decoration:
                            BoxDecoration(
                              gradient:
                              LinearGradient(
                                begin: Alignment
                                    .topCenter,
                                end: Alignment
                                    .bottomCenter,
                                colors: [
                                  Colors
                                      .transparent,
                                  Colors.black
                                      .withOpacity(
                                    0.72,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            left: 30,
                            right: 30,
                            bottom: 30,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  widget.event
                                      .category
                                      .toUpperCase(),
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white70,
                                    fontSize: 9,
                                    letterSpacing:
                                    1.3,
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  widget
                                      .event.title,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize: 34,
                                    height: 1.05,
                                    fontWeight:
                                    FontWeight
                                        .w600,
                                    letterSpacing:
                                    -1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      InfoChip(
                        icon: Icons
                            .calendar_month_outlined,
                        text:
                        widget.event.date,
                      ),
                      InfoChip(
                        icon: Icons
                            .access_time_outlined,
                        text:
                        widget.event.time,
                      ),
                      InfoChip(
                        icon: Icons
                            .location_on_outlined,
                        text:
                        widget.event.venue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  LayoutBuilder(
                    builder: (
                        context,
                        constraints,
                        ) {
                      final desktop =
                          constraints.maxWidth >=
                              750;

                      final main = Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About the event',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            widget.event
                                .description,
                            style:
                            const TextStyle(
                              color: greyText,
                              fontSize: 13,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          const Text(
                            'What to expect',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          ...widget
                              .event.expectations
                              .map(
                                (item) {
                              return Padding(
                                padding:
                                const EdgeInsets
                                    .only(
                                  bottom: 11,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .check_circle_outline,
                                      color:
                                      iituRed,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 9,
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );

                      final registration =
                      Container(
                        padding:
                        const EdgeInsets.all(
                          23,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            24,
                          ),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Join this event',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            const Text(
                              'Register with your student details.',
                              style: TextStyle(
                                color:
                                greyText,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              width:
                              double.infinity,
                              child:
                              ElevatedButton.icon(
                                onPressed:
                                registered
                                    ? null
                                    : _register,
                                style:
                                ElevatedButton
                                    .styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                  iituRed,
                                  foregroundColor:
                                  Colors.white,
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                icon: Icon(
                                  registered
                                      ? Icons
                                      .check_circle
                                      : Icons
                                      .how_to_reg_outlined,
                                ),
                                label: Text(
                                  registered
                                      ? 'Registered'
                                      : 'Register for Event',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (!desktop) {
                        return Column(
                          children: [
                            main,
                            const SizedBox(
                              height: 25,
                            ),
                            registration,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: main,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            width: 290,
                            child:
                            registration,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EVENT REGISTRATION
// ============================================================

class EventRegistrationDialog
    extends StatefulWidget {
  const EventRegistrationDialog({
    super.key,
  });

  @override
  State<EventRegistrationDialog> createState() =>
      _EventRegistrationDialogState();
}

class _EventRegistrationDialogState
    extends State<EventRegistrationDialog> {
  final GlobalKey<FormState> key =
  GlobalKey<FormState>();

  final nameController =
  TextEditingController(
    text: 'Akvarzhanova Irada',
  );

  final idController =
  TextEditingController(
    text: '41151',
  );

  final emailController =
  TextEditingController(
    text: 'irada41151@student.iitu.kz',
  );

  bool confirmed = false;

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    emailController.dispose();

    super.dispose();
  }

  void submit() {
    if (!(key.currentState?.validate() ??
        false)) {
      return;
    }

    if (!confirmed) {
      setState(() {});
      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(27),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(27),
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'EVENT REGISTRATION',
                  style: TextStyle(
                    color: iituRed,
                    fontSize: 9,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Register for this event',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller:
                  nameController,
                  decoration:
                  const InputDecoration(
                    labelText: 'Full name',
                  ),
                  validator: (value) {
                    if ((value
                        ?.trim()
                        .length ??
                        0) <
                        3) {
                      return 'Enter your full name.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 13),

                TextFormField(
                  controller:
                  idController,
                  decoration:
                  const InputDecoration(
                    labelText: 'Student ID',
                  ),
                  validator: (value) {
                    if ((value
                        ?.trim()
                        .length ??
                        0) <
                        5) {
                      return 'Enter a valid Student ID.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 13),

                TextFormField(
                  controller:
                  emailController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    'Campus email',
                  ),
                  validator: (value) {
                    if (!(value ?? '')
                        .contains('@')) {
                      return 'Enter a valid email.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 13),

                CheckboxListTile(
                  value: confirmed,
                  activeColor: iituRed,
                  contentPadding:
                  EdgeInsets.zero,
                  controlAffinity:
                  ListTileControlAffinity
                      .leading,
                  title: const Text(
                    'I confirm my registration.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmed =
                          value ?? false;
                    });
                  },
                ),

                if (!confirmed)
                  const Text(
                    'Please confirm your registration.',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 10,
                    ),
                  ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: submit,
                        style:
                        ElevatedButton
                            .styleFrom(
                          elevation: 0,
                          backgroundColor:
                          iituRed,
                          foregroundColor:
                          Colors.white,
                        ),
                        child:
                        const Text(
                          'Register',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CAMPUS - INTERACTIVE MAP
// ============================================================

class CampusPlace {
  final String name;
  final String description;
  final IconData icon;
  final double x;
  final double y;

  const CampusPlace({
    required this.name,
    required this.description,
    required this.icon,
    required this.x,
    required this.y,
  });
}

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  int selectedFloor = 1;
  CampusPlace? selectedPlace;

  final Map<int, List<CampusPlace>> floorPlaces = const {
    1: [
      CampusPlace(
        name: 'Main Entrance',
        description: 'Main entrance and reception area.',
        icon: Icons.door_front_door_outlined,
        x: 0.14,
        y: 0.76,
      ),
      CampusPlace(
        name: 'Cafeteria',
        description: 'Food, drinks and a comfortable student area.',
        icon: Icons.restaurant_outlined,
        x: 0.72,
        y: 0.68,
      ),
      CampusPlace(
        name: 'Student Services',
        description: 'Student documents, support and general assistance.',
        icon: Icons.support_agent_outlined,
        x: 0.67,
        y: 0.23,
      ),
      CampusPlace(
        name: 'Event Hall',
        description: 'University events, meetings and presentations.',
        icon: Icons.groups_outlined,
        x: 0.22,
        y: 0.26,
      ),
    ],

    2: [
      CampusPlace(
        name: 'Computer Lab',
        description: 'Computer laboratory for practical classes.',
        icon: Icons.computer_outlined,
        x: 0.18,
        y: 0.25,
      ),
      CampusPlace(
        name: 'Classrooms',
        description: 'Teaching rooms for lectures and seminars.',
        icon: Icons.school_outlined,
        x: 0.72,
        y: 0.25,
      ),
      CampusPlace(
        name: 'Study Area',
        description: 'Open student space for individual and group study.',
        icon: Icons.menu_book_outlined,
        x: 0.20,
        y: 0.70,
      ),
      CampusPlace(
        name: 'Meeting Room',
        description: 'Space for teamwork and student meetings.',
        icon: Icons.meeting_room_outlined,
        x: 0.72,
        y: 0.70,
      ),
    ],

    3: [
      CampusPlace(
        name: 'Library',
        description: 'Books, academic resources and quiet study spaces.',
        icon: Icons.local_library_outlined,
        x: 0.20,
        y: 0.24,
      ),
      CampusPlace(
        name: 'Reading Zone',
        description: 'Quiet area for reading and individual work.',
        icon: Icons.auto_stories_outlined,
        x: 0.70,
        y: 0.24,
      ),
      CampusPlace(
        name: 'Discussion Rooms',
        description: 'Rooms for group discussions and project work.',
        icon: Icons.forum_outlined,
        x: 0.20,
        y: 0.70,
      ),
      CampusPlace(
        name: 'Media Room',
        description: 'Multimedia and digital learning area.',
        icon: Icons.video_library_outlined,
        x: 0.70,
        y: 0.70,
      ),
    ],

    4: [
      CampusPlace(
        name: 'Research Labs',
        description: 'Laboratories for university research projects.',
        icon: Icons.science_outlined,
        x: 0.18,
        y: 0.25,
      ),
      CampusPlace(
        name: 'Innovation Hub',
        description: 'Space for startups, innovation and new ideas.',
        icon: Icons.lightbulb_outline,
        x: 0.72,
        y: 0.25,
      ),
      CampusPlace(
        name: 'Project Rooms',
        description: 'Team rooms for student projects.',
        icon: Icons.workspaces_outline,
        x: 0.18,
        y: 0.70,
      ),
      CampusPlace(
        name: 'Faculty Space',
        description: 'Academic staff collaboration area.',
        icon: Icons.people_outline,
        x: 0.72,
        y: 0.70,
      ),
    ],

    5: [
      CampusPlace(
        name: 'Faculty Offices',
        description: 'University faculty and lecturer offices.',
        icon: Icons.business_outlined,
        x: 0.18,
        y: 0.25,
      ),
      CampusPlace(
        name: 'Conference Room',
        description: 'Meetings, conferences and presentations.',
        icon: Icons.co_present_outlined,
        x: 0.72,
        y: 0.25,
      ),
      CampusPlace(
        name: 'Quiet Study Space',
        description: 'Quiet area for focused academic work.',
        icon: Icons.headphones_outlined,
        x: 0.18,
        y: 0.70,
      ),
      CampusPlace(
        name: 'Administration',
        description: 'University administration offices.',
        icon: Icons.account_balance_outlined,
        x: 0.72,
        y: 0.70,
      ),
    ],
  };

  List<CampusPlace> get currentPlaces =>
      floorPlaces[selectedFloor] ?? [];

  void selectFloor(int floor) {
    setState(() {
      selectedFloor = floor;
      selectedPlace = null;
    });
  }

  void selectPlace(CampusPlace place) {
    setState(() {
      selectedPlace = place;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CampusScaffold(
      currentRoute: AppRoutes.campus,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          55,
          24,
          90,
        ),
        child: MaxWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'CAMPUS NAVIGATOR',
                title: 'Find your way around IITU.',
                subtitle:
                'Choose a floor and select a location on the interactive campus map.',
              ),

              const SizedBox(height: 30),

              // FLOOR BUTTONS
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: List.generate(
                    5,
                        (index) {
                      final floor = index + 1;
                      final selected = selectedFloor == floor;

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => selectFloor(floor),
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 200,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color:
                            selected ? iituRed : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            'Level $floor',
                            style: TextStyle(
                              color:
                              selected ? Colors.white : greyText,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth >= 850;

                  final map = CampusInteractiveMap(
                    floor: selectedFloor,
                    places: currentPlaces,
                    selectedPlace: selectedPlace,
                    onPlaceSelected: selectPlace,
                  );

                  final info = CampusMapSidePanel(
                    floor: selectedFloor,
                    places: currentPlaces,
                    selectedPlace: selectedPlace,
                    onPlaceSelected: selectPlace,
                  );

                  if (!desktop) {
                    return Column(
                      children: [
                        map,
                        const SizedBox(height: 18),
                        info,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: map,
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 310,
                        child: info,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 85),

              const CampusLifeSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// INTERACTIVE FLOOR MAP
// ============================================================

class CampusInteractiveMap extends StatelessWidget {
  final int floor;
  final List<CampusPlace> places;
  final CampusPlace? selectedPlace;
  final ValueChanged<CampusPlace> onPlaceSelected;

  const CampusInteractiveMap({
    super.key,
    required this.floor,
    required this.places,
    required this.selectedPlace,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 590,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INTERACTIVE MAP',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Level $floor',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.touch_app_outlined,
                      color: iituRed,
                      size: 15,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Select a place',
                      style: TextStyle(
                        color: iituRed,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mapWidth = constraints.maxWidth;
                final mapHeight = constraints.maxHeight;

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F3F1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFFE0DFDC),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // FLOOR PLAN BACKGROUND
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CampusFloorPainter(),
                        ),
                      ),

                      // YOU ARE HERE
                      Positioned(
                        left: 18,
                        bottom: 17,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.my_location,
                                color: iituRed,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'You are here',
                                style: TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // PLACES
                      ...places.map(
                            (place) {
                          final selected =
                              selectedPlace?.name == place.name;

                          final left =
                              (mapWidth - 120) * place.x;
                          final top =
                              (mapHeight - 75) * place.y;

                          return AnimatedPositioned(
                            duration: const Duration(
                              milliseconds: 350,
                            ),
                            curve: Curves.easeOutCubic,
                            left: left,
                            top: top,
                            child: CampusMapMarker(
                              place: place,
                              selected: selected,
                              onTap: () {
                                onPlaceSelected(place);
                              },
                            ),
                          );
                        },
                      ),

                      // ANIMATED STUDENT MARKER
                      AnimatedPositioned(
                        duration: const Duration(
                          milliseconds: 650,
                        ),
                        curve: Curves.easeInOutCubic,
                        left: selectedPlace == null
                            ? mapWidth * 0.43
                            : (mapWidth - 45) *
                            selectedPlace!.x,
                        top: selectedPlace == null
                            ? mapHeight * 0.43
                            : (mapHeight - 45) *
                            selectedPlace!.y +
                            43,
                        child: const StudentMapMarker(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MAP BACKGROUND DRAWING
// ============================================================

class CampusFloorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wallPaint = Paint()
      ..color = const Color(0xFFD3D1CC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final corridorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final roomPaint = Paint()
      ..color = const Color(0xFFE8E7E3)
      ..style = PaintingStyle.fill;

    final roomBorder = Paint()
      ..color = const Color(0xFFD6D4CF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.05,
        size.height * 0.08,
        size.width * 0.90,
        size.height * 0.80,
      ),
      const Radius.circular(22),
    );

    canvas.drawRRect(
      outer,
      corridorPaint,
    );

    canvas.drawRRect(
      outer,
      wallPaint,
    );

    final rooms = [
      Rect.fromLTWH(
        size.width * 0.09,
        size.height * 0.13,
        size.width * 0.28,
        size.height * 0.24,
      ),
      Rect.fromLTWH(
        size.width * 0.63,
        size.height * 0.13,
        size.width * 0.28,
        size.height * 0.24,
      ),
      Rect.fromLTWH(
        size.width * 0.09,
        size.height * 0.59,
        size.width * 0.28,
        size.height * 0.23,
      ),
      Rect.fromLTWH(
        size.width * 0.63,
        size.height * 0.59,
        size.width * 0.28,
        size.height * 0.23,
      ),
    ];

    for (final room in rooms) {
      final rrect =
      RRect.fromRectAndRadius(
        room,
        const Radius.circular(15),
      );

      canvas.drawRRect(
        rrect,
        roomPaint,
      );

      canvas.drawRRect(
        rrect,
        roomBorder,
      );
    }

    // central horizontal corridor
    canvas.drawLine(
      Offset(
        size.width * 0.10,
        size.height * 0.48,
      ),
      Offset(
        size.width * 0.90,
        size.height * 0.48,
      ),
      wallPaint,
    );

    // central vertical corridor
    canvas.drawLine(
      Offset(
        size.width * 0.50,
        size.height * 0.10,
      ),
      Offset(
        size.width * 0.50,
        size.height * 0.84,
      ),
      wallPaint,
    );

    // little entrance opening
    canvas.drawLine(
      Offset(
        size.width * 0.43,
        size.height * 0.88,
      ),
      Offset(
        size.width * 0.57,
        size.height * 0.88,
      ),
      Paint()
        ..color = const Color(0xFFF4F3F1)
        ..strokeWidth = 5,
    );
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}

// ============================================================
// MAP MARKER
// ============================================================

class CampusMapMarker extends StatefulWidget {
  final CampusPlace place;
  final bool selected;
  final VoidCallback onTap;

  const CampusMapMarker({
    super.key,
    required this.place,
    required this.selected,
    required this.onTap,
  });

  @override
  State<CampusMapMarker> createState() =>
      _CampusMapMarkerState();
}

class _CampusMapMarkerState
    extends State<CampusMapMarker> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final active = hover || widget.selected;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          width: 115,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: active ? iituRed : Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color:
              active ? iituRed : borderColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  active ? 0.10 : 0.045,
                ),
                blurRadius: active ? 18 : 9,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                widget.place.icon,
                color:
                active ? Colors.white : iituRed,
                size: 16,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  widget.place.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active
                        ? Colors.white
                        : darkText,
                    fontSize: 8.5,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STUDENT MARKER
// ============================================================

class StudentMapMarker extends StatefulWidget {
  const StudentMapMarker({
    super.key,
  });

  @override
  State<StudentMapMarker> createState() =>
      _StudentMapMarkerState();
}

class _StudentMapMarkerState
    extends State<StudentMapMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    )..repeat(
      reverse: true,
    );

    animation = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            animation.value,
          ),
          child: child,
        );
      },
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: iituRed,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: iituRed.withOpacity(0.25),
              blurRadius: 18,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }
}

// ============================================================
// CAMPUS SIDE PANEL
// ============================================================

class CampusMapSidePanel extends StatelessWidget {
  final int floor;
  final List<CampusPlace> places;
  final CampusPlace? selectedPlace;
  final ValueChanged<CampusPlace> onPlaceSelected;

  const CampusMapSidePanel({
    super.key,
    required this.floor,
    required this.places,
    required this.selectedPlace,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEVEL $floor',
            style: const TextStyle(
              color: iituRed,
              fontSize: 9,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Places',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Select a location to see it on the map.',
            style: TextStyle(
              color: greyText,
              fontSize: 10.5,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 19),

          ...places.map(
                (place) {
              final selected =
                  selectedPlace?.name == place.name;

              return InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  onPlaceSelected(place);
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 9,
                  ),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color:
                    selected ? softRed : softGrey,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: selected
                          ? iituRed
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 37,
                        height: 37,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: Icon(
                          place.icon,
                          color: iituRed,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          place.name,
                          style: TextStyle(
                            color: selected
                                ? iituRed
                                : darkText,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: greyText,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          if (selectedPlace != null) ...[
            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iituDarkRed,
                    iituRed,
                  ],
                ),
                borderRadius: BorderRadius.circular(21),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    selectedPlace!.icon,
                    color: Colors.white,
                    size: 24,
                  ),

                  const SizedBox(height: 13),

                  Text(
                    selectedPlace!.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    selectedPlace!.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 9.5,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.layers_outlined,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Level $floor',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE
// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CampusScaffold(
      currentRoute: AppRoutes.profile,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          24,
          55,
          24,
          90,
        ),
        child: MaxWidth(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                eyebrow: 'STUDENT PROFILE',
                title: 'Your academic space.',
                subtitle:
                'Personal information, progress and academic records in one place.',
              ),

              const SizedBox(height: 30),

              LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  final desktop =
                      constraints.maxWidth >= 850;

                  if (!desktop) {
                    return const Column(
                      children: [
                        ProfileIdentityCard(),
                        SizedBox(height: 22),
                        AcademicOverview(),
                      ],
                    );
                  }

                  return const Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 330,
                        child:
                        ProfileIdentityCard(),
                      ),
                      SizedBox(width: 22),
                      Expanded(
                        child:
                        AcademicOverview(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileIdentityCard
    extends StatelessWidget {
  const ProfileIdentityCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 105,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iituDarkRed,
                  iituRed,
                ],
              ),
            ),
          ),

          Transform.translate(
            offset: const Offset(
              0,
              -48,
            ),
            child: const CircleAvatar(
              radius: 54,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 49,
                backgroundImage: AssetImage(
                  'assets/images/profile_irada.png',
                ),
              ),
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -34),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const Text(
                    'Akvarzhanova Irada',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Network Security',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '3rd Year · Student ID 41151',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 10.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const ProfileInfoLine(
                    icon: Icons.email_outlined,
                    text: 'irada41151@student.iitu.kz',
                  ),
                  const ProfileInfoLine(
                    icon: Icons.school_outlined,
                    text: 'International Information Technology University',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('Student Card'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 38,
                                  backgroundImage: AssetImage(
                                    'assets/images/profile_irada.png',
                                  ),
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'Akvarzhanova Irada',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text('Student ID 41151'),
                                Text('Network Security · 3rd Year'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.badge_outlined),
                      label: const Text('View Student Card'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AcademicOverview
    extends StatelessWidget {
  const AcademicOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'ACADEMIC OVERVIEW',
            style: TextStyle(
              color: iituRed,
              fontSize: 9,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Current progress',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 23),

          LayoutBuilder(
            builder: (
                context,
                constraints,
                ) {
              final width =
              constraints.maxWidth >= 650
                  ? (constraints.maxWidth -
                  36) /
                  4
                  : (constraints.maxWidth -
                  12) /
                  2;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  AcademicMetric(
                    label: 'SEMESTER',
                    value: '5',
                  ),
                  AcademicMetric(
                    label: 'GPA',
                    value: '3.5',
                  ),
                  AcademicMetric(
                    label: 'CREDITS',
                    value: '90',
                  ),
                  AcademicMetric(
                    label: 'ATTENDANCE',
                    value: '92%',
                  ),
                ].map(
                      (metric) {
                    return SizedBox(
                      width: width,
                      child: metric,
                    );
                  },
                ).toList(),
              );
            },
          ),

          const SizedBox(height: 28),

          const Text(
            'Academic Records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 13),

          const AcademicRecordTile(
            icon:
            Icons.description_outlined,
            title: 'Transcript',
          ),
          const AcademicRecordTile(
            icon:
            Icons.emoji_events_outlined,
            title: 'Achievements',
          ),
          const AcademicRecordTile(
            icon: Icons.science_outlined,
            title: 'Research',
          ),
          const AcademicRecordTile(
            icon:
            Icons.account_balance_wallet_outlined,
            title: 'Financial Status',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// UNKNOWN ROUTE
// ============================================================

class UnknownRouteScreen
    extends StatelessWidget {
  final String routeName;

  const UnknownRouteScreen({
    super.key,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              constraints:
              const BoxConstraints(
                maxWidth: 520,
              ),
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(30),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  const Text(
                    '404',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 58,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Page not found',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'The route "$routeName" could not be opened.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 23),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                          AppRoutes.home,
                        ),
                      );
                    },
                    style:
                    ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: iituRed,
                      foregroundColor:
                      Colors.white,
                    ),
                    child: const Text(
                      'Return Home',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE SERVICE CARD
// ============================================================

class ServiceCard extends StatefulWidget {
  final CampusService service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  State<ServiceCard> createState() =>
      _ServiceCardState();
}

class _ServiceCardState
    extends State<ServiceCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius:
        BorderRadius.circular(23),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          height: 175,
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: hover
                ? widget.service.color.withOpacity(0.07)
                : Colors.white,
            borderRadius:
            BorderRadius.circular(23),
            border: Border.all(
              color: hover ? widget.service.color : borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: hover
                          ? Colors.white
                          : widget.service.color.withOpacity(0.10),
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: Icon(
                      widget.service.icon,
                      color: widget.service.color,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.north_east,
                    color: widget.service.color,
                    size: 17,
                  ),
                ],
              ),

              const Spacer(),

              Text(
                widget.service.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                widget.service.description,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style: const TextStyle(
                  color: greyText,
                  fontSize: 9.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EVENT CARDS
// ============================================================

class EventFullCard extends StatefulWidget {
  final CampusEvent event;
  final VoidCallback onTap;

  const EventFullCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  State<EventFullCard> createState() =>
      _EventFullCardState();
}

class _EventFullCardState
    extends State<EventFullCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius:
        BorderRadius.circular(25),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 190,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(25),
            border: Border.all(
              color:
              hover ? iituRed : borderColor,
            ),
            boxShadow: hover
                ? [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.05),
                blurRadius: 25,
                offset:
                const Offset(0, 10),
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Hero(
                tag:
                'event-${widget.event.title}',
                child: SizedBox(
                  height: 215,
                  width: double.infinity,
                  child: AppAssetImage(
                    path:
                    widget.event.image,
                  ),
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.event.category.toUpperCase(),
                          style: const TextStyle(
                            color: iituRed,
                            fontSize: 9.5,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Registration open',
                            style: TextStyle(
                              color: successGreen,
                              fontSize: 8.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      widget.event.date,
                      style: const TextStyle(
                        color: greyText,
                        fontSize: 10.5,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Row(
                      children: [
                        Text(
                          'View Event',
                          style: TextStyle(
                            color: iituRed,
                            fontSize: 10.5,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.north_east,
                          color: iituRed,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventPreviewCard extends StatelessWidget {
  final CampusEvent event;
  final VoidCallback onTap;

  const EventPreviewCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(23),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(23),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 175,
              width: double.infinity,
              child: AppAssetImage(
                path: event.image,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    event.category
                        .toUpperCase(),
                    style: const TextStyle(
                      color: iituRed,
                      fontSize: 8,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    event.date,
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 9.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// FORM REUSABLE WIDGETS
// ============================================================

class FormSection extends StatelessWidget {
  final String number;
  final String title;
  final Widget child;

  const FormSection({
    super.key,
    required this.number,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: iituRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          child,
        ],
      ),
    );
  }
}

class ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(30),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 170,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color:
          selected ? softRed : Colors.white,
          borderRadius:
          BorderRadius.circular(30),
          border: Border.all(
            color:
            selected ? iituRed : borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
            selected ? iituRed : darkText,
            fontSize: 10.5,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SummaryLine extends StatelessWidget {
  final String label;
  final String value;

  const SummaryLine({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 11,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: greyText,
                fontSize: 10.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COMMON INFO WIDGETS
// ============================================================

class DetailInformationRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailInformationRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 11,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iituRed,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 9.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iituRed,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE WIDGETS
// ============================================================

class ProfileInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoLine({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 11,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: greyText,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: greyText,
                fontSize: 10.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AcademicMetric extends StatelessWidget {
  final String label;
  final String value;

  const AcademicMetric({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: greyText,
              fontSize: 8,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AcademicRecordTile
    extends StatelessWidget {
  final IconData icon;
  final String title;

  const AcademicRecordTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iituRed,
            size: 19,
          ),
          const SizedBox(width: 11),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.north_east,
            color: greyText,
            size: 15,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COMMON CAMPUS IMAGE CARD
// ============================================================

class CampusImageCard extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;

  const CampusImageCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  State<CampusImageCard> createState() => _CampusImageCardState();
}

class _CampusImageCardState extends State<CampusImageCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: hover ? 1.045 : 1.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              child: AppAssetImage(
                path: widget.image,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                offset: hover ? const Offset(0, -0.04) : Offset.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// COMMON LAYOUT / STYLE
// ============================================================

class MaxWidth extends StatelessWidget {
  final Widget child;

  const MaxWidth({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
        const BoxConstraints(
          maxWidth: 1220,
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: iituRed,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 33,
            height: 1.12,
            fontWeight: FontWeight.w500,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            color: greyText,
            fontSize: 12.5,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class AcademicMiniValue
    extends StatelessWidget {
  final String label;
  final String value;

  const AcademicMiniValue({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: greyText,
              fontSize: 8,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<NavButton> createState() =>
      _NavButtonState();
}

class _NavButtonState
    extends State<NavButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final highlighted =
        hover || widget.active;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 170,
          ),
          margin:
          const EdgeInsets.only(
            right: 6,
          ),
          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: widget.active
                ? softRed
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(30),
            border: Border.all(
              color: highlighted
                  ? iituRed
                  : Colors.transparent,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: highlighted
                  ? iituRed
                  : darkText,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerNavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iituRed,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}

// ============================================================
// IMAGE HELPER
// ============================================================

class AppAssetImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Alignment alignment;

  const AppAssetImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      alignment: alignment,
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return Container(
          color: softGrey,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_outlined,
            color: greyText,
            size: 32,
          ),
        );
      },
    );
  }
}

// ============================================================
// SIMPLE REVEAL ANIMATION
// ============================================================

class RevealWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const RevealWidget({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  State<RevealWidget> createState() =>
      _RevealWidgetState();
}

class _RevealWidgetState
    extends State<RevealWidget> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(
        milliseconds: widget.delay,
      ),
          () {
        if (mounted) {
          setState(() {
            visible = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeOutCubic,
      offset: visible
          ? Offset.zero
          : const Offset(
        0,
        0.12,
      ),
      child: AnimatedOpacity(
        duration: const Duration(
          milliseconds: 420,
        ),
        opacity: visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}