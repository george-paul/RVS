class GlobalData {
  int surveyNumber = 0;
  bool cameraOpen = false;
}

class SurveyTitle {
  final String form;
  final String code;
  final String name;

  const SurveyTitle({required this.form, required this.code, required this.name});

  String get surveyScreenTitle {
    return "$code - $name";
  }

  String get surveyPdfTitle {
    return "$form $code - $name";
  }
}

const List<SurveyTitle> surveyTitles = [
  SurveyTitle(form: "Form 1A", code: "L1:M", name: "Masonry Building"),
  SurveyTitle(form: "Form 1B", code: "L1:RC", name: "Reinforced Concrete Building"),
];
