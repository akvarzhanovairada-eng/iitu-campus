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

const Color iituRed = Color(0xFFB71930);
const Color iituDarkRed = Color(0xFF7D1020);

const Color darkText = Color(0xFF1B1C20);
const Color greyText = Color(0xFF73767D);

const Color pageBackground = Color(0xFFF8F8FA);
const Color softGrey = Color(0xFFF2F2F5);
const Color softRed = Color(0xFFFCECEF);
const Color borderColor = Color(0xFFE6E6EA);

const Color navy = Color(0xFF071D2C);
const Color navyLight = Color(0xFF123A52);

const Color successGreen = Color(0xFF268A5B);

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
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
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
            vertical: 17,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF9A9CA3),
            fontSize: 13,
          ),
          labelStyle: const TextStyle(
            color: greyText,
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
      home: const CampusPortal(),
    );
  }
}

// ============================================================
// MAIN PORTAL
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

  Timer? _eventTimer;

  ServiceRequestSummary? _lastServiceRequest;

  final List<CampusEvent> events = const [
    CampusEvent(
      title: 'Almaty Student Hackathon',
      category: 'Hackathon',
      date: '12 OCT',
      fullDate: '12 October 2026',
      time: '10:00 AM – 6:00 PM',
      location: 'Almaty',
      description:
      'Join students and young developers to build innovative digital solutions in teams.',
      longDescription:
      'The Almaty Student Hackathon brings together students from technology, design and business backgrounds. Participants work in teams, solve a real challenge, receive mentorship and present their final solution to a jury.',
      image: 'assets/images/event_hackathon.jpg',
      expectations: [
        'Team-based innovation challenge',
        'Mentoring from industry specialists',
        'Networking with students and companies',
        'Final project presentation',
      ],
    ),
    CampusEvent(
      title: 'Cybersecurity Workshop',
      category: 'Workshop',
      date: '18 OCT',
      fullDate: '18 October 2026',
      time: '2:00 PM – 5:00 PM',
      location: 'IITU Campus',
      description:
      'A practical workshop focused on cybersecurity, networks and modern digital security tools.',
      longDescription:
      'This workshop introduces practical cybersecurity scenarios and tools. Students will work with network-security concepts, analyze common risks and discuss how modern systems can be protected.',
      image: 'assets/images/event_cybersecurity.jpg',
      expectations: [
        'Practical cybersecurity exercises',
        'Network-security demonstrations',
        'Discussion of real security risks',
        'Q&A with the workshop team',
      ],
    ),
    CampusEvent(
      title: 'Career & Internship Fair',
      category: 'Career',
      date: '24 OCT',
      fullDate: '24 October 2026',
      time: '11:00 AM – 4:00 PM',
      location: 'IITU Main Hall',
      description:
      'Meet companies and explore internships, projects and future career opportunities.',
      longDescription:
      'The Career & Internship Fair connects IITU students with employers, internship programmes and graduate opportunities. Students can learn about companies, ask questions and build professional connections.',
      image: 'assets/images/event_career.jpg',
      expectations: [
        'Meet recruiters and company representatives',
        'Explore internships and graduate roles',
        'Ask questions about career pathways',
        'Build professional connections',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();

    _eventTimer = Timer.periodic(
      const Duration(seconds: 7),
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
        content: Text(message),
        backgroundColor: darkText,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _openEvent(CampusEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EventDetailsPage(
          event: event,
        ),
      ),
    );
  }

  void _showLastRequest() {
    final request = _lastServiceRequest;

    if (request == null) {
      _showMessage(
        'You do not have a submitted service request yet.',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          title: const Text(
            'Latest Request',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          content: SizedBox(
            width: 430,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow(
                  'Reference',
                  request.reference,
                ),
                _summaryRow(
                  'Issue',
                  request.category,
                ),
                _summaryRow(
                  'Urgency',
                  request.urgency,
                ),
                _summaryRow(
                  'Contact',
                  request.contactMethod,
                ),
                _summaryRow(
                  'Preferred date',
                  request.preferredDate,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        color: successGreen,
                        size: 19,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Status: Submitted',
                        style: TextStyle(
                          color: successGreen,
                          fontWeight: FontWeight.w600,
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
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryRow(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 13,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: greyText,
                fontSize: 11.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final desktop = width >= 920;

    return Scaffold(
      appBar: _buildAppBar(desktop),

      drawer: desktop ? null : _buildDrawer(),

      body: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 350,
          ),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: KeyedSubtree(
            key: ValueKey(_pageIndex),
            child: _currentPage(),
          ),
        ),
      ),

      bottomNavigationBar: desktop
          ? null
          : BottomNavigationBar(
        currentIndex: _pageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: iituRed,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
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
              Icons.support_agent_outlined,
            ),
            activeIcon: Icon(
              Icons.support_agent_rounded,
            ),
            label: 'Services',
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
        return StudentServicesPage(
          lastRequest: _lastServiceRequest,
          onSubmitted: (request) {
            setState(() {
              _lastServiceRequest = request;
            });
          },
        );

      case 4:
        return _profilePage();

      default:
        return _homePage();
    }
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar(
      bool desktop,
      ) {
    return AppBar(
      automaticallyImplyLeading: !desktop,
      toolbarHeight: desktop ? 78 : 68,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: darkText,
      elevation: 0,

      title: Row(
        children: [
          SizedBox(
            width: desktop ? 145 : 112,
            height: 43,
            child: AppImage(
              path: 'assets/images/iitu_logo.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),

          if (desktop) ...[
            const SizedBox(width: 42),

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
              label: 'Services',
              active: _pageIndex == 3,
              onTap: () => _changePage(3),
            ),

            HeaderNavButton(
              label: 'Profile',
              active: _pageIndex == 4,
              onTap: () => _changePage(4),
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
          onTap: () => _changePage(4),
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
                  radius: 30,
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
                  'Network Security • 3rd Year',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          _drawerItem(
            Icons.home_outlined,
            'Home',
            0,
          ),

          _drawerItem(
            Icons.event_outlined,
            'Events',
            1,
          ),

          _drawerItem(
            Icons.map_outlined,
            'Campus Map',
            2,
          ),

          _drawerItem(
            Icons.support_agent_outlined,
            'Student Services',
            3,
          ),

          _drawerItem(
            Icons.person_outline,
            'My Profile',
            4,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      IconData icon,
      String title,
      int page,
      ) {
    return ListTile(
      leading: Icon(
        icon,
        color: iituRed,
      ),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _changePage(page);
      },
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
                const SizedBox(height: 58),

                SimpleReveal(
                  delay: 60,
                  child: _homeAcademicStrip(),
                ),

                const SizedBox(height: 105),

                SimpleReveal(
                  delay: 120,
                  child: _studentHubSection(),
                ),

                const SizedBox(height: 115),

                SimpleReveal(
                  delay: 180,
                  child: StudentSupportPromo(
                    hasRequest:
                    _lastServiceRequest != null,
                    onOpenServices: () {
                      _changePage(3);
                    },
                    onOpenStatus: _showLastRequest,
                  ),
                ),

                const SizedBox(height: 115),

                SimpleReveal(
                  delay: 240,
                  child: _announcementSection(),
                ),

                const SizedBox(height: 115),

                SimpleReveal(
                  delay: 300,
                  child: _eventsShowcase(),
                ),

                const SizedBox(height: 115),

                SimpleReveal(
                  delay: 360,
                  child: _campusLifeSection(),
                ),

                const SizedBox(height: 115),

                SimpleReveal(
                  delay: 420,
                  child: _globalFooter(),
                ),

                const SizedBox(height: 30),

                const Text(
                  'IITU Campus • Student Portal Concept • 2026',
                  style: TextStyle(
                    color: greyText,
                    fontSize: 10.5,
                  ),
                ),

                const SizedBox(height: 42),
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
                _heroText(
                  mobile: true,
                ),
                SizedBox(
                  height: 330,
                  width: double.infinity,
                  child: AnimatedHeroImage(
                    image:
                    'assets/images/hero_campus.png',
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 625,
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
                      Colors.white.withOpacity(0.99),
                      Colors.white.withOpacity(0.82),
                      Colors.white.withOpacity(0.15),
                    ],
                    stops: const [
                      0,
                      0.30,
                      0.59,
                      1,
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 700,
                  child: _heroText(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _heroText({
    bool mobile = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 25 : 52,
        vertical: mobile ? 48 : 55,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RevealAfterDelay(
            delay: 60,
            child: Container(
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
                  Flexible(
                    child: Text(
                      'INTERNATIONAL INFORMATION TECHNOLOGY UNIVERSITY',
                      style: TextStyle(
                        color: iituRed,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 29),

          RevealAfterDelay(
            delay: 160,
            child: Text(
              'Your Campus.\nYour Future.\nYour IITU.',
              style: TextStyle(
                color: darkText,
                fontSize: mobile ? 43 : 59,
                height: 1.03,
                letterSpacing: mobile ? -1.8 : -2.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 23),

          RevealAfterDelay(
            delay: 260,
            child: SizedBox(
              width: 520,
              child: Text(
                'A smarter way to explore academic life, student services, events and opportunities at IITU.',
                style: TextStyle(
                  color: const Color(
                    0xFF60636A,
                  ),
                  fontSize: mobile ? 14 : 16.5,
                  height: 1.65,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          const SizedBox(height: 31),

          RevealAfterDelay(
            delay: 360,
            child: ElevatedButton.icon(
              onPressed: () {
                _changePage(2);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: iituRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 17,
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
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACADEMIC STRIP
  // ============================================================

  Widget _homeAcademicStrip() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 29,
        vertical: 25,
      ),

      // Explicit Container alignment for the Container assignment.
      alignment: Alignment.centerLeft,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.024),
            blurRadius: 25,
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
              constraints.maxWidth >= 820;

          final greeting = const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Irada.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.7,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Here’s your academic overview for today.',
                style: TextStyle(
                  color: greyText,
                  fontSize: 12.5,
                ),
              ),
            ],
          );

          const indicators = Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              CompactAcademicValue(
                label: 'SEMESTER',
                value: '5',
              ),
              CompactAcademicValue(
                label: 'GPA',
                value: '3.5',
              ),
              CompactAcademicValue(
                label: 'CREDITS',
                value: '90',
              ),
              CompactAcademicValue(
                label: 'ATTENDANCE',
                value: '92%',
              ),
            ],
          );

          if (!desktop) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                greeting,
                const SizedBox(height: 25),
                indicators,
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: greeting,
              ),
              const SizedBox(width: 30),
              indicators,
            ],
          );
        },
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
          'Access university tools and manage your day without leaving the portal.',
        ),

        const SizedBox(height: 42),

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
                if (value == 'Campus') {
                  _changePage(2);
                } else if (value == 'Events') {
                  _changePage(1);
                } else if (value == 'Services') {
                  _changePage(3);
                } else if (value == 'Calendar') {
                  _showMessage(
                    'Calendar selected.',
                  );
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
                const SizedBox(width: 62),
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
      padding: const EdgeInsets.all(29),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 28,
            offset: const Offset(0, 12),
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
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tuesday',
                    style: TextStyle(
                      fontSize: 23,
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

          const SizedBox(height: 25),

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

          const SizedBox(height: 6),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _changePage(3);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: iituRed,
                side: const BorderSide(
                  color: Color(0xFFEAC1C8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              icon: const Icon(
                Icons.support_agent_outlined,
                size: 17,
              ),
              label: const Text(
                'Need help?',
              ),
            ),
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
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            width: 3,
            height: 38,
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
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  room,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 10.5,
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
  // ANNOUNCEMENTS
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
              cardWidth =
                  constraints.maxWidth;
            }

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                SizedBox(
                  width: cardWidth,
                  child:
                  _doubleDegreeAnnouncement(),
                ),
                SizedBox(
                  width: cardWidth,
                  child:
                  _hackathonAnnouncement(),
                ),
                SizedBox(
                  width: cardWidth,
                  child:
                  _academicAnnouncement(),
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
        height: 420,
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
                mode:
                AnnouncementVisualMode.partner,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                24,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INTERNATIONAL',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Double Degree Programs',
                    style: TextStyle(
                      fontSize: 21,
                      height: 1.12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover academic pathways with international partner universities.',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 12,
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
                      size: 15,
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
      child: InkWell(
        borderRadius:
        BorderRadius.circular(28),
        onTap: () {
          _openEvent(events[0]);
        },
        child: Container(
          height: 420,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(28),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 235,
                width: double.infinity,
                child: HoverImage(
                  image:
                  'assets/images/event_hackathon.jpg',
                ),
              ),

              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.all(23),
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
                              fontSize: 9,
                              letterSpacing: 1,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'HACKATHON',
                            style: TextStyle(
                              color: greyText,
                              fontSize: 8.5,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      const Text(
                        'Almaty Student Hackathon',
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.12,
                          fontWeight:
                          FontWeight.w600,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const Spacer(),
                      const Row(
                        children: [
                          Text(
                            'View event',
                            style: TextStyle(
                              color: greyText,
                              fontSize: 11,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.north_east,
                            size: 16,
                            color: iituRed,
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
      ),
    );
  }

  Widget _academicAnnouncement() {
    return PremiumHover(
      child: Container(
        height: 420,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFAFB),
              Color(0xFFF3F2F4),
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
                mode:
                AnnouncementVisualMode.academic,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                0,
                24,
                24,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ACADEMIC',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Semester Updates',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Courses, schedules and key academic information in one place.',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 12,
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
                      size: 15,
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
  // EVENTS HOME SECTION
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

        AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 420,
          ),
          child: _largeEventCard(
            event,
            key: ValueKey(_eventIndex),
          ),
        ),

        const SizedBox(height: 17),

        Row(
          children: [
            Expanded(
              child: _eventDots(),
            ),
            TextButton.icon(
              onPressed: () {
                _changePage(1);
              },
              style: TextButton.styleFrom(
                foregroundColor: iituRed,
              ),
              label: const Text(
                'View all events',
              ),
              icon: const Icon(
                Icons.arrow_forward,
                size: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _largeEventCard(
      CampusEvent event, {
        Key? key,
      }) {
    return PremiumHover(
      key: key,
      child: InkWell(
        borderRadius:
        BorderRadius.circular(30),
        onTap: () {
          _openEvent(event);
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(30),
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
                  constraints.maxWidth >= 720;

              final image = SizedBox(
                width: horizontal
                    ? constraints.maxWidth *
                    0.50
                    : double.infinity,
                height: horizontal ? 380 : 250,
                child: HoverImage(
                  image: event.image,
                ),
              );

              final info = Padding(
                padding:
                const EdgeInsets.all(31),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: softRed,
                        borderRadius:
                        BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: Text(
                        event.date,
                        style: const TextStyle(
                          color: iituRed,
                          fontSize: 9.5,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 19),

                    Text(
                      event.category.toUpperCase(),
                      style: const TextStyle(
                        color: iituRed,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.1,
                      ),
                    ),

                    const SizedBox(height: 9),

                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 29,
                        height: 1.08,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      event.description,
                      style: const TextStyle(
                        color: greyText,
                        fontSize: 12.5,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 21),

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

                    const SizedBox(height: 25),

                    ElevatedButton.icon(
                      onPressed: () {
                        _openEvent(event);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: iituRed,
                        foregroundColor:
                        Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 16,
                      ),
                      label: const Text(
                        'View Event',
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
              borderRadius:
              BorderRadius.circular(20),
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
            fontSize: 11,
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
              height: 495,
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

        const SizedBox(height: 20),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              _changePage(2);
            },
            style: TextButton.styleFrom(
              foregroundColor: iituRed,
            ),
            label: const Text(
              'Explore campus',
            ),
            icon: const Icon(
              Icons.arrow_forward,
              size: 15,
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
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Grow beyond\nborders with IITU.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 39,
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
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
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
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 15,
                    ),
                  ),
                  icon: const Icon(
                    Icons.north_east,
                    size: 16,
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
                  height: 310,
                  child: Center(
                    child: AnimatedGlobe(),
                  ),
                ),
              ],
            );
          }

          return SizedBox(
            height: 415,
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
        100,
      ),
      child: _maxWidth(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
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
                      (constraints.maxWidth - 36) /
                          3;
                } else if (constraints.maxWidth >=
                    650) {
                  cardWidth =
                      (constraints.maxWidth - 18) /
                          2;
                } else {
                  cardWidth =
                      constraints.maxWidth;
                }

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: events.map(
                        (event) {
                      return SizedBox(
                        width: cardWidth,
                        child: EventPageCard(
                          event: event,
                          onTap: () {
                            _openEvent(event);
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
        100,
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
                        milliseconds: 190,
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
                          fontSize: 11.5,
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
                          fontSize: 11.5,
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
                      fontSize: 10.5,
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
                                fontSize: 12.5,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              selected.description,
                              style: const TextStyle(
                                color: greyText,
                                fontSize: 10.5,
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
            icon:
            Icons.co_present_outlined,
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
  // PROFILE
  // ============================================================

  Widget _profilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        24,
        60,
        24,
        100,
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
              'Personal information, academic progress and student activity in one place.',
            ),

            const SizedBox(height: 38),

            LayoutBuilder(
              builder: (
                  context,
                  constraints,
                  ) {
                final desktop =
                    constraints.maxWidth >= 900;

                if (!desktop) {
                  return Column(
                    children: [
                      _profileCard(),
                      const SizedBox(height: 28),
                      _profileAcademicSection(),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 335,
                      child: _profileCard(),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child:
                      _profileAcademicSection(),
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
            height: 112,
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
            offset: const Offset(0, -55),
            child: const CircleAvatar(
              radius: 59,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 53,
                backgroundImage: AssetImage(
                  'assets/images/profile_irada.png',
                ),
              ),
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -40),
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
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Network Security',
                    style: TextStyle(
                      color: iituRed,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '3rd Year · Student ID 41151',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 11,
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

  Widget _profileAcademicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
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
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Current progress',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'A quick summary of your academic performance this semester.',
                style: TextStyle(
                  color: greyText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 27),

              LayoutBuilder(
                builder: (
                    context,
                    constraints,
                    ) {
                  final desktop =
                      constraints.maxWidth >= 650;

                  final width = desktop
                      ? (constraints.maxWidth - 36) /
                      4
                      : (constraints.maxWidth - 12) /
                      2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: width,
                        child:
                        const AcademicMetricCard(
                          icon:
                          Icons.calendar_month_outlined,
                          label: 'SEMESTER',
                          value: '5',
                          caption: 'Current',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:
                        const AcademicMetricCard(
                          icon:
                          Icons.trending_up_rounded,
                          label: 'GPA',
                          value: '3.5',
                          caption: 'Good standing',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:
                        const AcademicMetricCard(
                          icon:
                          Icons.school_outlined,
                          label: 'CREDITS',
                          value: '90',
                          caption: 'Completed',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child:
                        const AcademicMetricCard(
                          icon:
                          Icons.check_circle_outline,
                          label: 'ATTENDANCE',
                          value: '92%',
                          caption: 'On track',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'Academic Records',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 15),

        _academicRecords(),
      ],
    );
  }

  Widget _academicRecords() {
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
                      height: 126,
                      padding:
                      const EdgeInsets.all(21),
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
                            width: 49,
                            height: 49,
                            alignment:
                            Alignment.center,
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
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    color: greyText,
                                    fontSize: 10.5,
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
// STUDENT SERVICES FORM PAGE
// ============================================================

class StudentServicesPage extends StatefulWidget {
  final ServiceRequestSummary? lastRequest;
  final ValueChanged<ServiceRequestSummary>
  onSubmitted;

  const StudentServicesPage({
    super.key,
    required this.lastRequest,
    required this.onSubmitted,
  });

  @override
  State<StudentServicesPage> createState() =>
      _StudentServicesPageState();
}

class _StudentServicesPageState
    extends State<StudentServicesPage> {
  // Form key gives access to validate(), save() and reset().
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController(
    text: 'Akvarzhanova Irada',
  );

  final TextEditingController _idController =
  TextEditingController(
    text: '41151',
  );

  final TextEditingController _emailController =
  TextEditingController(
    text: 'irada41151@student.iitu.kz',
  );

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _subjectController =
  TextEditingController();

  final TextEditingController _detailsController =
  TextEditingController();

  final TextEditingController _otherController =
  TextEditingController();

  final List<String> _categories = const [
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

  String? _category;
  String? _urgency;
  String? _contactMethod;
  DateTime? _preferredDate;

  bool _declaration = false;

  // Saved values are written only after the complete form is valid.
  String _savedName = '';
  String _savedId = '';
  String _savedEmail = '';
  String _savedSubject = '';
  String _savedDetails = '';

  @override
  void initState() {
    super.initState();

    // Listeners keep the animated completion progress live.
    _nameController.addListener(_refreshProgress);
    _idController.addListener(_refreshProgress);
    _emailController.addListener(_refreshProgress);
    _phoneController.addListener(_refreshProgress);
    _subjectController.addListener(_refreshProgress);
    _detailsController.addListener(_refreshProgress);
    _otherController.addListener(_refreshProgress);
  }

  @override
  void dispose() {
    // Required controller cleanup.
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _detailsController.dispose();
    _otherController.dispose();

    super.dispose();
  }

  void _refreshProgress() {
    if (mounted) {
      setState(() {});
    }
  }

  double get _completion {
    int total = 10;
    int completed = 0;

    if (_nameController.text.trim().isNotEmpty) {
      completed++;
    }

    if (_idController.text.trim().length >= 5) {
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

  String _dateText(
      DateTime? date,
      ) {
    if (date == null) {
      return 'Select date';
    }

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

  Future<void> _selectDate(
      FormFieldState<DateTime> field,
      ) async {
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      _preferredDate ?? today,
      firstDate: DateTime(
        today.year,
        today.month,
        today.day,
      ),
      lastDate: DateTime(
        today.year + 2,
      ),
      helpText:
      'Select preferred response date',
    );

    if (picked != null) {
      setState(() {
        _preferredDate = picked;
      });

      field.didChange(picked);
    }
  }

  String _createReference() {
    final number =
        DateTime.now().millisecondsSinceEpoch %
            1000000;

    return 'IITU-SR-${number.toString().padLeft(6, '0')}';
  }

  Future<void> _submitForm() async {
    // Validation happens before save.
    final valid =
        _formKey.currentState?.validate() ??
            false;

    if (!valid) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: const Text(
            'Please check the highlighted fields.',
          ),
          backgroundColor: iituRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
      );

      return;
    }

    // save() runs only after all validators pass.
    _formKey.currentState!.save();

    final category = _category == 'Other'
        ? 'Other: ${_otherController.text.trim()}'
        : _category!;

    final request =
    ServiceRequestSummary(
      reference: _createReference(),
      studentName: _savedName,
      studentId: _savedId,
      email: _savedEmail,
      category: category,
      subject: _savedSubject,
      details: _savedDetails,
      urgency: _urgency!,
      contactMethod: _contactMethod!,
      preferredDate:
      _dateText(_preferredDate),
    );

    widget.onSubmitted(request);

    await _showSuccessDialog(request);
  }

  Future<void> _showSuccessDialog(
      ServiceRequestSummary request,
      ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Request submitted',
      barrierColor: Colors.black.withOpacity(
        0.35,
      ),
      transitionDuration:
      const Duration(milliseconds: 300),
      pageBuilder: (
          context,
          animation,
          secondaryAnimation,
          ) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 480,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.12,
                    ),
                    blurRadius: 40,
                    offset: const Offset(
                      0,
                      20,
                    ),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(
                      milliseconds: 450,
                    ),
                    curve: Curves.elasticOut,
                    tween: Tween(
                      begin: 0.4,
                      end: 1,
                    ),
                    builder: (
                        context,
                        value,
                        child,
                        ) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration:
                      const BoxDecoration(
                        color: Color(0xFFEAF7F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: successGreen,
                        size: 37,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Request submitted',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.7,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Your request was successfully created.',
                    style: TextStyle(
                      color: greyText,
                      fontSize: 12.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF7F7F9,
                      ),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _dialogRow(
                          'Reference',
                          request.reference,
                        ),
                        _dialogRow(
                          'Issue',
                          request.category,
                        ),
                        _dialogRow(
                          'Urgency',
                          request.urgency,
                        ),
                        _dialogRow(
                          'Contact',
                          request.contactMethod,
                        ),
                        _dialogRow(
                          'Preferred date',
                          request.preferredDate,
                          last: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style:
                      ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: iituRed,
                        foregroundColor:
                        Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Done',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.94,
              end: 1,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _dialogRow(
      String label,
      String value, {
        bool last = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: last ? 0 : 13,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 115,
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
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    // reset() clears FormField validation states.
    _formKey.currentState?.reset();

    // Controllers and non-Form state are reset as well.
    _nameController.text =
    'Akvarzhanova Irada';
    _idController.text = '41151';
    _emailController.text =
    'irada41151@student.iitu.kz';

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
    });

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: const Text(
          'The request form has been reset.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkText,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percent =
    (_completion * 100).round();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        24,
        58,
        24,
        100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1050,
          ),
          child: Form(
            key: _formKey,

            // Errors appear after the user interacts with a field.
            autovalidateMode:
            AutovalidateMode
                .onUserInteraction,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const PremiumHeading(
                  eyebrow: 'STUDENT SERVICES',
                  title: 'How can we help?',
                  subtitle:
                  'Submit a campus service request and the appropriate IITU team can review your information.',
                ),

                const SizedBox(height: 32),

                // Advanced customization: animated completion progress.
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(24),
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
                              fontSize: 12.5,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              color: iituRed,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: _completion,
                        ),
                        duration: const Duration(
                          milliseconds: 350,
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (
                            context,
                            value,
                            child,
                            ) {
                          return ClipRRect(
                            borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                            child:
                            LinearProgressIndicator(
                              value: value,
                              minHeight: 7,
                              backgroundColor:
                              softGrey,
                              color: iituRed,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                FormSectionCard(
                  number: '01',
                  title: 'Student details',
                  subtitle:
                  'Tell us who is submitting the request.',
                  child: LayoutBuilder(
                    builder: (
                        context,
                        constraints,
                        ) {
                      final desktop =
                          constraints.maxWidth >=
                              700;

                      final width = desktop
                          ? (constraints.maxWidth -
                          16) /
                          2
                          : constraints.maxWidth;

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: width,
                            child: TextFormField(
                              controller:
                              _nameController,
                              textInputAction:
                              TextInputAction.next,
                              decoration:
                              const InputDecoration(
                                labelText:
                                'Full name',
                                hintText:
                                'First and last name',
                                prefixIcon: Icon(
                                  Icons
                                      .person_outline,
                                ),
                              ),
                              validator: (value) {
                                final text =
                                    value?.trim() ??
                                        '';

                                if (text.isEmpty) {
                                  return 'Please enter your full name.';
                                }

                                if (!text.contains(
                                  ' ',
                                )) {
                                  return 'Please enter at least two names.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _savedName =
                                    value!.trim();
                              },
                            ),
                          ),

                          SizedBox(
                            width: width,
                            child: TextFormField(
                              controller:
                              _idController,
                              textInputAction:
                              TextInputAction.next,
                              decoration:
                              const InputDecoration(
                                labelText:
                                'Student ID',
                                hintText: '41151',
                                prefixIcon: Icon(
                                  Icons
                                      .badge_outlined,
                                ),
                              ),
                              validator: (value) {
                                final text =
                                    value?.trim() ??
                                        '';

                                if (text.isEmpty) {
                                  return 'Please enter your Student ID.';
                                }

                                if (text.length < 5) {
                                  return 'Student ID must contain at least 5 characters.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _savedId =
                                    value!.trim();
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
                                hintText:
                                'name@student.iitu.kz',
                                prefixIcon: Icon(
                                  Icons
                                      .email_outlined,
                                ),
                              ),
                              validator: (value) {
                                final email =
                                    value?.trim() ??
                                        '';

                                final emailRegex =
                                RegExp(
                                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                );

                                if (email.isEmpty) {
                                  return 'Please enter your campus email.';
                                }

                                if (!emailRegex
                                    .hasMatch(
                                  email,
                                )) {
                                  return 'Enter a valid email address.';
                                }

                                if (!email.endsWith(
                                  '@student.iitu.kz',
                                )) {
                                  return 'Use your @student.iitu.kz email.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _savedEmail =
                                    value!.trim();
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
                              textInputAction:
                              TextInputAction.next,
                              decoration:
                              const InputDecoration(
                                labelText:
                                'Phone number',
                                hintText:
                                '+7 700 000 00 00',
                                prefixIcon: Icon(
                                  Icons
                                      .phone_outlined,
                                ),
                              ),
                              validator: (value) {
                                final phone =
                                    value?.trim() ??
                                        '';

                                if (phone.isEmpty) {
                                  return null;
                                }

                                final phoneRegex =
                                RegExp(
                                  r'^\+?[0-9\s\-]{7,18}$',
                                );

                                if (!phoneRegex
                                    .hasMatch(
                                  phone,
                                )) {
                                  return 'Enter a valid phone number.';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 22),

                FormSectionCard(
                  number: '02',
                  title: 'What do you need help with?',
                  subtitle:
                  'Choose the campus service that best matches your issue.',
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
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
                        hint: const Text(
                          'Select a problem',
                        ),
                        items: _categories
                            .map(
                              (
                              category,
                              ) =>
                              DropdownMenuItem<
                                  String>(
                                value: category,
                                child: Text(
                                  category,
                                ),
                              ),
                        )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _category = value;

                            if (value !=
                                'Other') {
                              _otherController
                                  .clear();
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a service category.';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          IssueQuickChip(
                            label:
                            'Wi-Fi / Internet',
                            selected:
                            _category ==
                                'Wi-Fi / Internet',
                            onTap: () {
                              setState(() {
                                _category =
                                'Wi-Fi / Internet';
                                _otherController
                                    .clear();
                              });
                            },
                          ),
                          IssueQuickChip(
                            label:
                            'Lost Student ID Card',
                            selected:
                            _category ==
                                'Lost Student ID Card',
                            onTap: () {
                              setState(() {
                                _category =
                                'Lost Student ID Card';
                                _otherController
                                    .clear();
                              });
                            },
                          ),
                          IssueQuickChip(
                            label:
                            'Academic Documents',
                            selected:
                            _category ==
                                'Academic Documents',
                            onTap: () {
                              setState(() {
                                _category =
                                'Academic Documents';
                                _otherController
                                    .clear();
                              });
                            },
                          ),
                          IssueQuickChip(
                            label: 'Other',
                            selected:
                            _category ==
                                'Other',
                            onTap: () {
                              setState(() {
                                _category =
                                'Other';
                              });
                            },
                          ),
                        ],
                      ),

                      // Advanced customization:
                      // the extra field appears only for "Other".
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 260,
                        ),
                        transitionBuilder: (
                            child,
                            animation,
                            ) {
                          return FadeTransition(
                            opacity: animation,
                            child:
                            SizeTransition(
                              sizeFactor:
                              animation,
                              child: child,
                            ),
                          );
                        },
                        child: _category == 'Other'
                            ? Padding(
                          key: const ValueKey(
                            'other-field',
                          ),
                          padding:
                          const EdgeInsets
                              .only(
                            top: 18,
                          ),
                          child:
                          TextFormField(
                            controller:
                            _otherController,
                            maxLength: 180,
                            maxLines: 3,
                            decoration:
                            const InputDecoration(
                              labelText:
                              'Tell us what happened',
                              hintText:
                              'Describe the issue that is not listed above...',
                              alignLabelWithHint:
                              true,
                            ),
                            validator:
                                (value) {
                              if (_category !=
                                  'Other') {
                                return null;
                              }

                              final text =
                                  value?.trim() ??
                                      '';

                              if (text.length <
                                  10) {
                                return 'Please describe the issue in at least 10 characters.';
                              }

                              return null;
                            },
                          ),
                        )
                            : const SizedBox
                            .shrink(
                          key: ValueKey(
                            'no-other-field',
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        controller:
                        _subjectController,
                        textInputAction:
                        TextInputAction.next,
                        decoration:
                        const InputDecoration(
                          labelText:
                          'Request subject',
                          hintText:
                          'Briefly describe your request',
                          prefixIcon: Icon(
                            Icons
                                .short_text_rounded,
                          ),
                        ),
                        validator: (value) {
                          final text =
                              value?.trim() ??
                                  '';

                          if (text.isEmpty) {
                            return 'Please enter a request subject.';
                          }

                          if (text.length < 5) {
                            return 'Use at least 5 characters.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _savedSubject =
                              value!.trim();
                        },
                      ),

                      const SizedBox(height: 18),

                      // Advanced customization:
                      // live 0/300 counter and maximum length.
                      TextFormField(
                        controller:
                        _detailsController,
                        maxLines: 6,
                        maxLength: 300,
                        keyboardType:
                        TextInputType.multiline,
                        textInputAction:
                        TextInputAction.newline,
                        decoration:
                        const InputDecoration(
                          labelText:
                          'Request details',
                          hintText:
                          'Explain what happened and what kind of help you need...',
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding:
                            EdgeInsets.only(
                              bottom: 92,
                            ),
                            child: Icon(
                              Icons
                                  .description_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final text =
                              value?.trim() ??
                                  '';

                          if (text.isEmpty) {
                            return 'Please describe your request.';
                          }

                          if (text.length < 20) {
                            return 'Please provide at least 20 characters.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _savedDetails =
                              value!.trim();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                FormSectionCard(
                  number: '03',
                  title: 'Request preferences',
                  subtitle:
                  'Tell us how urgent the request is and how you prefer to be contacted.',
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const FormMiniTitle(
                        title: 'Urgency',
                        subtitle:
                        'Choose one level.',
                      ),

                      const SizedBox(height: 12),

                      FormField<String>(
                        initialValue: _urgency,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an urgency level.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _urgency = value;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  SelectionChip(
                                    label:
                                    'Normal',
                                    icon: Icons
                                        .schedule_outlined,
                                    selected:
                                    _urgency ==
                                        'Normal',
                                    onTap: () {
                                      setState(() {
                                        _urgency =
                                        'Normal';
                                      });

                                      field.didChange(
                                        'Normal',
                                      );
                                    },
                                  ),
                                  SelectionChip(
                                    label: 'Soon',
                                    icon: Icons
                                        .update_rounded,
                                    selected:
                                    _urgency ==
                                        'Soon',
                                    onTap: () {
                                      setState(() {
                                        _urgency =
                                        'Soon';
                                      });

                                      field.didChange(
                                        'Soon',
                                      );
                                    },
                                  ),
                                  SelectionChip(
                                    label:
                                    'Urgent',
                                    icon: Icons
                                        .priority_high_rounded,
                                    selected:
                                    _urgency ==
                                        'Urgent',
                                    onTap: () {
                                      setState(() {
                                        _urgency =
                                        'Urgent';
                                      });

                                      field.didChange(
                                        'Urgent',
                                      );
                                    },
                                  ),
                                ],
                              ),

                              if (field.hasError)
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    top: 8,
                                    left: 12,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style:
                                    const TextStyle(
                                      color: iituRed,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      const Divider(),

                      const SizedBox(height: 22),

                      const FormMiniTitle(
                        title:
                        'Preferred contact',
                        subtitle:
                        'How should the university contact you?',
                      ),

                      const SizedBox(height: 12),

                      FormField<String>(
                        initialValue:
                        _contactMethod,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a contact method.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _contactMethod = value;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  SelectionChip(
                                    label: 'Email',
                                    icon: Icons
                                        .email_outlined,
                                    selected:
                                    _contactMethod ==
                                        'Email',
                                    onTap: () {
                                      setState(() {
                                        _contactMethod =
                                        'Email';
                                      });

                                      field.didChange(
                                        'Email',
                                      );
                                    },
                                  ),
                                  SelectionChip(
                                    label: 'Phone',
                                    icon: Icons
                                        .phone_outlined,
                                    selected:
                                    _contactMethod ==
                                        'Phone',
                                    onTap: () {
                                      setState(() {
                                        _contactMethod =
                                        'Phone';
                                      });

                                      field.didChange(
                                        'Phone',
                                      );
                                    },
                                  ),
                                  SelectionChip(
                                    label:
                                    'Campus meeting',
                                    icon: Icons
                                        .groups_outlined,
                                    selected:
                                    _contactMethod ==
                                        'Campus meeting',
                                    onTap: () {
                                      setState(() {
                                        _contactMethod =
                                        'Campus meeting';
                                      });

                                      field.didChange(
                                        'Campus meeting',
                                      );
                                    },
                                  ),
                                ],
                              ),

                              if (field.hasError)
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    top: 8,
                                    left: 12,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style:
                                    const TextStyle(
                                      color: iituRed,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 25),

                      const Divider(),

                      const SizedBox(height: 22),

                      const FormMiniTitle(
                        title:
                        'Preferred response date',
                        subtitle:
                        'Choose a date that is not in the past.',
                      ),

                      const SizedBox(height: 12),

                      FormField<DateTime>(
                        initialValue:
                        _preferredDate,
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a preferred response date.';
                          }

                          final today =
                          DateTime.now();

                          final startToday =
                          DateTime(
                            today.year,
                            today.month,
                            today.day,
                          );

                          final selected =
                          DateTime(
                            value.year,
                            value.month,
                            value.day,
                          );

                          if (selected.isBefore(
                            startToday,
                          )) {
                            return 'The response date cannot be in the past.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _preferredDate =
                              value;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  17,
                                ),
                                onTap: () {
                                  _selectDate(
                                    field,
                                  );
                                },
                                child: Container(
                                  width:
                                  double.infinity,
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 18,
                                    vertical: 17,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    const Color(
                                      0xFFF5F5F7,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      17,
                                    ),
                                    border:
                                    Border.all(
                                      color:
                                      field.hasError
                                          ? iituRed
                                          : borderColor,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons
                                            .calendar_month_outlined,
                                        color:
                                        greyText,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          _dateText(
                                            _preferredDate,
                                          ),
                                          style:
                                          TextStyle(
                                            color:
                                            _preferredDate ==
                                                null
                                                ? greyText
                                                : darkText,
                                            fontSize:
                                            13,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons
                                            .keyboard_arrow_down_rounded,
                                        color:
                                        greyText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              if (field.hasError)
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    top: 8,
                                    left: 12,
                                  ),
                                  child: Text(
                                    field.errorText!,
                                    style:
                                    const TextStyle(
                                      color: iituRed,
                                      fontSize: 11,
                                    ),
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

                FormSectionCard(
                  number: '04',
                  title: 'Confirmation',
                  subtitle:
                  'Check your information before submitting the request.',
                  child: FormField<bool>(
                    initialValue: false,
                    validator: (value) {
                      if (value != true) {
                        return 'Please confirm the information before submitting.';
                      }

                      return null;
                    },
                    builder: (field) {
                      return Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            value: _declaration,
                            contentPadding:
                            EdgeInsets.zero,
                            controlAffinity:
                            ListTileControlAffinity
                                .leading,
                            activeColor: iituRed,
                            title: const Text(
                              'I confirm that the information above is correct.',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                            subtitle: const Text(
                              'The information will be used only to process this campus service request.',
                              style: TextStyle(
                                color: greyText,
                                fontSize: 10.5,
                              ),
                            ),
                            onChanged: (value) {
                              final selected =
                                  value ?? false;

                              setState(() {
                                _declaration =
                                    selected;
                              });

                              field.didChange(
                                selected,
                              );
                            },
                          ),

                          if (field.hasError)
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                left: 12,
                                top: 4,
                              ),
                              child: Text(
                                field.errorText!,
                                style:
                                const TextStyle(
                                  color: iituRed,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _submitForm,
                      style:
                      ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: iituRed,
                        foregroundColor:
                        Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 17,
                        ),
                      ),
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 17,
                      ),
                      label: const Text(
                        'Submit Request',
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed: _resetForm,
                      style:
                      OutlinedButton.styleFrom(
                        foregroundColor:
                        darkText,
                        side: const BorderSide(
                          color: borderColor,
                        ),
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 17,
                        ),
                      ),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 17,
                      ),
                      label: const Text(
                        'Reset',
                      ),
                    ),
                  ],
                ),

                if (widget.lastRequest !=
                    null) ...[
                  const SizedBox(height: 42),

                  LastRequestCard(
                    request:
                    widget.lastRequest!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EVENT DETAILS PAGE
// ============================================================

class EventDetailsPage extends StatefulWidget {
  final CampusEvent event;

  const EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() =>
      _EventDetailsPageState();
}

class _EventDetailsPageState
    extends State<EventDetailsPage> {
  bool _registered = false;

  Future<void> _openRegistration() async {
    final result =
    await showDialog<bool>(
      context: context,
      builder: (
          context,
          ) {
        return EventRegistrationDialog(
          event: widget.event,
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        _registered = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'You are registered for ${widget.event.title}.',
          ),
          backgroundColor: successGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
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
          style: TextStyle(
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
            35,
            24,
            80,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 1050,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 420,
                    clipBehavior:
                    Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                        32,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppImage(
                          path:
                          widget.event.image,
                          fit: BoxFit.cover,
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
                          left: 32,
                          right: 32,
                          bottom: 32,
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
                                  1.4,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.event.title,
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 36,
                                  height: 1.06,
                                  fontWeight:
                                  FontWeight
                                      .w600,
                                  letterSpacing:
                                  -1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      EventMetaChip(
                        icon: Icons
                            .calendar_month_outlined,
                        text:
                        widget.event.fullDate,
                      ),
                      EventMetaChip(
                        icon: Icons
                            .access_time_rounded,
                        text:
                        widget.event.time,
                      ),
                      EventMetaChip(
                        icon: Icons
                            .location_on_outlined,
                        text:
                        widget.event.location,
                      ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  LayoutBuilder(
                    builder: (
                        context,
                        constraints,
                        ) {
                      final desktop =
                          constraints.maxWidth >=
                              760;

                      final main =
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          const Text(
                            'About the event',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                              FontWeight.w600,
                              letterSpacing: -0.7,
                            ),
                          ),
                          const SizedBox(height: 13),
                          Text(
                            widget.event
                                .longDescription,
                            style:
                            const TextStyle(
                              color: greyText,
                              fontSize: 13,
                              height: 1.75,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'What to expect',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ...widget
                              .event.expectations
                              .map(
                                (
                                item,
                                ) =>
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .only(
                                    bottom: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 26,
                                        height: 26,
                                        alignment:
                                        Alignment
                                            .center,
                                        decoration:
                                        const BoxDecoration(
                                          color:
                                          softRed,
                                          shape:
                                          BoxShape
                                              .circle,
                                        ),
                                        child:
                                        const Icon(
                                          Icons
                                              .check_rounded,
                                          color:
                                          iituRed,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 11,
                                      ),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style:
                                          const TextStyle(
                                            fontSize:
                                            12.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ],
                      );

                      final registerCard =
                      Container(
                        padding:
                        const EdgeInsets.all(
                          24,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(
                            25,
                          ),
                          border: Border.all(
                            color:
                            borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
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
                              height: 8,
                            ),
                            const Text(
                              'Register using your student details.',
                              style: TextStyle(
                                color:
                                greyText,
                                fontSize: 11.5,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width:
                              double.infinity,
                              child:
                              ElevatedButton.icon(
                                onPressed:
                                _registered
                                    ? null
                                    : _openRegistration,
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
                                  _registered
                                      ? Icons
                                      .check_circle_outline
                                      : Icons
                                      .how_to_reg_outlined,
                                  size: 17,
                                ),
                                label: Text(
                                  _registered
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
                              height: 28,
                            ),
                            registerCard,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Expanded(
                            child: main,
                          ),
                          const SizedBox(width: 35),
                          SizedBox(
                            width: 300,
                            child: registerCard,
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
// EVENT REGISTRATION FORM
// ============================================================

class EventRegistrationDialog
    extends StatefulWidget {
  final CampusEvent event;

  const EventRegistrationDialog({
    super.key,
    required this.event,
  });

  @override
  State<EventRegistrationDialog> createState() =>
      _EventRegistrationDialogState();
}

class _EventRegistrationDialogState
    extends State<EventRegistrationDialog> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _nameController =
  TextEditingController(
    text: 'Akvarzhanova Irada',
  );

  final TextEditingController _idController =
  TextEditingController(
    text: '41151',
  );

  final TextEditingController _emailController =
  TextEditingController(
    text: 'irada41151@student.iitu.kz',
  );

  bool _confirm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  void _register() {
    final valid =
        _formKey.currentState?.validate() ??
            false;

    if (!valid) return;

    if (!_confirm) {
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
      insetPadding:
      const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(28),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            autovalidateMode:
            AutovalidateMode
                .onUserInteraction,
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'EVENT REGISTRATION',
                  style: TextStyle(
                    color: iituRed,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.3,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 23,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller:
                  _nameController,
                  decoration:
                  const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                  ),
                  validator: (value) {
                    final text =
                        value?.trim() ?? '';

                    if (text.isEmpty ||
                        !text.contains(' ')) {
                      return 'Please enter your full name.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _idController,
                  decoration:
                  const InputDecoration(
                    labelText: 'Student ID',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                    ),
                  ),
                  validator: (value) {
                    if ((value?.trim().length ??
                        0) <
                        5) {
                      return 'Enter a valid Student ID.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller:
                  _emailController,
                  keyboardType:
                  TextInputType.emailAddress,
                  decoration:
                  const InputDecoration(
                    labelText: 'Campus email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                  ),
                  validator: (value) {
                    final email =
                        value?.trim() ?? '';

                    if (!email.contains(
                      '@',
                    )) {
                      return 'Enter a valid email.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: softGrey,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: CheckboxListTile(
                    contentPadding:
                    EdgeInsets.zero,
                    value: _confirm,
                    activeColor: iituRed,
                    controlAffinity:
                    ListTileControlAffinity
                        .leading,
                    title: const Text(
                      'I confirm my registration.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _confirm =
                            value ?? false;
                      });
                    },
                  ),
                ),

                if (!_confirm)
                  const Padding(
                    padding:
                    EdgeInsets.only(
                      top: 7,
                      left: 10,
                    ),
                    child: Text(
                      'Please confirm your registration.',
                      style: TextStyle(
                        color: iituRed,
                        fontSize: 10.5,
                      ),
                    ),
                  ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child:
                        const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                      ElevatedButton(
                        onPressed: _register,
                        style:
                        ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                          iituRed,
                          foregroundColor:
                          Colors.white,
                        ),
                        child:
                        const Text('Register'),
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
// HOME STUDENT SUPPORT PROMO
// ============================================================

class StudentSupportPromo
    extends StatefulWidget {
  final VoidCallback onOpenServices;
  final VoidCallback onOpenStatus;
  final bool hasRequest;

  const StudentSupportPromo({
    super.key,
    required this.onOpenServices,
    required this.onOpenStatus,
    required this.hasRequest,
  });

  @override
  State<StudentSupportPromo> createState() =>
      _StudentSupportPromoState();
}

class _StudentSupportPromoState
    extends State<StudentSupportPromo>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ),
    )..repeat(
      reverse: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        const PremiumHeading(
          eyebrow: 'STUDENT SUPPORT',
          title: 'Help when you need it.',
          subtitle:
          'Find the right campus service and submit a request without searching through departments.',
        ),

        const SizedBox(height: 38),

        LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final desktop =
                constraints.maxWidth >= 900;

            if (!desktop) {
              return Column(
                children: [
                  _centerCard(),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SupportFeatureCard(
                        icon:
                        Icons.flash_on_outlined,
                        title: 'Quick Help',
                        text:
                        'Find the right service quickly.',
                        onTap:
                        widget.onOpenServices,
                      ),
                      SupportFeatureCard(
                        icon:
                        Icons.report_problem_outlined,
                        title: 'Common Issues',
                        text:
                        'Wi-Fi, ID, dormitory and documents.',
                        onTap:
                        widget.onOpenServices,
                      ),
                      SupportFeatureCard(
                        icon:
                        Icons.receipt_long_outlined,
                        title:
                        'Request Status',
                        text: widget.hasRequest
                            ? 'Your latest request is available.'
                            : 'No submitted request yet.',
                        onTap:
                        widget.onOpenStatus,
                      ),
                      SupportFeatureCard(
                        icon:
                        Icons.support_agent_outlined,
                        title:
                        'Service Request',
                        text:
                        'Submit an issue online.',
                        onTap:
                        widget.onOpenServices,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _mainButton(),
                ],
              );
            }

            return Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFFBFBFC,
                ),
                borderRadius:
                BorderRadius.circular(34),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: AnimatedBuilder(
                animation: controller,
                builder: (
                    context,
                    child,
                    ) {
                  final float =
                      math.sin(
                        controller.value *
                            math.pi,
                      ) *
                          7;

                  return Stack(
                    children: [
                      Positioned(
                        left: 44,
                        top: 55,
                        width: 245,
                        child:
                        SupportFeatureCard(
                          icon: Icons
                              .flash_on_outlined,
                          title: 'Quick Help',
                          text:
                          'Find the right campus service quickly.',
                          onTap: widget
                              .onOpenServices,
                        ),
                      ),

                      Positioned(
                        left: 72,
                        bottom: 76,
                        width: 245,
                        child:
                        SupportFeatureCard(
                          icon: Icons
                              .report_problem_outlined,
                          title:
                          'Common Issues',
                          text:
                          'Wi-Fi, ID card, dormitory, documents and more.',
                          onTap: widget
                              .onOpenServices,
                        ),
                      ),

                      Positioned(
                        right: 45,
                        top: 55,
                        width: 245,
                        child:
                        SupportFeatureCard(
                          icon: Icons
                              .receipt_long_outlined,
                          title:
                          'Request Status',
                          text: widget
                              .hasRequest
                              ? 'Check your latest submitted request.'
                              : 'No active request yet.',
                          onTap: widget
                              .onOpenStatus,
                        ),
                      ),

                      Positioned(
                        right: 72,
                        bottom: 76,
                        width: 245,
                        child:
                        SupportFeatureCard(
                          icon: Icons
                              .support_agent_outlined,
                          title:
                          'Service Request',
                          text:
                          'Submit an issue online in a few steps.',
                          onTap: widget
                              .onOpenServices,
                        ),
                      ),

                      Align(
                        alignment:
                        Alignment.center,
                        child:
                        Transform.translate(
                          offset: Offset(
                            0,
                            -float,
                          ),
                          child:
                          _centerCard(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),

        const SizedBox(height: 22),

        Align(
          alignment: Alignment.center,
          child: _mainButton(),
        ),
      ],
    );
  }

  Widget _centerCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 35,
            offset: const Offset(
              0,
              16,
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            height: 32,
            child: AppImage(
              path:
              'assets/images/iitu_logo.png',
              fit: BoxFit.contain,
              alignment:
              Alignment.centerLeft,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'IITU Student Support',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'How can we help?',
            style: TextStyle(
              color: greyText,
              fontSize: 11.5,
            ),
          ),

          const SizedBox(height: 20),

          const SupportMockRow(
            icon: Icons.wifi_rounded,
            text: 'Wi-Fi / Internet',
          ),

          const SupportMockRow(
            icon: Icons.badge_outlined,
            text: 'Student ID Card',
          ),

          const SupportMockRow(
            icon:
            Icons.description_outlined,
            text: 'Academic Documents',
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
              widget.onOpenServices,
              style:
              ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: iituRed,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Get Help',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainButton() {
    return ElevatedButton.icon(
      onPressed: widget.onOpenServices,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 17,
        ),
      ),
      icon: const Icon(
        Icons.arrow_forward_rounded,
        size: 17,
      ),
      label: const Text(
        'Get Student Support',
      ),
    );
  }
}

// ============================================================
// DATA CLASSES
// ============================================================

class CampusEvent {
  final String title;
  final String category;
  final String date;
  final String fullDate;
  final String time;
  final String location;
  final String description;
  final String longDescription;
  final String image;
  final List<String> expectations;

  const CampusEvent({
    required this.title,
    required this.category,
    required this.date,
    required this.fullDate,
    required this.time,
    required this.location,
    required this.description,
    required this.longDescription,
    required this.image,
    required this.expectations,
  });
}

class ServiceRequestSummary {
  final String reference;
  final String studentName;
  final String studentId;
  final String email;
  final String category;
  final String subject;
  final String details;
  final String urgency;
  final String contactMethod;
  final String preferredDate;

  const ServiceRequestSummary({
    required this.reference,
    required this.studentName,
    required this.studentId,
    required this.email,
    required this.category,
    required this.subject,
    required this.details,
    required this.urgency,
    required this.contactMethod,
    required this.preferredDate,
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
// COMMON IMAGE
// ============================================================

class AppImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Alignment alignment;

  const AppImage({
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
// HEADINGS
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
            fontSize: 9,
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
            letterSpacing: -1.3,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          subtitle,
          style: const TextStyle(
            color: greyText,
            fontSize: 13,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FORM SECTION
// ============================================================

class FormSectionCard extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final Widget child;

  const FormSectionCard({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.018),
            blurRadius: 24,
            offset: const Offset(
              0,
              9,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
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
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: greyText,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          child,
        ],
      ),
    );
  }
}

class FormMiniTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const FormMiniTitle({
    super.key,
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
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: greyText,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// FORM CHIPS
// ============================================================

class SelectionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const SelectionChip({
    super.key,
    required this.label,
    required this.icon,
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
          milliseconds: 180,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color:
              selected ? iituRed : greyText,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color:
                selected ? iituRed : darkText,
                fontSize: 11.5,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IssueQuickChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const IssueQuickChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
          selected ? softRed : softGrey,
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color:
            selected ? iituRed : softGrey,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
            selected ? iituRed : greyText,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LAST REQUEST
// ============================================================

class LastRequestCard extends StatelessWidget {
  final ServiceRequestSummary request;

  const LastRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8F5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFCDE7D8),
        ),
      ),
      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final desktop =
              constraints.maxWidth >= 650;

          final copy = Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'LATEST REQUEST',
                style: TextStyle(
                  color: successGreen,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                request.category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                request.reference,
                style: const TextStyle(
                  color: greyText,
                  fontSize: 10.5,
                ),
              ),
            ],
          );

          final badge = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: successGreen,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Submitted',
                  style: TextStyle(
                    color: successGreen,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          );

          if (!desktop) {
            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 15),
                badge,
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: copy,
              ),
              badge,
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// SUPPORT PROMO PARTS
// ============================================================

class SupportFeatureCard
    extends StatefulWidget {
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  const SupportFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    required this.onTap,
  });

  @override
  State<SupportFeatureCard> createState() =>
      _SupportFeatureCardState();
}

class _SupportFeatureCardState
    extends State<SupportFeatureCard> {
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
        BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color:
              hover ? iituRed : borderColor,
            ),
            boxShadow: hover
                ? [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  0.045,
                ),
                blurRadius: 20,
                offset: const Offset(
                  0,
                  8,
                ),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: softRed,
                  borderRadius:
                  BorderRadius.circular(13),
                ),
                child: Icon(
                  widget.icon,
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
                      widget.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.text,
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
        ),
      ),
    );
  }
}

class SupportMockRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SupportMockRow({
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
        horizontal: 12,
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
            size: 17,
          ),
          const SizedBox(width: 9),
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
// EVENT CARD
// ============================================================

class EventPageCard extends StatefulWidget {
  final CampusEvent event;
  final VoidCallback onTap;

  const EventPageCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  State<EventPageCard> createState() =>
      _EventPageCardState();
}

class _EventPageCardState
    extends State<EventPageCard> {
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
        BorderRadius.circular(26),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(26),
            border: Border.all(
              color:
              hover ? iituRed : borderColor,
            ),
            boxShadow: hover
                ? [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  0.05,
                ),
                blurRadius: 28,
                offset: const Offset(
                  0,
                  12,
                ),
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 215,
                width: double.infinity,
                child: HoverImage(
                  image:
                  widget.event.image,
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.event.date,
                          style:
                          const TextStyle(
                            color: iituRed,
                            fontSize: 9,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.event.category
                              .toUpperCase(),
                          style:
                          const TextStyle(
                            color: greyText,
                            fontSize: 8.5,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      widget.event.title,
                      style: const TextStyle(
                        fontSize: 19,
                        height: 1.15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 11),

                    Text(
                      widget.event.description,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: greyText,
                        fontSize: 11.5,
                        height: 1.55,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Text(
                          'View Event',
                          style: TextStyle(
                            color: iituRed,
                            fontSize: 11,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        AnimatedRotation(
                          turns:
                          hover ? 0.04 : 0,
                          duration:
                          const Duration(
                            milliseconds: 180,
                          ),
                          child: const Icon(
                            Icons.north_east,
                            color: iituRed,
                            size: 16,
                          ),
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

class EventMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const EventMetaChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
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
            size: 16,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HEADER
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
            horizontal: 17,
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
              fontSize: 12.5,
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
// ANIMATIONS
// ============================================================

class RevealAfterDelay
    extends StatefulWidget {
  final Widget child;
  final int delay;

  const RevealAfterDelay({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  State<RevealAfterDelay> createState() =>
      _RevealAfterDelayState();
}

class _RevealAfterDelayState
    extends State<RevealAfterDelay> {
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
        milliseconds: 620 + delay,
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
              28 * (1 - value),
            ),
            child: widget,
          ),
        );
      },
      child: child,
    );
  }
}

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
        seconds: 4,
      ),
      curve: Curves.easeOut,
      tween: Tween(
        begin: 1.055,
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
      child: AppImage(
        path: image,
        fit: BoxFit.cover,
      ),
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
          milliseconds: 180,
        ),
        scale: hover ? 1.011 : 1,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(28),
            boxShadow: hover
                ? [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  0.05,
                ),
                blurRadius: 30,
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
          child: AppImage(
            path: widget.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ACADEMIC VALUE
// ============================================================

class CompactAcademicValue
    extends StatelessWidget {
  final String label;
  final String value;

  const CompactAcademicValue({
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
              fontSize: 8.5,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class AcademicMetricCard
    extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String caption;

  const AcademicMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
  });

  @override
  State<AcademicMetricCard> createState() =>
      _AcademicMetricCardState();
}

class _AcademicMetricCardState
    extends State<AcademicMetricCard> {
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
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        height: 145,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: hover
              ? const Color(0xFFFFF6F7)
              : const Color(0xFFF8F8FA),
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color:
            hover ? iituRed : borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  size: 17,
                  color: iituRed,
                ),
                const SizedBox(width: 7),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: greyText,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.caption,
              style: const TextStyle(
                color: greyText,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ORBIT HUB
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
    OrbitItemData(
      'Services',
      Icons.support_agent_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 38,
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
            const radius = 139.0;
            const buttonSize = 76.0;

            return Stack(
              children: [
                Positioned(
                  left: 100,
                  top: 100,
                  child: Container(
                    width: 200,
                    height: 200,
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
                            0.04,
                          ),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 94,
                          height: 42,
                          child: AppImage(
                            path:
                            'assets/images/iitu_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'STUDENT HUB',
                          style: TextStyle(
                            color: iituRed,
                            fontSize: 8.5,
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
            width: 76,
            height: 76,
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
                    0.05,
                  ),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Icon(
                  widget.data.icon,
                  size: 19,
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
                    fontSize: 8,
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
// ANNOUNCEMENT VISUALS
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
        math.sin(
          controller.value *
              math.pi *
              2,
        ) *
            5;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
            width: 86,
            height: 86,
            alignment: Alignment.center,
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
                    0.04,
                  ),
                  blurRadius: 22,
                ),
              ],
            ),
            child: SizedBox(
              width: 57,
              height: 35,
              child: AppImage(
                path:
                'assets/images/iitu_logo.png',
                fit: BoxFit.contain,
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
            icon: Icons.school_outlined,
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
  }

  Widget _academicVisual() {
    final pulse =
        math.sin(
          controller.value *
              math.pi *
              2,
        ) *
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
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iituRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iituRed.withOpacity(
                    0.18,
                  ),
                  blurRadius: 24,
                ),
              ],
            ),
            child: const Text(
              'IITU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
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
            icon: Icons.assignment_outlined,
            text: 'Semester',
          ),
        ),

        Align(
          alignment: Alignment(
            0.68,
            0.45 + pulse / 150,
          ),
          child: const NetworkBubble(
            icon: Icons.notifications_none,
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
            Colors.black.withOpacity(0.03),
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
              fontSize: 9,
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
// ARROW BUTTON
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
        borderRadius:
        BorderRadius.circular(50),
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
            color: hover
                ? Colors.white
                : darkText,
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
              scale: hover ? 1.045 : 1,
              child: AppImage(
                path: widget.image,
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
                  if (widget.number !=
                      null) ...[
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
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
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
                  color: Colors.white.withOpacity(
                    hover ? 1 : 0.86,
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
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
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
                  size: 218,
                  color: Color(
                    0xFF72A9C5,
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(
                  47,
                  -42,
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
                top: 73,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.12,
                    ),
                    borderRadius:
                    BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white
                          .withOpacity(
                        0.17,
                      ),
                    ),
                  ),
                  child: const Text(
                    'IITU · Kazakhstan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}