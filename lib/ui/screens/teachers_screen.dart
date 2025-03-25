import 'package:flutter/material.dart';
import 'package:flutter_admin_dashboard_app/widgets/teachers_table_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/search_bar_component.dart';
import '../../models/teacher_model.dart';
import '../../entities/teacher.dart';
import '../../entities/school.dart';
import '../views/add_teacher_dialog.dart';
import '../views/edit_teacher_dialog.dart';
import '../../repositories/school_repository.dart';
import '../../repositories/teacher_repository.dart';
import '../../repositories/repository_provider.dart';


class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => TeachersScreenState();
}

class TeachersScreenState extends State<TeachersScreen> {
  late final SchoolRepository _schoolRepository;
  late final TeacherRepository _teacherRepository;
  List<School> _schools = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      final repositoryProvider = Provider.of<RepositoryProvider>(context, listen: false);
      _schoolRepository = repositoryProvider.schoolRepository;
      _teacherRepository = repositoryProvider.teacherRepository;
      _loadSchools();
    }
  }

  Future<void> _loadSchools() async {
    final schools = await _schoolRepository.getSchools();
    setState(() {
      _schools = schools;
      _isLoading = false;
    });
  }

  Future<void> _updateSchool(School school) async {
    await _schoolRepository.updateSchool(school);
    await _loadSchools();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeacherModel(
        _teacherRepository,
        _schools,
        _updateSchool,
      ),
      child: Consumer<TeacherModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SearchBarComponent(
                      key: const ValueKey('search_teachers'),
                      hintText: 'Search teachers',
                      onSearch: (query) => model.search(query),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(context, model),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Teacher'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TeachersTableWidget(
                  teachers: model.teachers,
                  onDelete: (id) => model.deleteTeacher(id),
                  onEdit: (teacher) => _showEditDialog(context, model, teacher),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, TeacherModel model) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AddTeacherDialog(
        onAdd: (teacher) => model.addTeacher(teacher),
        availableSchools: _schools,
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, TeacherModel model, Teacher teacher) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => EditTeacherDialog(
        teacher: teacher,
        onSave: (teacher) => model.updateTeacher(teacher),
        availableSchools: _schools,
      ),
    );
  }
}