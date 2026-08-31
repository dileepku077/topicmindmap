import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/admin_question.dart';
import '../../models/course.dart';
import '../../models/subtopic.dart';
import '../../models/unit.dart';
import '../../state/admin_providers.dart';
import '../../state/curriculum_providers.dart';

const _difficulties = ['Easy', 'Medium', 'Challenge', 'Hard', 'Advanced'];

T? _findById<T>(List<T> items, String? id, String Function(T) idOf) {
  if (id == null) return null;
  for (final item in items) {
    if (idOf(item) == id) return item;
  }
  return null;
}

/// The admin question bank browser/editor -- course, topic (unit),
/// subtopic, and difficulty pick one tier's worth of questions, then one
/// question at a time (Previous/Next) with every field editable: the
/// prompt, all 4 options' text, their feedback, and which one is correct.
/// The alternative to hand-editing raw JSONB in the Supabase table editor
/// -- see admin_update_question() in supabase/schema_admin_questions.sql
/// for the validation this saves through.
class AdminQuestionEditor extends ConsumerStatefulWidget {
  const AdminQuestionEditor({super.key});

  @override
  ConsumerState<AdminQuestionEditor> createState() =>
      _AdminQuestionEditorState();
}

class _AdminQuestionEditorState extends ConsumerState<AdminQuestionEditor> {
  String? _courseId;
  String? _unitId;
  String? _subtopicId;
  String? _difficulty;
  int _index = 0;

  /// Whether the currently-open question has unsaved edits -- set by
  /// [_QuestionForm] as the admin types, so a filter change or
  /// Previous/Next tap can confirm before discarding them.
  bool _dirty = false;

