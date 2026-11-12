import 'package:material_ui/material_ui.dart';
import '../helpers/database_helper.dart';

class QuizScreen extends StatefulWidget {
  final bool isScenarioMode;

  const QuizScreen({super.key, this.isScenarioMode = false});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> _items = [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _submitted = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final data = widget.isScenarioMode
        ? await db.getScenarios()
        : await db.getQuizQuestions(1); // Load Module 1 default

    if (mounted) {
      setState(() {
        _items = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.isScenarioMode
              ? 'Troubleshooting Case'
              : 'Knowledge Quiz'),
        ),
        body: const Center(
          child: Text('No questions available yet.'),
        ),
      );
    }

    final item = _items[_currentIndex];
    final options = [
      item['option_a'] as String,
      item['option_b'] as String,
      item['option_c'] as String,
      item['option_d'] as String,
    ];
    final correctOption = item['correct_option'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isScenarioMode
            ? 'Troubleshooting Case'
            : 'Knowledge Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question or Scenario Title
            Text(
              widget.isScenarioMode
                  ? (item['title'] as String)
                  : 'Question ${_currentIndex + 1}/${_items.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Question Description / Symptom Text
            Text(
              widget.isScenarioMode
                  ? '${item['symptom']}\n\nContext: ${item['system_context']}'
                  : (item['question'] as String),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Options List
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  Color cardColor = Colors.white;
                  if (_submitted) {
                    if (index == correctOption) {
                      cardColor = Colors.green.shade100;
                    } else if (index == _selectedOption) {
                      cardColor = Colors.red.shade100;
                    }
                  } else if (_selectedOption == index) {
                    cardColor = Colors.blue.shade50;
                  }

                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(options[index]),
                      onTap: _submitted
                          ? null
                          : () {
                              setState(() => _selectedOption = index);
                            },
                    ),
                  );
                },
              ),
            ),

            // Explanation Display After Submit
            if (_submitted)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.isScenarioMode
                      ? (item['solution_explanation'] as String)
                      : (item['explanation'] as String),
                  style: const TextStyle(
                      fontSize: 13, fontStyle: FontStyle.italic),
                ),
              ),

            const SizedBox(height: 12),

            // Submit / Next Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedOption == null
                    ? null
                    : () {
                        if (!_submitted) {
                          setState(() => _submitted = true);
                        } else {
                          if (_currentIndex < _items.length - 1) {
                            setState(() {
                              _currentIndex++;
                              _selectedOption = null;
                              _submitted = false;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                child: Text(_submitted
                    ? (_currentIndex < _items.length - 1
                        ? 'Next Question'
                        : 'Finish')
                    : 'Submit Answer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
