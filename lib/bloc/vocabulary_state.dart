import 'package:equatable/equatable.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';

enum VocabularyStatus { initial, loading, success, failure }

class VocabularyState extends Equatable {
  const VocabularyState({
    this.status = VocabularyStatus.initial,
    this.vocabularyEntries = const [],
  });

  final VocabularyStatus status;
  final List<VocabularyEntry> vocabularyEntries;

  VocabularyState copyWith({
    VocabularyStatus? status,
    List<VocabularyEntry>? vocabularyEntries,
  }) {
    return VocabularyState(
      status: status ?? this.status,
      vocabularyEntries: vocabularyEntries ?? this.vocabularyEntries,
    );
  }

  @override
  List<Object> get props => [status, vocabularyEntries];
}
