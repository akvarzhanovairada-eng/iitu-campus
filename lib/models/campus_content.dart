import 'package:flutter/material.dart';

/// Local demonstration content used by the Campus Content Lists and Grids lab.
/// Stable IDs keep bookmark state independent from list positions.
class Announcement {
  final String id;
  final String title;
  final String category;
  final String date;
  final String preview;
  final String detail;
  final IconData icon;
  final bool isNew;

  const Announcement({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.preview,
    required this.detail,
    required this.icon,
    this.isNew = false,
  });
}

class CampusService {
  final String id;
  final String name;
  final String description;
  final String location;
  final String openingHours;
  final String contact;
  final String status;
  final IconData icon;
  final Color color;

  const CampusService({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.openingHours,
    required this.contact,
    required this.status,
    required this.icon,
    required this.color,
  });
}

/// Eight fictional campus announcements required by the practical task.
const campusAnnouncements = [
  Announcement(
    id: 'announcement_wifi_maintenance',
    title: 'Campus Wi-Fi maintenance notice',
    category: 'IT Services',
    date: '27 October 2026',
    preview: 'A short maintenance window is planned for the campus wireless network this evening.',
    detail: 'The IITU campus wireless network will undergo scheduled demonstration maintenance on 27 October from 19:00 to 20:30. Short interruptions may affect student Wi-Fi in study areas and shared spaces. Students are advised to save cloud work before the maintenance window and use mobile data for urgent online activity. Normal service is expected to resume after the maintenance is completed. This notice is fictional demonstration content created for the Campus Content Lists and Grids practical task.',
    icon: Icons.wifi_rounded,
    isNew: true,
  ),
  Announcement(
    id: 'announcement_library_hours',
    title: 'Library study hours extended',
    category: 'Library',
    date: '26 October 2026',
    preview: 'The library will stay open later during the upcoming assessment period.',
    detail: 'For the upcoming assessment period, the demonstration library schedule has been extended to give students more time for individual and group study. Quiet study areas and selected collaboration spaces will remain available until 21:00 on weekdays. Students should bring their university ID when entering after normal office hours. This is fictional demonstration data for the practical exercise.',
    icon: Icons.local_library_outlined,
  ),
  Announcement(
    id: 'announcement_registration_deadline',
    title: 'Spring course registration deadline',
    category: 'Academic',
    date: '24 October 2026',
    preview: 'Students should review their planned modules before the demonstration registration deadline.',
    detail: 'Students are reminded to review their planned spring modules and complete the demonstration course registration process before the listed deadline. Check prerequisites, timetable conflicts and credit requirements before confirming a selection. Students who need academic guidance can contact the Academic Office through the campus services page. This announcement is fictional and is used only as demonstration content.',
    icon: Icons.school_outlined,
  ),
  Announcement(
    id: 'announcement_midterm_week',
    title: 'Midterm examination week reminder',
    category: 'Academic',
    date: '22 October 2026',
    preview: 'Check your timetable, room details and student ID before each scheduled assessment.',
    detail: 'The demonstration midterm examination week is approaching. Students should check the latest timetable, confirm the room for each assessment and arrive with a valid student ID. Personal devices should be stored according to the instructions given by the lecturer. Any timetable questions should be raised with the relevant academic office before the examination day. This notice is fictional demonstration content.',
    icon: Icons.assignment_outlined,
  ),
  Announcement(
    id: 'announcement_career_registration',
    title: 'Career fair registration is open',
    category: 'Career',
    date: '20 October 2026',
    preview: 'Students can register for CV reviews, employer talks and internship information sessions.',
    detail: 'Registration is open for the fictional IITU Career Fair programme. Demonstration activities include short employer presentations, CV review appointments and internship information sessions. Students are encouraged to prepare a short introduction and an updated CV before attending. More information can be found through the Career Services tile on the Services page. This notice is demonstration data only.',
    icon: Icons.work_outline_rounded,
  ),
  Announcement(
    id: 'announcement_id_renewal',
    title: 'Student ID card renewal reminder',
    category: 'Student Services',
    date: '18 October 2026',
    preview: 'Students with expiring or damaged cards can prepare a renewal request through campus support.',
    detail: 'Students whose demonstration student ID card is expiring or damaged are reminded to prepare a renewal request. Bring the required identification information and check the service instructions before visiting the support desk. If a card has been lost, students can also submit a campus service request through the Services page. This is fictional demonstration content for the practical task.',
    icon: Icons.badge_outlined,
  ),
  Announcement(
    id: 'announcement_accommodation_check',
    title: 'Accommodation maintenance check',
    category: 'Accommodation',
    date: '15 October 2026',
    preview: 'A routine demonstration maintenance check is planned for selected student accommodation areas.',
    detail: 'A routine fictional maintenance check is planned for selected student accommodation areas. The demonstration check covers common lighting, water fixtures and shared facilities. Students who notice a separate room issue can use the Accommodation service information or submit a service request from the campus app. This announcement is fictional demonstration data.',
    icon: Icons.apartment_outlined,
  ),
  Announcement(
    id: 'announcement_scholarship',
    title: 'Scholarship application information',
    category: 'Student Opportunities',
    date: '12 October 2026',
    preview: 'Review the fictional eligibility checklist and prepare supporting documents before applying.',
    detail: 'A fictional scholarship information period is open for demonstration purposes. Students should review the eligibility checklist, prepare the requested academic documents and make sure all information is complete before submission. Questions about supporting documents can be directed to the appropriate campus service. This announcement is demonstration content and does not represent a real scholarship call.',
    icon: Icons.workspace_premium_outlined,
  ),
];

