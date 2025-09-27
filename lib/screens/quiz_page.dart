import 'package:flutter/material.dart';
import 'package:traductao_app/widgets/text_button_with_icon.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Teste tes connaissances 🤔",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10),
            Text(
              "Lance un quiz en choisissant la langue que tu souhaites et le nombre de questions auxquelles répondre.",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 30),
            DropdownMenu<String>(
              label: Text("Langue"),
              width: double.infinity,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 'fr', label: 'Français'),
                DropdownMenuEntry(value: 'en', label: 'Anglais'),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Nombre de questions",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onTap: () {},
            ),
            Spacer(),
            TextButtonWithIcon(
              text: "Lancer le quiz",
              icon: Icon(Icons.play_arrow),
              outlined: false,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
