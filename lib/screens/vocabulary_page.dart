import 'package:flutter/material.dart';
import 'package:traductao_app/router/go_router.dart';

class MyVocabularyPage extends StatelessWidget {
  const MyVocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon vocabulaire'), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double spacing = 8.0;
            final double availableWidth = constraints.maxWidth;
            final int cardsPerRow =
                (availableWidth + spacing) ~/ (150 + spacing);
            final double cardWidth =
                (availableWidth - (cardsPerRow - 1) * spacing) / cardsPerRow;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        router.push('/translations/Espagnol');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 120,
                            child: Image.network(
                              'https://flagcdn.com/w320/es.png',
                              width: cardWidth,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Espagnol",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  "10 traductions",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        router.push('/translations/Anglais');
                      },
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 120,
                          child: Image.network(
                            'https://flagcdn.com/w320/gb.png',
                            width: cardWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Anglais",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                "13 traductions",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