/// Six service tiles required by the practical task.
const campusServices = [
  CampusService(
    id: 'library',
    name: 'Library',
    description: 'Borrowing support, study spaces, digital resources and library access.',
    location: 'Level 3',
    openingHours: '08:30 – 20:00',
    contact: 'library@iitu.edu.kz',
    status: 'Open',
    icon: Icons.local_library_outlined,
    color: Color(0xFF7C3AED),
  ),
  CampusService(
    id: 'counselling',
    name: 'Counselling',
    description:
        'Confidential wellbeing guidance and student support appointments.',
    location: 'Student Centre',
    openingHours: '09:00 – 17:30',
    contact: 'counselling@iitu.edu.kz',
    status: 'Open',
    icon: Icons.psychology_alt_outlined,
    color: Color(0xFF0F9D8A),
  ),
  CampusService(
    id: 'accommodation',
    name: 'Accommodation',
    description: 'Dormitory information, maintenance guidance and accommodation support.',
    location: 'Student Affairs Desk',
    openingHours: '09:00 – 17:30',
    contact: 'accommodation@iitu.edu.kz',
    status: 'Open',
    icon: Icons.apartment_outlined,
    color: Color(0xFFF59E0B),
  ),
  CampusService(
    id: 'career_services',
    name: 'Career Services',
    description:
        'Internships, CV support, career events and employment opportunities.',
    location: 'Room 405',
    openingHours: '10:00 – 18:00',
    contact: 'career@iitu.edu.kz',
    status: 'Open',
    icon: Icons.work_outline_rounded,
    color: Color(0xFF4F46E5),
  ),
  CampusService(
    id: 'sports',
    name: 'Sports',
    description:
        'Sports clubs, training information and campus activity support.',
    location: 'Sports Desk',
    openingHours: '09:00 – 19:00',
    contact: 'sports@iitu.edu.kz',
    status: 'Open',
    icon: Icons.sports_basketball_outlined,
    color: Color(0xFFE05A33),
  ),
  CampusService(
    id: 'it_helpdesk',
    name: 'IT Helpdesk',
    description: 'Technical support for university accounts, Wi-Fi and digital services.',
    location: 'Room 205',
    openingHours: '09:00 – 18:00',
    contact: 'helpdesk@iitu.edu.kz',
    status: 'Open',
    icon: Icons.support_agent_outlined,
    color: Color(0xFF3B82F6),
  ),
];