  Future<bool> _confirmDiscardIfDirty() async {
    if (!_dirty) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard unsaved changes?'),
        content: const Text(
          "This question has edits that haven't been saved yet. "
          'Moving on will lose them.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);
    final unitsAsync = ref.watch(unitsProvider);
    final subtopicsAsync = ref.watch(subtopicsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: coursesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Failed to load curriculum: $error'),
            data: (courses) => unitsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Failed to load curriculum: $error'),
              data: (units) => subtopicsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('Failed to load curriculum: $error'),
                data: (subtopics) => _buildFilters(courses, units, subtopics),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildBody(
            coursesAsync.value ?? const [],
            unitsAsync.value ?? const [],
            subtopicsAsync.value ?? const [],
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(
    List<Course> courses,
    List<Unit> units,
    List<Subtopic> subtopics,
  ) {
    final sortedCourses = [...courses]
      ..sort(
        (a, b) => a.grade != b.grade
            ? a.grade.compareTo(b.grade)
            : a.title.compareTo(b.title),
      );
    final courseUnits = units.where((u) => u.courseId == _courseId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final unitSubtopics = subtopics.where((s) => s.unitId == _unitId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            initialValue: _courseId,
            decoration: const InputDecoration(
              labelText: 'Course',
              isDense: true,
            ),
            items: [
              for (final c in sortedCourses)
                DropdownMenuItem(value: c.id, child: Text(c.gradeLabel)),
            ],
            onChanged: (value) async {
              if (!await _confirmDiscardIfDirty()) return;
              setState(() {
                _courseId = value;
                _unitId = null;
                _subtopicId = null;
                _difficulty = null;
                _index = 0;
                _dirty = false;
              });
            },
          ),
        ),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            initialValue: _unitId,
            decoration: const InputDecoration(
              labelText: 'Topic',
              isDense: true,
            ),
            items: [
              for (final u in courseUnits)
                DropdownMenuItem(value: u.id, child: Text(u.title)),
            ],
            onChanged: _courseId == null
                ? null
                : (value) async {
                    if (!await _confirmDiscardIfDirty()) return;
                    setState(() {
                      _unitId = value;
                      _subtopicId = null;
                      _difficulty = null;
                      _index = 0;
                      _dirty = false;
                    });
                  },
          ),
        ),
        SizedBox(
          width: 240,
          child: DropdownButtonFormField<String>(
            initialValue: _subtopicId,
            decoration: const InputDecoration(
              labelText: 'Subtopic',
              isDense: true,
            ),
            items: [
              for (final s in unitSubtopics)
                DropdownMenuItem(value: s.id, child: Text(s.title)),
            ],
            onChanged: _unitId == null
                ? null
                : (value) async {
                    if (!await _confirmDiscardIfDirty()) return;
                    setState(() {
                      _subtopicId = value;
                      _difficulty = null;
                      _index = 0;
                      _dirty = false;
                    });
                  },
          ),
        ),
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<String>(
            initialValue: _difficulty,
            decoration: const InputDecoration(
              labelText: 'Difficulty',
              isDense: true,
            ),
            items: [
              for (final d in _difficulties)
                DropdownMenuItem(value: d, child: Text(d)),
            ],
            onChanged: _subtopicId == null
                ? null
                : (value) async {
                    if (!await _confirmDiscardIfDirty()) return;
                    setState(() {
                      _difficulty = value;
                      _index = 0;
                      _dirty = false;
                    });
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    List<Course> courses,
    List<Unit> units,
    List<Subtopic> subtopics,
  ) {
    final course = _findById(courses, _courseId, (c) => c.id);
    final unit = _findById(units, _unitId, (u) => u.id);
    final subtopic = _findById(subtopics, _subtopicId, (s) => s.id);
    final difficulty = _difficulty;

    if (course == null ||
        unit == null ||
        subtopic == null ||
        difficulty == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Choose a course, topic, subtopic, and difficulty to browse '
            'its questions.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final filter = AdminQuestionFilter(
      courseCode: course.code,
      unitCode: unit.code,
      subtopicCode: subtopic.code,
      difficulty: difficulty,
    );
    final questionsAsync = ref.watch(adminQuestionsProvider(filter));

    return questionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load questions: $error')),
      data: (questions) {
        if (questions.isEmpty) {
          return const Center(
            child: Text('No questions found for this selection.'),
          );
        }
        final index = _index.clamp(0, questions.length - 1);
        final question = questions[index];

        Future<void> goTo(int newIndex) async {
          if (!await _confirmDiscardIfDirty()) return;
          setState(() {
            _index = newIndex;
            _dirty = false;
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Question ${index + 1} of ${questions.length}',
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Previous question',
                    icon: const Icon(Icons.chevron_left),
                    onPressed: index == 0 ? null : () => goTo(index - 1),
                  ),
                  IconButton(
                    tooltip: 'Next question',
                    icon: const Icon(Icons.chevron_right),
                    onPressed: index >= questions.length - 1
                        ? null
                        : () => goTo(index + 1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _QuestionForm(
                key: ValueKey(question.id),
                question: question,
                onDirtyChanged: (dirty) {
                  if (dirty != _dirty) setState(() => _dirty = dirty);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// One question, fully editable: prompt, all 4 options (text + feedback),
/// and which one is correct. Rebuilt fresh (see the [ValueKey] on it in
/// [_AdminQuestionEditorState._buildBody]) every time the admin moves to a
/// different question, so its controllers always start from that
/// question's own saved values.
class _QuestionForm extends ConsumerStatefulWidget {
  const _QuestionForm({
    super.key,
    required this.question,
    required this.onDirtyChanged,
  });

  final AdminQuestion question;
  final ValueChanged<bool> onDirtyChanged;

  @override
  ConsumerState<_QuestionForm> createState() => _QuestionFormState();
}

class _QuestionFormState extends ConsumerState<_QuestionForm> {
  late final _promptController = TextEditingController(
    text: widget.question.prompt,
  )..addListener(_markDirty);
  late final _textControllers = [
    for (final o in widget.question.options)
      TextEditingController(text: o.text)..addListener(_markDirty),
  ];
  late final _feedbackControllers = [
    for (final o in widget.question.options)
      TextEditingController(text: o.feedback)..addListener(_markDirty),
  ];
  late int _correctIndex = widget.question.correctIndex;

  bool _saving = false;
  String? _error;

  void _markDirty() {
    if (_saving) return;
    widget.onDirtyChanged(true);
  }

  void _setCorrectIndex(int index) {
    setState(() => _correctIndex = index);
    widget.onDirtyChanged(true);
  }

  @override
  void dispose() {
    _promptController.dispose();
    for (final c in _textControllers) {
      c.dispose();
    }
    for (final c in _feedbackControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final prompt = _promptController.text.trim();
    final options = [
      for (var i = 0; i < 4; i++)
        AdminQuestionOption(
          text: _textControllers[i].text.trim(),
          feedback: _feedbackControllers[i].text.trim(),
        ),
    ];
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(adminRepositoryProvider)
          .updateQuestion(
            questionId: widget.question.id,
            prompt: prompt,
            options: options,
            correctIndex: _correctIndex,
            misconceptionTag: widget.question.misconceptionTag,
          );
      if (!mounted) return;
      setState(() => _saving = false);
      widget.onDirtyChanged(false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Question saved.')));
    } catch (error) {
      setState(() {
        _saving = false;
        _error = 'Could not save: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final question = widget.question;
    return RadioGroup<int>(
      groupValue: _correctIndex,
      onChanged: (value) => _setCorrectIndex(value!),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  question.difficulty,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Sort order ${question.sortOrder}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _promptController,
            decoration: const InputDecoration(
              labelText: 'Question prompt',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            minLines: 2,
            maxLines: null,
          ),
          const SizedBox(height: 20),
          Text(
            'Answer options — pick the correct one',
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < 4; i++) ...[
            _OptionEditor(
              index: i,
              correctIndex: _correctIndex,
              onSelectCorrect: _setCorrectIndex,
              textController: _textControllers[i],
              feedbackController: _feedbackControllers[i],
            ),
            const SizedBox(height: 12),
          ],
          if (_error != null) ...[
            Text(_error!, style: TextStyle(color: scheme.error)),
            const SizedBox(height: 12),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save changes'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionEditor extends StatelessWidget {
  const _OptionEditor({
    required this.index,
    required this.correctIndex,
    required this.onSelectCorrect,
    required this.textController,
    required this.feedbackController,
  });

  final int index;
  final int correctIndex;
  final ValueChanged<int> onSelectCorrect;
  final TextEditingController textController;
  final TextEditingController feedbackController;

  static const _labels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = index == correctIndex;
    return Material(
      color: selected
          ? scheme.primary.withValues(alpha: 0.08)
          : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Lets tapping anywhere in the tile (not just the small radio
        // dot) mark this option correct.
        onTap: () => onSelectCorrect(index),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The RadioGroup ancestor in _QuestionFormState.build supplies
              // groupValue/onChanged for every Radio here; onSelectCorrect
              // below is only for making the rest of the tile tappable too.
              Radio<int>(value: index),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Option ${_labels[index]}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Correct answer',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelText: 'Answer text',
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: feedbackController,
                      decoration: const InputDecoration(
                        labelText: 'Feedback shown after choosing this option',
                        isDense: true,
                      ),
                      minLines: 1,
                      maxLines: null,
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
