import '../models/interaction.dart';

Interaction? findInteraction(
  String med1,
  String med2,
  List<Interaction> interactions,
) {
  for (final interaction in interactions) {
    if (interaction.involves(med1, med2)) {
      return interaction;
    }
  }
  return null;
}
