import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/providers/navbar_provider.dart';
import 'package:traductao_app/widgets/text_button_with_icon.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

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
          decoration: const InputDecoration(
            labelText: "Nombre de questions",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onTap: () {},
        ),
        const Spacer(),
        TextButtonWithIcon(
          text: "Lancer le quiz",
          icon: const Icon(Icons.play_arrow),
          outlined: false,
          onPressed: () {},
        ),
      ],
    );
  }
}
