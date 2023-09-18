import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

class UserSatatusWidget extends ConsumerStatefulWidget {
  const UserSatatusWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserStatusWidget();
}

class _UserStatusWidget extends ConsumerState<UserSatatusWidget> {
  bool _isExtand = false;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontSize: 14,
        fontWeight: FontWeight.normal);
    return Column(children: [
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton.icon(
            onPressed: () => {
              setState(() {
                _isExtand = !_isExtand;
              })
            },
            label: const Text('User Options Info', style: style),
            // ignore: dead_code
            icon: _isExtand
                ? const Icon(
                    Icons.keyboard_arrow_up_sharp,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
      Container(
        height: 1,
        color: Colors.white24,
      ),
      if (_isExtand) const UserStatusExtendWidget()
    ]);
  }
}

class UserStatusExtendWidget extends ConsumerWidget {
  const UserStatusExtendWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var attentionScore =
        ref.watch<SeeSoProvider>(seesoProvider).attentionInfo?.attentionScore ??
            0;
    const style = TextStyle(
        color: Colors.white,
        decoration: TextDecoration.none,
        fontSize: 14,
        fontWeight: FontWeight.normal);
    return Column(
      children: [
        Container(
            width: double.maxFinite,
            height: 48,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "User Options Info",
                  style: style,
                ),
                Text(
                  "${(attentionScore * 100).toInt()}",
                  style: style,
                )
              ],
            )),
        Container(
          height: 1,
          color: Colors.white24,
        ),
        Container(
            width: double.maxFinite,
            height: 48,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Blink State",
                  style: style,
                ),
                Text(
                  //todo isBlink
                  ref.watch<SeeSoProvider>(seesoProvider).blinkInfo?.isBlink ??
                          false
                      ? "Ȕ _ Ű"
                      : "Ȍ _ Ő",
                  style: style,
                )
              ],
            )),
        Container(
          height: 1,
          color: Colors.white24,
        ),
        Container(
            width: double.maxFinite,
            height: 48,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Do i look seepy now..?",
                  style: style,
                ),
                Text(
                  //todo isDrowsiness
                  ref
                              .watch<SeeSoProvider>(seesoProvider)
                              .drowsinessInfo
                              ?.isDrowsiness ??
                          false
                      ? "Yes.."
                      : "NOPE !",
                  style: style,
                )
              ],
            ))
      ],
    );
  }
}
