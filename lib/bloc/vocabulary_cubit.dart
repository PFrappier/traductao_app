import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';

class VocabularyCubit extends Cubit<VocabularyState> {
  VocabularyCubit() : super(const VocabularyState());

  List<VocabularyEntry> get vocabularyEntries => state.vocabularyEntries;

  void deleteTranslations(List<String> translationIds) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      final updatedTranslations = entry.translations
          .where((translation) => !translationIds.contains(translation.id))
          .toList();
      return VocabularyEntry(
        id: entry.id,
        language: entry.language,
        countryCode: entry.countryCode,
        translations: updatedTranslations,
      );
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
  }

  // Future<void> fetchReports(String? memberAnonymousId) async {
  //   final log = getLogger("MemberReportsCubit",
  //       methodName: "fetchReports",
  //       methodArgs: {'memberAnonymousId': memberAnonymousId});

  //   try {
  //     //memberAnonymousId = "hrxQa8tJPbZ5vLXUIkAPXl5asFA2";
  //     if (memberAnonymousId == null) {
  //       log.error("Member anonymous id is empty");
  //       emit(state.copyWith(status: MemberReportsStatus.success, reports: []));
  //       return;
  //     }
  //     log.debug("Entered method");

  //     emit(state.copyWith(status: MemberReportsStatus.loading));

  //     List<MemberReport> reports =
  //         await reportRepository.fetchMemberReports(memberAnonymousId);

  //     emit(state.copyWith(
  //       status: MemberReportsStatus.success,
  //       reports: reports,
  //     ));
  //   } catch (e) {
  //     log.error("Error when trying to fetch reports", data: {'error': e});
  //     emit(state.copyWith(status: MemberReportsStatus.failure));
  //   }
  // }
}
