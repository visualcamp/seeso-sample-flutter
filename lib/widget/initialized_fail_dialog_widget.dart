import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

class InitializedFailDialog extends ConsumerWidget {
  const InitializedFailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String failedReason =
        ref.watch<SeeSoProvider>(seesoProvider).failedReason != null
            ? ref.watch<SeeSoProvider>(seesoProvider).failedReason!
            : "unknown";
    return CupertinoAlertDialog(
      title: const Text('Failed'),
      content: Text(failedReason),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () =>
              {ref.read<SeeSoProvider>(seesoProvider).clearFailedReason()},
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
