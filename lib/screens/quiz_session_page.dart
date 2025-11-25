import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traductao_app/model/translation.dart';

class QuizSessionPage extends StatefulWidget {
  final List<Translation> translations;
  final String language;

  const QuizSessionPage({
    super.key,
    required this.translations,
    required this.language,
  });

  @override
  State<QuizSessionPage> createState() => _QuizSessionPageState();
}

class _QuizSessionPageState extends State<QuizSessionPage> {
  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  bool _isAnswerValidated = false;
  bool _isCorrect = false;
  int _correctAnswersCount = 0;
  bool _showResults = false;
  final List<Translation> _failedTranslations = [];
  late List<Translation> _currentTranslations;
  late int _totalQuestionsCount;
  int _totalCorrectAnswers = 0;

  @override
  void initState() {
    super.initState();
    _currentTranslations = widget.translations;
    _totalQuestionsCount = widget.translations.length;
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  double get _progress =>
      (_currentQuestionIndex + 1) / _currentTranslations.length;

  Translation get _currentTranslation =>
      _currentTranslations[_currentQuestionIndex];

  void _validateAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = _currentTranslation.translatedText.trim().toLowerCase();

    setState(() {
      _isAnswerValidated = true;
      _isCorrect = userAnswer == correctAnswer;
      if (_isCorrect) {
        _correctAnswersCount++;
      } else {
        _failedTranslations.add(_currentTranslation);
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _currentTranslations.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
        _isAnswerValidated = false;
        _isCorrect = false;
      });
    } else {
      setState(() {
        _showResults = true;
      });
    }
  }

  void _retryFailedQuestions() {
    setState(() {
      _totalCorrectAnswers += _correctAnswersCount;
      _currentTranslations = List.from(_failedTranslations);
      _failedTranslations.clear();
      _currentQuestionIndex = 0;
      _correctAnswersCount = 0;
      _showResults = false;
      _isAnswerValidated = false;
      _isCorrect = false;
      _answerController.clear();
    });
  }

  Widget _buildResultsScreen(BuildContext context) {
    final totalCorrect = _totalCorrectAnswers + _correctAnswersCount;
    final percentage = (totalCorrect / _totalQuestionsCount * 100).round();

    String getMessage() {
      if (percentage == 100) return 'Parfait ! 🎯';
      if (percentage >= 80) return 'Excellent ! 🌟';
      if (percentage >= 60) return 'Pas mal du tout ! 👍';
      if (percentage >= 40) return 'On y est presque... 🤔';
      return 'Aïe aïe aïe... 😅';
    }

    return Column(
      children: [
        const SizedBox(height: 230),
        Text(
          getMessage(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Tu as obtenu',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          '$totalCorrect/$_totalQuestionsCount',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Spacer(),
        if (_failedTranslations.isNotEmpty) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _retryFailedQuestions,
              child: Text(
                'Recommencer avec les ${_failedTranslations.length} erreur${_failedTranslations.length > 1 ? 's' : ''}',
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/quiz'),
              child: const Text('Terminer'),
            ),
          ),
        ] else
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go('/quiz'),
              child: const Text('Terminer'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Quiz - ${widget.language}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/quiz'),
        ),
        bottom: _showResults
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _showResults
            ? _buildResultsScreen(context)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${_currentTranslations.length}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Traduis en ${widget.language} :',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        _currentTranslation.text,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      labelText: "Ta réponse",
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                    autofocus: true,
                    enabled: !_isAnswerValidated,
                  ),
                  const SizedBox(height: 20),
                  if (_isAnswerValidated)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isCorrect
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isCorrect ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isCorrect ? Icons.check_circle : Icons.cancel,
                                color: _isCorrect ? Colors.green : Colors.red,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _isCorrect
                                      ? 'Bravo ! C\'est la bonne réponse 🎉'
                                      : 'Bonne réponse : ${_currentTranslation.translatedText}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: _isCorrect ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isAnswerValidated ? _nextQuestion : _validateAnswer,
                      child: Text(
                        _isAnswerValidated
                            ? (_currentQuestionIndex < _currentTranslations.length - 1
                                ? 'Question suivante'
                                : 'Terminer le quiz')
                            : 'Valider',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
