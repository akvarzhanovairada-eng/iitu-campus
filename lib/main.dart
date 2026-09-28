import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const IITUCampusApp());
}

// ============================================================
// COLORS
// ============================================================

const Color iituRed = Color(0xFFA6192E);
const Color iituDarkRed = Color(0xFF75101F);

const Color darkText = Color(0xFF202126);
const Color greyText = Color(0xFF74777E);

const Color pageBackground = Color(0xFFF8F8FA);
const Color softRed = Color(0xFFFCECEE);
const Color borderColor = Color(0xFFE8E8EC);

const Color navy = Color(0xFF071D2C);
const Color navyLight = Color(0xFF123A52);

// ============================================================
// APP
// ============================================================

class IITUCampusApp extends StatelessWidget {
  const IITUCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IITU Campus',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: pageBackground,

        textTheme: GoogleFonts.manropeTextTheme(
          baseTheme.textTheme,
        ).apply(
          bodyColor: darkText,
          displayColor: darkText,
        ),

        colorScheme: ColorScheme.fromSeed(
          seedColor: iituRed,
          brightness: Brightness.light,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F7),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: iituRed,
              width: 1.3,
            ),
          ),
        ),
      ),
      home: const CampusPortal(),
    );
  }
}

// ============================================================
// MAIN PAGE
// ============================================================

class CampusPortal extends StatefulWidget {
  const CampusPortal({super.key});

  @override
  State<CampusPortal> createState() => _CampusPortalState();
}

class _CampusPortalState extends State<CampusPortal> {
  int _pageIndex = 0;

  int _floor = 1;
  int _selectedPlace = 0;

  int _eventIndex = 0;

  final Set<int> _registeredEvents = {};

  final List<ReminderItem> _reminders = [];

  Timer? _eventTimer;

