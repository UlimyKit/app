import 'model/symptom.dart';

class Symptoms {
  static const List<Symptom> symptomList = [
    Symptom(
        name: "Itchy eyes",
        description: "Eyes feel irritated, watery or itchy.",
        reactions: [
          "Rubbing eyes",
        ],
      ),
      Symptom(
        name: "Globus sensation",
        description:
            "A feeling of a lump, tightness, or something stuck in the throat.",
        reactions: [
          "Urge to swallow",
        ],
      ),
      Symptom(
        name: "Itchy palate",
        description: "Tickling/itching sensation on the roof of your mouth.",
        reactions: [
          "Coughing",
          "Throat clearing",
          "Tongue rubbing in the throat",
          "Saliva pumping in the throat",
        ],
      ),
      Symptom(
        name: "Itchy ears",
        description: "Itching sensation on or inside the ears.",
        reactions: [
          "Rubbing the ears",
        ],
      ),
      Symptom(
        name: "Running nose",
        description: "A nose that keeps dripping or feels wet.",
        reactions: [
          "Sniffing",
        ],
      ),
  ];
}