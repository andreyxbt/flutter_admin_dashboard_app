import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/shared_preferences_service.dart';
import 'teacher_repository.dart';
import 'content_director_repository.dart';
import 'pd_company_repository.dart';
import 'school_repository.dart';

class RepositoryProvider {
  final TeacherRepository teacherRepository;
  final ContentDirectorRepository contentDirectorRepository;
  final PDCompanyRepository pdCompanyRepository;
  final SchoolRepository schoolRepository;

  RepositoryProvider._({
    required this.teacherRepository,
    required this.contentDirectorRepository,
    required this.pdCompanyRepository,
    required this.schoolRepository,
  });

  factory RepositoryProvider(SharedPreferencesService prefsService, {FirebaseFirestore? firestore}) {
    // Create Firebase repositories
    final firebaseTeacherRepo = FirestoreTeacherRepository(firestore: firestore);
    final firebaseContentDirectorRepo = FirestoreContentDirectorRepository(firestore: firestore);
    final firebasePDCompanyRepo = FirestorePDCompanyRepository(firestore: firestore);
    final firebaseSchoolRepo = FirestoreSchoolRepository(firestore: firestore);

    // Create persistent repositories that wrap the Firebase repositories
    return RepositoryProvider._(
      teacherRepository: PersistentTeacherRepository(prefsService, firebaseTeacherRepo),
      contentDirectorRepository: PersistentContentDirectorRepository(prefsService, firebaseContentDirectorRepo),
      pdCompanyRepository: PersistentPDCompanyRepository(prefsService, firebasePDCompanyRepo),
      schoolRepository: PersistentSchoolRepository(prefsService, firebaseSchoolRepo),
    );
  }
}