import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/providers/navbar_provider.dart';
import 'package:traductao_app/widgets/text_button_with_icon.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? _selectedLanguage;
  final TextEditingController _numberOfQuestionsController =
      TextEditingController();

  @override
  void dispose() {
    _numberOfQuestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<VocabularyCubit, VocabularyState>(
          builder: (context, state) {
            if (state.vocabularyEntries.isEmpty) {
              return _buildEmptyState(context);
            }

            return _buildQuizForm(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun quiz disponible',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Pour créer un quiz, tu dois d\'abord ajouter une langue à ton vocabulaire.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              context.read<NavBarProvider>().setCurrentIndex(0);
              context.go('/my_vocabulary');
            },
            child: const Text('Aller au vocabulaire'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizForm(BuildContext context, VocabularyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Teste tes connaissances 🤔",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text(
          "Lance un quiz en choisissant la langue que tu souhaites et le nombre de questions auxquelles répondre.",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 30),
        DropdownMenu<String>(
          label: const Text("Langue"),
          width: double.infinity,
          onSelected: (String? value) {
            setState(() {
              _selectedLanguage = value;
            });
          },
          dropdownMenuEntries: state.vocabularyEntries
              .map(
                (entry) => DropdownMenuEntry(
                  value: entry.language,
                  label: entry.language,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _numberOfQuestionsController,
          decoration: const InputDecoration(
            labelText: "Nombre de questions",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const Spacer(),
        TextButtonWithIcon(
          text: "Lancer le quiz",
          icon: const Icon(Icons.play_arrow),
          outlined: false,
          onPressed: () => _launchQuiz(context, state),
        ),
      ],
    );
  }

  void _launchQuiz(BuildContext context, VocabularyState state) {
    if (_selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une langue')),
      );
      return;
    }

    final numberOfQuestions = int.tryParse(_numberOfQuestionsController.text);
    if (numberOfQuestions == null || numberOfQuestions <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nombre de questions valide'),
        ),
      );
      return;
    }

    final selectedEntry = state.vocabularyEntries.firstWhere(
      (entry) => entry.language == _selectedLanguage,
    );

    if (selectedEntry.translations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune traduction disponible pour cette langue'),
        ),
      );
      return;
    }

    final availableTranslations = selectedEntry.translations.toList()
      ..shuffle(Random());
    final quizTranslations = availableTranslations
        .take(numberOfQuestions)
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuizDialog(
        translations: quizTranslations,
        language: _selectedLanguage!,
      ),
    );
  }
}

class QuizDialog extends StatefulWidget {
  final List<Translation> translations;
  final String language;

  const QuizDialog({
    super.key,
    required this.translations,
    required this.language,
  });

  @override
  State<QuizDialog> createState() => _QuizDialogState();
}

class _QuizDialogState extends State<QuizDialog> {
  int _currentQuestionIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  double get _progress =>
      (_currentQuestionIndex + 1) / widget.translations.length;

  Translation get _currentTranslation =>
      widget.translations[_currentQuestionIndex];

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.translations.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
      });
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Quiz terminé !')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz - ${widget.language}'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: PreferredSize(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${widget.translations.length}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
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
                autofocus: true,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentQuestionIndex < widget.translations.length - 1
                        ? 'Question suivante'
                        : 'Terminer le quiz',
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