  final List<CampusEvent> events = const [
    CampusEvent(
      title: 'Almaty Student Hackathon',
      category: 'Hackathon',
      date: '12 OCT',
      time: '10:00 AM',
      location: 'Almaty',
      description:
      'Join students and developers to build innovative digital solutions in teams.',
      image: 'assets/images/event_hackathon.jpg',
    ),
    CampusEvent(
      title: 'Cybersecurity Workshop',
      category: 'Workshop',
      date: '18 OCT',
      time: '2:00 PM',
      location: 'IITU Campus',
      description:
      'A practical session focused on cybersecurity, networks and modern digital security tools.',
      image: 'assets/images/event_cybersecurity.jpg',
    ),
    CampusEvent(
      title: 'Career & Internship Fair',
      category: 'Career',
      date: '24 OCT',
      time: '11:00 AM',
      location: 'Main Hall',
      description:
      'Meet companies and explore internships, projects and future career opportunities.',
      image: 'assets/images/event_career.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _eventTimer = Timer.periodic(
      const Duration(seconds: 6),
          (_) {
        if (!mounted) return;

        if (_pageIndex == 0) {
          setState(() {
            _eventIndex = (_eventIndex + 1) % events.length;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _eventTimer?.cancel();
    super.dispose();
  }

  // ============================================================
  // BASIC ACTIONS
  // ============================================================

  void _changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.manrope(),
        ),
        backgroundColor: darkText,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _registerEvent(int index) {
    setState(() {
      _registeredEvents.add(index);
    });

    _showMessage(
      '${events[index].title} registered successfully!',
    );
  }

  // ============================================================
  // CALENDAR / REMINDER
  // ============================================================

  Future<void> _openCalendar() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2028, 12, 31),
      helpText: 'Select reminder date',
      confirmText: 'Select',
    );

    if (selected != null && mounted) {
      await _openReminderDialog(selected);
    }
  }

  Future<void> _openReminderDialog([
    DateTime? initialDate,
  ]) async {
    final controller = TextEditingController();

    final date = initialDate ?? DateTime.now();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            26,
            26,
            26,
            0,
          ),
          contentPadding: const EdgeInsets.all(26),
          actionsPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          title: const Text(
            'Create Reminder',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: softRed,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _prettyDate(date),
                    style: const TextStyle(
                      color: iituRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Example: ML assignment',
                    prefixIcon: Icon(
                      Icons.edit_note_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();

                if (text.isNotEmpty) {
                  Navigator.pop(
                    dialogContext,
                    text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: iituRed,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Add Reminder',
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null || !mounted) return;

    setState(() {
      _reminders.add(
        ReminderItem(
          title: result,
          date: date,
        ),
      );
    });

    _showMessage(
      'Reminder added for ${_prettyDate(date)}',
    );
  }

  String _prettyDate(DateTime date) {
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

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final desktop = width >= 1000;

    return Scaffold(
      appBar: _buildAppBar(desktop),

      drawer: _buildDrawer(),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 380),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey(_pageIndex),
          child: _currentPage(),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openReminderDialog,
        elevation: 5,
        hoverElevation: 8,
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        icon: const Icon(
          Icons.notifications_none_rounded,
        ),
        label: const Text(
          'Reminder',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: iituRed,
        unselectedItemColor: Colors.grey,
        elevation: 12,
        onTap: _changePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_outlined,
            ),
            activeIcon: Icon(
              Icons.event_rounded,
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map_outlined,
            ),
            activeIcon: Icon(
              Icons.map_rounded,
            ),
            label: 'Campus',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _currentPage() {
    switch (_pageIndex) {
      case 1:
        return _eventsPage();

      case 2:
        return _campusPage();

      case 3:
        return _profilePage();

      default:
        return _homePage();
    }
  }

  // ============================================================
  // HEADER
  // ============================================================

  PreferredSizeWidget _buildAppBar(
      bool desktop,
      ) {
    return AppBar(
      toolbarHeight: 76,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: darkText,
      elevation: 0,
      titleSpacing: 18,

      title: Row(
        children: [
          SizedBox(
            width: 145,
            height: 44,
            child: Image.asset(
              'assets/images/iitu_logo.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),

          if (desktop) ...[
            const SizedBox(width: 38),

            HeaderNavButton(
              label: 'Home',
              active: _pageIndex == 0,
              onTap: () => _changePage(0),
            ),

            HeaderNavButton(
              label: 'Events',
              active: _pageIndex == 1,
              onTap: () => _changePage(1),
            ),

            HeaderNavButton(
              label: 'Campus',
              active: _pageIndex == 2,
              onTap: () => _changePage(2),
            ),

            HeaderNavButton(
              label: 'Profile',
              active: _pageIndex == 3,
              onTap: () => _changePage(3),
            ),
          ],
        ],
      ),

      actions: [
        HeaderIconButton(
          icon: Icons.search_rounded,
          onTap: () {
            _showMessage(
              'Search selected.',
            );
          },
        ),

        HeaderIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: () {
            _showMessage(
              'You have 2 new university updates.',
            );
          },
        ),

        const SizedBox(width: 8),

        GestureDetector(
          onTap: () => _changePage(3),
          child: const Padding(
            padding: EdgeInsets.only(
              right: 18,
            ),
            child: CircleAvatar(
              radius: 21,
              backgroundColor: softRed,
              backgroundImage: AssetImage(
                'assets/images/profile_irada.png',
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget _buildDrawer() {
    return Drawer(
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
                  radius: 31,
                  backgroundImage: AssetImage(
                    'assets/images/profile_irada.png',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Akvarzhanova Irada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Network Security • 3rd Year',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          _drawerItem(
            Icons.person_outline,
            'My Profile',
                () {
              Navigator.pop(context);
              _changePage(3);
            },
          ),

          _drawerItem(
            Icons.menu_book_outlined,
            'My Courses',
                () {
              Navigator.pop(context);
              _showMessage(
                'My Courses selected.',
              );
            },
          ),

          _drawerItem(
            Icons.calendar_month_outlined,
            'Calendar',
                () {
              Navigator.pop(context);
              _openCalendar();
            },
          ),

          _drawerItem(
            Icons.map_outlined,
            'Campus Map',
                () {
              Navigator.pop(context);
              _changePage(2);
            },
          ),

          _drawerItem(
            Icons.support_agent_outlined,
            'Student Services',
                () {
              Navigator.pop(context);
              _showMessage(
                'Student Services selected.',
              );
            },
          ),

          const Divider(),

          _drawerItem(
            Icons.settings_outlined,
            'Settings',
                () {
              Navigator.pop(context);
              _showMessage(
                'Settings selected.',
              );
            },
            red: false,
          ),

          _drawerItem(
            Icons.info_outline,
            'About IITU',
                () {
              Navigator.pop(context);
              _showMessage(
                'International Information Technology University',
              );
            },
            red: false,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool red = true,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        color: red ? iituRed : greyText,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }

  // ============================================================
  // HOME PAGE
  // ============================================================

  Widget _homePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _heroSection(),

          _maxWidth(
            child: Column(
              children: [
                const SizedBox(height: 95),

                SimpleReveal(
                  delay: 100,
                  child: _studentHubSection(),
                ),

                const SizedBox(height: 110),

                SimpleReveal(
                  delay: 160,
                  child: _announcementSection(),
                ),

                const SizedBox(height: 110),

                SimpleReveal(
                  delay: 220,
                  child: _eventsShowcase(),
                ),

                const SizedBox(height: 110),

                SimpleReveal(
                  delay: 280,
                  child: _campusLifeSection(),
                ),

                const SizedBox(height: 110),

                SimpleReveal(
                  delay: 340,
                  child: _globalFooter(),
                ),

                const SizedBox(height: 28),

                const Text(
                  'IITU Campus • Student Portal Concept • 2026',
                  style: TextStyle(
                    color: greyText,
                    fontSize: 11,
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _heroSection() {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final desktop =
            constraints.maxWidth >= 850;

        if (!desktop) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                _heroText(),

                SizedBox(
                  height: 340,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/hero_campus.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 610,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedHeroImage(
                image:
                'assets/images/hero_campus.png',
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
                      Colors.white.withOpacity(0.05),
                    ],
                    stops: const [
                      0,
                      0.28,
                      0.57,
                      1,
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 650,
                  child: _heroText(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _heroText() {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: const Duration(
        milliseconds: 850,
      ),
      curve: Curves.easeOutCubic,
      builder: (
          context,
          value,
          child,
          ) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              28 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 46,
          vertical: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: softRed,
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 15,
                    color: iituRed,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'INTERNATIONAL INFORMATION TECHNOLOGY UNIVERSITY',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Your Campus.\nYour Future.\nYour IITU.',
              style: TextStyle(
                color: darkText,
                fontSize: 56,
                height: 1.03,
                letterSpacing: -2.4,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 23),

            const SizedBox(
              width: 500,
              child: Text(
                'A smarter way to explore academic life, student services, events and opportunities at IITU.',
                style: TextStyle(
                  color: greyText,
                  fontSize: 16,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 31),

            ElevatedButton.icon(
              onPressed: () => _changePage(2),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: iituRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.arrow_forward_rounded,
                size: 17,
              ),
              label: const Text(
                'Explore Campus',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STUDENT HUB
  // ============================================================

  Widget _studentHubSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PremiumHeading(
          eyebrow: 'STUDENT SPACE',
          title: 'Everything you need, around you.',
          subtitle:
          'Access your university tools and manage your day without leaving the portal.',
        ),

        const SizedBox(height: 40),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final desktop =
                constraints.maxWidth >= 900;

            final hub = OrbitHub(
              onSelect: (
                  value,
                  ) {
                if (value == 'Calendar') {
                  _openCalendar();
                } else if (value == 'Campus') {
                  _changePage(2);
                } else if (value == 'Events') {
                  _changePage(1);
                } else {
                  _showMessage(
                    '$value selected.',
                  );
                }
              },
            );

            final today = _todayPanel();

            if (!desktop) {
              return Column(
                children: [
                  hub,
                  const SizedBox(height: 40),
                  today,
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: hub,
                ),

                const SizedBox(width: 65),

                SizedBox(
                  width: 390,
                  child: today,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _todayPanel() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'TODAY',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tuesday',
                    style: TextStyle(
                      color: darkText,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.7,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.wb_sunny_outlined,
                color: iituRed,
              ),
            ],
          ),

          const SizedBox(height: 27),

          _todayClass(
            '09:00',
            'Network Security',
            'Room 304',
            true,
          ),

          _todayClass(
            '11:00',
            'Cloud Computing',
            'Lab 212',
            false,
          ),

          _todayClass(
            '14:00',
            'Machine Learning',
            'Room 406',
            false,
          ),

          if (_reminders.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 3,
                bottom: 17,
              ),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: softRed,
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: iituRed,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _reminders.last.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openReminderDialog,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: iituRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  icon: const Icon(
                    Icons.add_alert_outlined,
                    size: 17,
                  ),
                  label: const Text(
                    'Reminder',
                  ),
                ),
              ),

              const SizedBox(width: 11),

              IconButton(
                tooltip: 'Open Calendar',
                onPressed: _openCalendar,
                style: IconButton.styleFrom(
                  backgroundColor: softRed,
                  foregroundColor: iituRed,
                  padding: const EdgeInsets.all(14),
                ),
                icon: const Icon(
                  Icons.calendar_month_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _todayClass(
      String time,
      String subject,
      String room,
      bool current,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              time,
              style: TextStyle(
                color:
                current ? iituRed : darkText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            width: 3,
            height: 39,
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color:
              current ? iituRed : borderColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  room,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NEW ANNOUNCEMENTS DESIGN
  // ============================================================

  Widget _announcementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PremiumHeading(
          eyebrow: 'LATEST FROM IITU',
          title: 'Stay connected with university life.',
          subtitle:
          'Academic opportunities, events and important campus updates.',
        ),

        const SizedBox(height: 38),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            double cardWidth;

            if (constraints.maxWidth >= 960) {
              cardWidth =
                  (constraints.maxWidth - 36) / 3;
            } else if (constraints.maxWidth >=
                620) {
              cardWidth =
                  (constraints.maxWidth - 18) / 2;
            } else {
              cardWidth = constraints.maxWidth;
            }

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _doubleDegreeAnnouncement(),
                ),

                SizedBox(
                  width: cardWidth,
                  child: _hackathonAnnouncement(),
                ),

                SizedBox(
                  width: cardWidth,
                  child: _academicAnnouncement(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _doubleDegreeAnnouncement() {
    return PremiumHover(
      child: Container(
        height: 430,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          children: [
            const Expanded(
              child: AnnouncementMotionVisual(
                mode: AnnouncementVisualMode.partner,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                25,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INTERNATIONAL',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9.5,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Double Degree Programs',
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Discover academic pathways with international partner universities.',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 12.5,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 13),

                  TextButton.icon(
                    onPressed: () {
                      _showMessage(
                        'Double Degree Programs selected.',
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: iituRed,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 16,
                    ),
                    label: const Text(
                      'Explore programs',
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

  Widget _hackathonAnnouncement() {
    return PremiumHover(
      child: Container(
        height: 430,
        clipBehavior: Clip.antiAlias,
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
            SizedBox(
              height: 240,
              width: double.infinity,
              child: HoverImage(
                image:
                'assets/images/event_hackathon.jpg',
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '12 OCT 2026',
                          style: TextStyle(
                            color: iituRed,
                            fontSize: 9.5,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'HACKATHON',
                          style: TextStyle(
                            color: greyText,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 11),

                    const Text(
                      'Almaty Student Hackathon',
                      style: TextStyle(
                        fontSize: 21,
                        height: 1.12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.6,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Text(
                          'Team up. Build. Innovate.',
                          style: TextStyle(
                            color: greyText,
                            fontSize: 11.5,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _changePage(1);
                          },
                          icon: const Icon(
                            Icons.north_east,
                            size: 17,
                            color: iituRed,
                          ),
                        ),
                      ],
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

  Widget _academicAnnouncement() {
    return PremiumHover(
      child: Container(
        height: 430,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFAFB),
              Color(0xFFF4F3F5),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          children: [
            const Expanded(
              child: AnnouncementMotionVisual(
                mode: AnnouncementVisualMode.academic,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                25,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACADEMIC',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Semester Updates',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Courses, schedules and key academic information in one place.',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 12.5,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 13),

                  TextButton.icon(
                    onPressed: () {
                      _showMessage(
                        'Academic updates selected.',
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: iituRed,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 16,
                    ),
                    label: const Text(
                      'View updates',
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

  // ============================================================
  // EVENTS SHOWCASE
  // ============================================================

  Widget _eventsShowcase() {
    final event = events[_eventIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: PremiumHeading(
                eyebrow: 'UPCOMING',
                title: 'What’s happening next?',
                subtitle:
                'Explore workshops, hackathons and student opportunities.',
              ),
            ),

            CircularArrowButton(
              icon: Icons.arrow_back_rounded,
              onTap: () {
                setState(() {
                  _eventIndex =
                      (_eventIndex -
                          1 +
                          events.length) %
                          events.length;
                });
              },
            ),

            const SizedBox(width: 8),

            CircularArrowButton(
              icon: Icons.arrow_forward_rounded,
              onTap: () {
                setState(() {
                  _eventIndex =
                      (_eventIndex + 1) %
                          events.length;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 35),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final desktop =
                constraints.maxWidth >= 930;

            final mainCard =
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 420,
              ),
              switchInCurve: Curves.easeOutCubic,
              child: _largeEventCard(
                event,
                _eventIndex,
                key: ValueKey(_eventIndex),
              ),
            );

            if (!desktop) {
              return Column(
                children: [
                  mainCard,
                  const SizedBox(height: 18),
                  _eventDots(),
                ],
              );
            }

            final previews = <Widget>[];

            for (int i = 0;
            i < events.length;
            i++) {
              if (i != _eventIndex) {
                previews.add(
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: _eventPreviewCard(
                      events[i],
                      i,
                    ),
                  ),
                );
              }
            }

            return Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: mainCard,
                ),

                const SizedBox(width: 18),

                SizedBox(
                  width: 295,
                  child: Column(
                    children: previews,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _eventDots(),
            ),

            TextButton.icon(
              onPressed: () => _changePage(1),
              style: TextButton.styleFrom(
                foregroundColor: iituRed,
              ),
              label: const Text(
                'View all events',
              ),
              icon: const Icon(
                Icons.arrow_forward,
                size: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _largeEventCard(
      CampusEvent event,
      int index, {
        Key? key,
      }) {
    final registered =
    _registeredEvents.contains(index);

    return Container(
      key: key,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final horizontal =
              constraints.maxWidth >= 700;

          final image = SizedBox(
            width: horizontal
                ? constraints.maxWidth * 0.48
                : double.infinity,
            height: horizontal ? 390 : 250,
            child: HoverImage(
              image: event.image,
            ),
          );

          final info = Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
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
                  child: Text(
                    event.date,
                    style: const TextStyle(
                      color: iituRed,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  event.category.toUpperCase(),
                  style: const TextStyle(
                    color: iituRed,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.08,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.9,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  event.description,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),

                const SizedBox(height: 18),

                Wrap(
                  spacing: 18,
                  runSpacing: 8,
                  children: [
                    _eventInfo(
                      Icons.access_time_rounded,
                      event.time,
                    ),
                    _eventInfo(
                      Icons.location_on_outlined,
                      event.location,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: registered
                        ? null
                        : () {
                      _registerEvent(index);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: iituRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      registered
                          ? '✓ Registered'
                          : 'Register',
                    ),
                  ),
                ),
              ],
            ),
          );

          if (!horizontal) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                image,
                info,
              ],
            );
          }

          return Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              image,
              Expanded(
                child: info,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _eventPreviewCard(
      CampusEvent event,
      int index,
      ) {
    return PremiumHover(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          setState(() {
            _eventIndex = index;
          });
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 95,
                height: 112,
                child: Image.asset(
                  event.image,
                  fit: BoxFit.cover,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.date,
                        style: const TextStyle(
                          color: iituRed,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

  Widget _eventDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        events.length,
            (index) {
          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            margin: const EdgeInsets.only(
              right: 6,
            ),
            width:
            index == _eventIndex ? 28 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == _eventIndex
                  ? iituRed
                  : const Color(0xFFD9D9DE),
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _eventInfo(
      IconData icon,
      String value,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iituRed,
          size: 15,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: greyText,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CAMPUS LIFE
  // ============================================================

  Widget _campusLifeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PremiumHeading(
          eyebrow: 'CAMPUS LIFE',
          title: 'Designed for more than classes.',
          subtitle:
          'Discover spaces for study, collaboration, research and student life.',
        ),

        const SizedBox(height: 36),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final desktop =
                constraints.maxWidth >= 850;

            if (!desktop) {
              return Column(
                children: [
                  SizedBox(
                    height: 280,
                    child: CampusVisualCard(
                      image:
                      'assets/images/campus_building.jpg',
                      title:
                      'Academic Building',
                      subtitle:
                      'Modern spaces for learning and collaboration.',
                      number: '01',
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 260,
                    child: CampusVisualCard(
                      image:
                      'assets/images/campus_lab.png',
                      title:
                      'Technology Labs',
                      subtitle:
                      'Build. Test. Innovate.',
                      number: '02',
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 260,
                    child: CampusVisualCard(
                      image:
                      'assets/images/campus_library.jpg',
                      title: 'Library',
                      subtitle:
                      'Read. Research. Focus.',
                      number: '03',
                    ),
                  ),
                ],
              );
            }

            return SizedBox(
              height: 500,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CampusVisualCard(
                      image:
                      'assets/images/campus_building.jpg',
                      title:
                      'Academic Building',
                      subtitle:
                      'Modern classrooms, collaborative spaces and technology-driven learning.',
                      number: '01',
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: CampusVisualCard(
                            image:
                            'assets/images/campus_lab.png',
                            title:
                            'Technology Labs',
                            subtitle:
                            'Build. Test. Innovate.',
                            number: '02',
                          ),
                        ),

                        const SizedBox(height: 18),

                        Expanded(
                          child: CampusVisualCard(
                            image:
                            'assets/images/campus_library.jpg',
                            title: 'Library',
                            subtitle:
                            'Read. Research. Focus.',
                            number: '03',
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

        const SizedBox(height: 22),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _changePage(2),
            style: TextButton.styleFrom(
              foregroundColor: iituRed,
            ),
            label: const Text(
              'Explore campus',
            ),
            icon: const Icon(
              Icons.arrow_forward,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GLOBAL FOOTER
  // ============================================================

  Widget _globalFooter() {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            navy,
            navyLight,
          ],
        ),
        borderRadius: BorderRadius.circular(36),
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final desktop =
              constraints.maxWidth >= 800;

          final copy = Padding(
            padding: const EdgeInsets.all(44),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'GLOBAL COMMUNITY',
                  style: TextStyle(
                    color: Color(0xFF8FC8E8),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Grow beyond\nborders with IITU.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    height: 1.05,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.5,
                  ),
                ),

                const SizedBox(height: 18),

                const SizedBox(
                  width: 470,
                  child: Text(
                    'Connect with international opportunities, innovation and a global academic community from Kazakhstan.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 27),

                ElevatedButton.icon(
                  onPressed: () {
                    _showMessage(
                      'International opportunities selected.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    foregroundColor: navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 16,
                    ),
                  ),
                  icon: const Icon(
                    Icons.north_east,
                    size: 17,
                  ),
                  label: const Text(
                    'Discover Opportunities',
                  ),
                ),
              ],
            ),
          );

          if (!desktop) {
            return Column(
              children: [
                copy,
                const SizedBox(
                  height: 320,
                  child: Center(
                    child: AnimatedGlobe(),
                  ),
                ),
              ],
            );
          }

          return SizedBox(
            height: 430,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: copy,
                ),

                const Expanded(
                  flex: 2,
                  child: Center(
                    child: AnimatedGlobe(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // EVENTS PAGE
  // ============================================================

  Widget _eventsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        24,
        60,
        24,
        110,
      ),
      child: _maxWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PremiumHeading(
              eyebrow: 'WHAT’S HAPPENING',
              title: 'Upcoming Events',
              subtitle:
              'Discover academic, career and student opportunities at IITU.',
            ),

            const SizedBox(height: 38),

            LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                double cardWidth;

                if (constraints.maxWidth >= 1000) {
                  cardWidth =
                      (constraints.maxWidth - 36) / 3;
                } else if (constraints.maxWidth >=
                    650) {
                  cardWidth =
                      (constraints.maxWidth - 18) / 2;
                } else {
                  cardWidth =
                      constraints.maxWidth;
                }

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: List.generate(
                    events.length,
                        (index) {
                      return SizedBox(
                        width: cardWidth,
                        child: _eventPageCard(
                          events[index],
                          index,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventPageCard(
      CampusEvent event,
      int index,
      ) {
    final registered =
    _registeredEvents.contains(index);

    return PremiumHover(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 215,
              width: double.infinity,
              child: HoverImage(
                image: event.image,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.date,
                        style: const TextStyle(
                          color: iituRed,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        event.category.toUpperCase(),
                        style: const TextStyle(
                          color: greyText,
                          fontSize: 9,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 19,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 11),

                  Text(
                    event.description,
                    style: const TextStyle(
                      color: greyText,
                      fontSize: 12,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 17),

                  _eventInfo(
                    Icons.access_time,
                    event.time,
                  ),

                  const SizedBox(height: 8),

                  _eventInfo(
                    Icons.location_on_outlined,
                    event.location,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: registered
                          ? null
                          : () {
                        _registerEvent(index);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: iituRed,
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      child: Text(
                        registered
                            ? '✓ Registered'
                            : 'Register',
                      ),
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

  // ============================================================
  // CAMPUS PAGE
  // ============================================================

  Widget _campusPage() {
    final places =
    _placesForFloor(_floor);

    if (_selectedPlace >= places.length) {
      _selectedPlace = 0;
    }

    final selected =
    places[_selectedPlace];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        24,
        60,
        24,
        110,
      ),
      child: _maxWidth(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const PremiumHeading(
              eyebrow: 'CAMPUS NAVIGATOR',
              title: 'Explore IITU Campus',
              subtitle:
              'Choose a level and discover student spaces across the university.',
            ),

            const SizedBox(height: 32),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                5,
                    (index) {
                  final floor = index + 1;
                  final active =
                      floor == _floor;

                  return InkWell(
                    borderRadius:
                    BorderRadius.circular(30),
                    onTap: () {
                      setState(() {
                        _floor = floor;
                        _selectedPlace = 0;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? iituRed
                            : Colors.white,
                        borderRadius:
                        BorderRadius.circular(30),
                        border: Border.all(
                          color: active
                              ? iituRed
                              : borderColor,
                        ),
                      ),
                      child: Text(
                        'Level $floor',
                        style: TextStyle(
                          color: active
                              ? Colors.white
                              : greyText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final desktop =
                    constraints.maxWidth >= 850;

                if (!desktop) {
                  return Column(
                    children: [
                      _floorMap(
                        places,
                        selected,
                      ),
                      const SizedBox(height: 20),
                      _floorMenu(places),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 235,
                      child: _floorMenu(
                        places,
                      ),
                    ),

                    const SizedBox(width: 22),

                    Expanded(
                      child: _floorMap(
                        places,
                        selected,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 90),

            _campusLifeSection(),
          ],
        ),
      ),
    );
  }

  Widget _floorMenu(
      List<FloorPlace> places,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: List.generate(
          places.length,
              (index) {
            final active =
                index == _selectedPlace;

            return InkWell(
              borderRadius:
              BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  _selectedPlace = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                margin: const EdgeInsets.only(
                  bottom: 5,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? softRed
                      : Colors.transparent,
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      places[index].icon,
                      size: 18,
                      color: active
                          ? iituRed
                          : greyText,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        places[index].name,
                        style: TextStyle(
                          fontSize: 12,
                          color: active
                              ? iituRed
                              : darkText,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _floorMap(
      List<FloorPlace> places,
      FloorPlace selected,
      ) {
    return Container(
      height: 520,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          return Stack(
            children: [
              Positioned(
                left: w * 0.07,
                top: h * 0.10,
                width: w * 0.86,
                height: h * 0.67,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF2F3F6,
                    ),
                    borderRadius:
                    BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(
                        0xFFD0D3DA,
                      ),
                    ),
                  ),
                ),
              ),

              _room(
                w * 0.12,
                h * 0.16,
                w * 0.22,
                h * 0.22,
                const Color(0xFFFFE7EB),
              ),

              _room(
                w * 0.12,
                h * 0.44,
                w * 0.22,
                h * 0.24,
                const Color(0xFFFFF0DC),
              ),

              _room(
                w * 0.66,
                h * 0.16,
                w * 0.22,
                h * 0.22,
                const Color(0xFFE7EEFA),
              ),

              _room(
                w * 0.66,
                h * 0.44,
                w * 0.22,
                h * 0.24,
                const Color(0xFFEEE7FA),
              ),

              Positioned(
                left: w * 0.39,
                top: h * 0.17,
                width: w * 0.22,
                height: h * 0.51,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE7F1EA,
                    ),
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
              ),

              ...List.generate(
                places.length,
                    (index) {
                  final place = places[index];
                  final active =
                      index == _selectedPlace;

                  return Align(
                    alignment: place.position,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPlace = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 180,
                        ),
                        width: active ? 46 : 38,
                        height: active ? 46 : 38,
                        decoration: BoxDecoration(
                          color: active
                              ? iituRed
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: iituRed,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(
                                0.10,
                              ),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Icon(
                          place.icon,
                          size: 18,
                          color: active
                              ? Colors.white
                              : iituRed,
                        ),
                      ),
                    ),
                  );
                },
              ),

              AnimatedAlign(
                duration: const Duration(
                  milliseconds: 620,
                ),
                curve: Curves.easeInOutCubic,
                alignment: selected.position,
                child: Transform.translate(
                  offset:
                  const Offset(0, -47),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: darkText,
                      borderRadius:
                      BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(
                            0.13,
                          ),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_walk_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 18,
                right: 18,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: softRed,
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Level $_floor',
                    style: const TextStyle(
                      color: iituRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.055,
                        ),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected.icon,
                        color: iituRed,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              selected.description,
                              style: const TextStyle(
                                color: greyText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _room(
      double left,
      double top,
      double width,
      double height,
      Color color,
      ) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  List<FloorPlace> _placesForFloor(
      int floor,
      ) {
    switch (floor) {
      case 1:
        return const [
          FloorPlace(
            name: 'Main Entrance',
            description:
            'University entrance and reception.',
            icon:
            Icons.door_front_door_outlined,
            position:
            Alignment(-0.70, 0.42),
          ),
          FloorPlace(
            name: 'Cafeteria',
            description:
            'Student dining and coffee area.',
            icon: Icons.restaurant_outlined,
            position:
            Alignment(0.58, 0.40),
          ),
          FloorPlace(
            name: 'Student Services',
            description:
            'Student support and information.',
            icon:
            Icons.support_agent_outlined,
            position:
            Alignment(-0.32, -0.36),
          ),
          FloorPlace(
            name: 'Event Hall',
            description:
            'Presentations and university events.',
            icon: Icons.groups_outlined,
            position:
            Alignment(0.54, -0.37),
          ),
        ];

      case 2:
        return const [
          FloorPlace(
            name: 'Classrooms',
            description:
            'General teaching classrooms.',
            icon: Icons.school_outlined,
            position:
            Alignment(-0.56, -0.38),
          ),
          FloorPlace(
            name: 'Computer Lab',
            description:
            'Computer laboratory for practical classes.',
            icon: Icons.computer,
            position:
            Alignment(0.52, -0.36),
          ),
          FloorPlace(
            name: 'Study Area',
            description:
            'Collaborative student study space.',
            icon:
            Icons.chair_alt_outlined,
            position:
            Alignment(-0.05, 0.43),
          ),
        ];

      case 3:
        return const [
          FloorPlace(
            name: 'Library',
            description:
            'Books, digital resources and study space.',
            icon:
            Icons.local_library_outlined,
            position:
            Alignment(-0.56, -0.38),
          ),
          FloorPlace(
            name: 'Reading Zone',
            description:
            'Quiet individual reading area.',
            icon: Icons.menu_book_outlined,
            position:
            Alignment(0.50, -0.36),
          ),
          FloorPlace(
            name: 'Discussion Rooms',
            description:
            'Rooms for teamwork and group study.',
            icon: Icons.groups_2_outlined,
            position:
            Alignment(0.05, 0.43),
          ),
        ];

      case 4:
        return const [
          FloorPlace(
            name: 'Research Labs',
            description:
            'Technical and research laboratory spaces.',
            icon: Icons.science_outlined,
            position:
            Alignment(-0.56, -0.38),
          ),
          FloorPlace(
            name: 'Innovation Hub',
            description:
            'Projects, startups and innovation.',
            icon: Icons.lightbulb_outline,
            position:
            Alignment(0.50, -0.36),
          ),
          FloorPlace(
            name: 'Meeting Rooms',
            description:
            'Group discussions and meetings.',
            icon:
            Icons.meeting_room_outlined,
            position:
            Alignment(0.05, 0.43),
          ),
        ];

      default:
        return const [
          FloorPlace(
            name: 'Faculty Offices',
            description:
            'Academic and faculty offices.',
            icon: Icons.business_outlined,
            position:
            Alignment(-0.56, -0.38),
          ),
          FloorPlace(
            name: 'Conference Room',
            description:
            'Academic meetings and presentations.',
            icon: Icons.co_present_outlined,
            position:
            Alignment(0.50, -0.36),
          ),
          FloorPlace(
            name: 'Quiet Study Space',
            description:
            'Individual study and focus area.',
            icon:
            Icons.library_books_outlined,
            position:
            Alignment(0.05, 0.43),
          ),
        ];
    }
  }

  // ============================================================
  // PROFILE PAGE
  // ============================================================

  Widget _profilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        24,
        60,
        24,
        110,
      ),
      child: _maxWidth(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const PremiumHeading(
              eyebrow: 'STUDENT PROFILE',
              title: 'Your academic space.',
              subtitle:
              'Profile, academic overview and student activity.',
            ),

            const SizedBox(height: 38),

            LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final desktop =
                    constraints.maxWidth >= 850;

                if (!desktop) {
                  return Column(
                    children: [
                      _profileCard(),
                      const SizedBox(height: 25),
                      _academicOverview(),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 350,
                      child: _profileCard(),
                    ),

                    const SizedBox(width: 25),

                    Expanded(
                      child: _academicOverview(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 118,
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
            offset: const Offset(0, -56),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 54,
                backgroundImage: AssetImage(
                  'assets/images/profile_irada.png',
                ),
              ),
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -42),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                children: [
                  Text(
                    'Akvarzhanova Irada',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Network Security',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '3rd Year · Student ID 41151',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 11.5,
                    ),
                  ),
                  SizedBox(height: 22),
                  Divider(),
                  SizedBox(height: 12),
                  ProfileLine(
                    icon: Icons.email_outlined,
                    text:
                    'irada41151@student.iitu.kz',
                  ),
                  ProfileLine(
                    icon: Icons.school_outlined,
                    text:
                    'International Information Technology University',
                  ),
                  ProfileLine(
                    icon:
                    Icons.location_on_outlined,
                    text: 'Kazakhstan',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _academicOverview() {
    const items = [
      AcademicItem(
        Icons.description_outlined,
        'Transcript',
        'Academic record',
      ),
      AcademicItem(
        Icons.verified_outlined,
        'Academic Status',
        'Current standing',
      ),
      AcademicItem(
        Icons.emoji_events_outlined,
        'Achievements',
        'Awards & certificates',
      ),
      AcademicItem(
        Icons.science_outlined,
        'Research',
        'Publications & projects',
      ),
      AcademicItem(
        Icons.account_balance_wallet_outlined,
        'Financial Status',
        'Payments & balances',
      ),
      AcademicItem(
        Icons.groups_outlined,
        'Student Activities',
        'Campus participation',
      ),
    ];

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final width =
        constraints.maxWidth >= 650
            ? (constraints.maxWidth - 14) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: items.map(
                (item) {
              return SizedBox(
                width: width,
                child: PremiumHover(
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(22),
                    onTap: () {
                      _showMessage(
                        '${item.title} selected.',
                      );
                    },
                    child: Container(
                      height: 130,
                      padding: const EdgeInsets.all(21),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(22),
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: softRed,
                              borderRadius:
                              BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Icon(
                              item.icon,
                              color: iituRed,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    color: greyText,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.north_east,
                            color: iituRed,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  // ============================================================
  // MAX WIDTH
  // ============================================================

  Widget _maxWidth({
    required Widget child,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1220,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
// DATA
// ============================================================

class CampusEvent {
  final String title;
  final String category;
  final String date;
  final String time;
  final String location;
  final String description;
  final String image;

  const CampusEvent({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.image,
  });
}

class ReminderItem {
  final String title;
  final DateTime date;

  const ReminderItem({
    required this.title,
    required this.date,
  });
}

class FloorPlace {
  final String name;
  final String description;
  final IconData icon;
  final Alignment position;

  const FloorPlace({
    required this.name,
    required this.description,
    required this.icon,
    required this.position,
  });
}

class AcademicItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const AcademicItem(
      this.icon,
      this.title,
      this.subtitle,
      );
}

// ============================================================
// HEADER NAVIGATION
// ============================================================

class HeaderNavButton extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const HeaderNavButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<HeaderNavButton> createState() =>
      _HeaderNavButtonState();
}

class _HeaderNavButtonState
    extends State<HeaderNavButton> {
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
          margin: const EdgeInsets.only(
            right: 7,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
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
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<HeaderIconButton> createState() =>
      _HeaderIconButtonState();
}

class _HeaderIconButtonState
    extends State<HeaderIconButton> {
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
      child: IconButton(
        onPressed: widget.onTap,
        style: IconButton.styleFrom(
          backgroundColor:
          hover ? softRed : Colors.transparent,
          foregroundColor:
          hover ? iituRed : darkText,
        ),
        icon: Icon(
          widget.icon,
        ),
      ),
    );
  }
}

// ============================================================
// HEADING
// ============================================================

class PremiumHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const PremiumHeading({
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
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: const TextStyle(
            color: darkText,
            fontSize: 34,
            height: 1.12,
            fontWeight: FontWeight.w500,
            letterSpacing: -1.2,
          ),
        ),

        const SizedBox(height: 9),

        Text(
          subtitle,
          style: const TextStyle(
            color: greyText,
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SIMPLE REVEAL
// ============================================================

class SimpleReveal extends StatelessWidget {
  final Widget child;
  final int delay;

  const SimpleReveal({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(
        milliseconds: 650 + delay,
      ),
      curve: Curves.easeOutCubic,
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      builder: (
          context,
          value,
          widget,
          ) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              30 * (1 - value),
            ),
            child: widget,
          ),
        );
      },
      child: child,
    );
  }
}

// ============================================================
// PREMIUM HOVER
// ============================================================

class PremiumHover extends StatefulWidget {
  final Widget child;

  const PremiumHover({
    super.key,
    required this.child,
  });

  @override
  State<PremiumHover> createState() =>
      _PremiumHoverState();
}

class _PremiumHoverState
    extends State<PremiumHover> {
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
      child: AnimatedScale(
        duration: const Duration(
          milliseconds: 190,
        ),
        curve: Curves.easeOutCubic,
        scale: hover ? 1.012 : 1,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 190,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(28),
            boxShadow: hover
                ? [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  0.055,
                ),
                blurRadius: 32,
                offset: const Offset(
                  0,
                  12,
                ),
              ),
            ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ============================================================
// HOVER IMAGE
// ============================================================

class HoverImage extends StatefulWidget {
  final String image;

  const HoverImage({
    super.key,
    required this.image,
  });

  @override
  State<HoverImage> createState() =>
      _HoverImageState();
}

class _HoverImageState
    extends State<HoverImage> {
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
      child: ClipRect(
        child: AnimatedScale(
          duration: const Duration(
            milliseconds: 450,
          ),
          curve: Curves.easeOutCubic,
          scale: hover ? 1.04 : 1,
          child: Image.asset(
            widget.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HERO IMAGE
// ============================================================

class AnimatedHeroImage extends StatelessWidget {
  final String image;

  const AnimatedHeroImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(
        seconds: 3,
      ),
      curve: Curves.easeOut,
      tween: Tween(
        begin: 1.045,
        end: 1,
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
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ============================================================
// STUDENT ORBIT HUB
// ============================================================

class OrbitHub extends StatefulWidget {
  final ValueChanged<String> onSelect;

  const OrbitHub({
    super.key,
    required this.onSelect,
  });

  @override
  State<OrbitHub> createState() =>
      _OrbitHubState();
}

class _OrbitHubState extends State<OrbitHub>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final List<OrbitItemData> items = const [
    OrbitItemData(
      'Timetable',
      Icons.calendar_today_outlined,
    ),
    OrbitItemData(
      'Courses',
      Icons.menu_book_outlined,
    ),
    OrbitItemData(
      'Library',
      Icons.local_library_outlined,
    ),
    OrbitItemData(
      'Campus',
      Icons.location_on_outlined,
    ),
    OrbitItemData(
      'Calendar',
      Icons.event_available_outlined,
    ),
    OrbitItemData(
      'Events',
      Icons.groups_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 30,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 400,
        child: AnimatedBuilder(
          animation: controller,
          builder: (
              context,
              child,
              ) {
            const center = 200.0;
            const radius = 140.0;
            const buttonSize = 80.0;

            return Stack(
              children: [
                Positioned(
                  left: 98,
                  top: 98,
                  child: Container(
                    width: 204,
                    height: 204,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(
                            0.045,
                          ),
                          blurRadius: 35,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/iitu_logo.png',
                          width: 98,
                        ),
                        const SizedBox(height: 13),
                        const Text(
                          'STUDENT HUB',
                          style: TextStyle(
                            color: iituRed,
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w600,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ...List.generate(
                  items.length,
                      (index) {
                    final angle =
                        (2 *
                            math.pi *
                            index /
                            items.length) +
                            controller.value *
                                2 *
                                math.pi;

                    final x = center +
                        math.cos(angle) *
                            radius -
                        buttonSize / 2;

                    final y = center +
                        math.sin(angle) *
                            radius -
                        buttonSize / 2;

                    return Positioned(
                      left: x,
                      top: y,
                      child: OrbitButton(
                        data: items[index],
                        onTap: () {
                          widget.onSelect(
                            items[index].label,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OrbitItemData {
  final String label;
  final IconData icon;

  const OrbitItemData(
      this.label,
      this.icon,
      );
}

class OrbitButton extends StatefulWidget {
  final OrbitItemData data;
  final VoidCallback onTap;

  const OrbitButton({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  State<OrbitButton> createState() =>
      _OrbitButtonState();
}

class _OrbitButtonState
    extends State<OrbitButton> {
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(
            milliseconds: 170,
          ),
          scale: hover ? 1.09 : 1,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
              hover ? iituRed : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: hover
                    ? iituRed
                    : borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.055,
                  ),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  widget.data.icon,
                  size: 20,
                  color: hover
                      ? Colors.white
                      : iituRed,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.data.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: hover
                        ? Colors.white
                        : darkText,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w500,
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
// NEW ANNOUNCEMENT ANIMATION
// ============================================================

enum AnnouncementVisualMode {
  partner,
  academic,
}

class AnnouncementMotionVisual
    extends StatefulWidget {
  final AnnouncementVisualMode mode;

  const AnnouncementMotionVisual({
    super.key,
    required this.mode,
  });

  @override
  State<AnnouncementMotionVisual> createState() =>
      _AnnouncementMotionVisualState();
}

class _AnnouncementMotionVisualState
    extends State<AnnouncementMotionVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 7,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (
          context,
          child,
          ) {
        if (widget.mode ==
            AnnouncementVisualMode.partner) {
          return _partnerVisual();
        }

        return _academicVisual();
      },
    );
  }

  Widget _partnerVisual() {
    final pulse =
        math.sin(controller.value *
            math.pi *
            2) *
            5;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end:
                    Alignment.bottomRight,
                    colors: [
                      Color(0xFFF0EFF3),
                      Color(0xFFF9F9FA),
                    ],
                  ),
                ),
              ),
            ),

            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(
                        0.05,
                      ),
                      blurRadius: 22,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/iitu_logo.png',
                    width: 58,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 22,
              top: 45 + pulse,
              child: const MiniVisualCard(
                icon: Icons.language_rounded,
                text: 'Global',
              ),
            ),

            Positioned(
              right: 20,
              top: 58 - pulse,
              child: const MiniVisualCard(
                icon:
                Icons.school_outlined,
                text: 'Partner',
              ),
            ),

            Positioned(
              left: 40,
              bottom: 28 - pulse,
              child: const MiniVisualCard(
                icon: Icons.flight_takeoff,
                text: 'Mobility',
              ),
            ),

            Positioned(
              right: 36,
              bottom: 24 + pulse,
              child: const MiniVisualCard(
                icon:
                Icons.workspace_premium_outlined,
                text: 'Degree',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _academicVisual() {
    final pulse =
        math.sin(controller.value *
            math.pi *
            2) *
            7;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF8F9),
                  Color(0xFFF1EFF2),
                ],
              ),
            ),
          ),
        ),

        Center(
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: iituRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iituRed.withOpacity(
                    0.20,
                  ),
                  blurRadius: 24,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'IITU',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),

        Align(
          alignment: Alignment(
            -0.72,
            -0.45 + pulse / 150,
          ),
          child: const NetworkBubble(
            icon: Icons.schedule,
            text: 'Schedule',
          ),
        ),

        Align(
          alignment: Alignment(
            0.72,
            -0.40 - pulse / 150,
          ),
          child: const NetworkBubble(
            icon: Icons.menu_book_outlined,
            text: 'Courses',
          ),
        ),

        Align(
          alignment: Alignment(
            -0.68,
            0.48 - pulse / 150,
          ),
          child: const NetworkBubble(
            icon:
            Icons.assignment_outlined,
            text: 'Semester',
          ),
        ),

        Align(
          alignment: Alignment(
            0.68,
            0.45 + pulse / 150,
          ),
          child: const NetworkBubble(
            icon:
            Icons.notifications_none,
            text: 'Updates',
          ),
        ),
      ],
    );
  }
}

class MiniVisualCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const MiniVisualCard({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.035),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iituRed,
          ),
          const SizedBox(width: 6),
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

class NetworkBubble extends StatelessWidget {
  final IconData icon;
  final String text;

  const NetworkBubble({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iituRed,
            size: 17,
          ),
          const SizedBox(height: 3),
          Text(
            text,
            style: const TextStyle(
              fontSize: 8,
              color: greyText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// CIRCULAR ARROW
// ============================================================

class CircularArrowButton
    extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircularArrowButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<CircularArrowButton> createState() =>
      _CircularArrowButtonState();
}

class _CircularArrowButtonState
    extends State<CircularArrowButton> {
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
        borderRadius: BorderRadius.circular(50),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color:
            hover ? iituRed : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: hover
                  ? iituRed
                  : borderColor,
            ),
          ),
          child: Icon(
            widget.icon,
            color:
            hover ? Colors.white : darkText,
            size: 18,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CAMPUS VISUAL CARD
// ============================================================

class CampusVisualCard
    extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final String? number;

  const CampusVisualCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.number,
  });

  @override
  State<CampusVisualCard> createState() =>
      _CampusVisualCardState();
}

class _CampusVisualCardState
    extends State<CampusVisualCard> {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              duration: const Duration(
                milliseconds: 450,
              ),
              curve: Curves.easeOutCubic,
              scale: hover ? 1.045 : 1,
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(
                      0.72,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  if (widget.number != null) ...[
                    Text(
                      widget.number!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 7),
                  ],

                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              right: 20,
              top: 20,
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: hover
                      ? Colors.white
                      : Colors.white.withOpacity(
                    0.86,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.north_east,
                  size: 17,
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
// GLOBE
// ============================================================

class AnimatedGlobe extends StatefulWidget {
  const AnimatedGlobe({
    super.key,
  });

  @override
  State<AnimatedGlobe> createState() =>
      _AnimatedGlobeState();
}

class _AnimatedGlobeState
    extends State<AnimatedGlobe>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (
          context,
          child,
          ) {
        final pulse =
            1 +
                0.12 *
                    math.sin(
                      controller.value *
                          math.pi *
                          4,
                    );

        return SizedBox(
          width: 305,
          height: 305,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 258,
                height: 258,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF174B68,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF70C7F0,
                      ).withOpacity(
                        0.16,
                      ),
                      blurRadius: 45,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),

              RotationTransition(
                turns: controller,
                child: const Icon(
                  Icons.public_rounded,
                  size: 224,
                  color: Color(
                    0xFF72A9C5,
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(
                  48,
                  -43,
                ),
                child: Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: BoxDecoration(
                      color: iituRed,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                          iituRed.withOpacity(
                            0.5,
                          ),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 1,
                top: 74,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      0.12,
                    ),
                    borderRadius:
                    BorderRadius.circular(20),
                    border: Border.all(
                      color:
                      Colors.white.withOpacity(
                        0.17,
                      ),
                    ),
                  ),
                  child: const Text(
                    'IITU · Kazakhstan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// PROFILE LINE
// ============================================================

class ProfileLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileLine({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: greyText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: greyText,
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}