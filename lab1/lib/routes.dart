import 'models/item.dart';
import 'models/profile.dart';

class Routes {
  static const home = '/';
  static const runDetails = '/run-details';
}

class RunDetailsArguments {
  const RunDetailsArguments({
    required this.item,
    required this.profile,
    required this.onParticipantsChanged,
    required this.onOpenProfile,
  });

  final Item item;
  final Profile profile;
  final Item Function(Item updatedItem) onParticipantsChanged;
  final void Function() onOpenProfile;
}
