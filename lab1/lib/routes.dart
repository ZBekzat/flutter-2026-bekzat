import 'models/item.dart';
import 'models/profile.dart';

class Routes {
  static const home = '/';
  static const runDetails = '/run-details';
  static const runForm = '/run-form';
}

class RunDetailsArguments {
  const RunDetailsArguments({
    required this.item,
    required this.profile,
    required this.onParticipantsChanged,
    required this.onDeleteRun,
    required this.onOpenProfile,
    required this.onEditRun,
  });

  final Item item;
  final Profile profile;
  final Item Function(Item currentItem, Item updatedItem) onParticipantsChanged;
  final void Function(Item item) onDeleteRun;
  final void Function() onOpenProfile;
  final Future<Item?> Function(Item item) onEditRun;
}

class RunFormArguments {
  const RunFormArguments({this.item});

  final Item? item;
}
