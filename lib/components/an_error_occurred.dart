import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnErrorOccurred extends StatelessWidget {
  const AnErrorOccurred({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.anErrorOccurred,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            AppLocalizations.of(context)!.tryAgainLater,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (Navigator.canPop(context))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(AppLocalizations.of(context)!.goBack),
              ),
            ),
        ],
      ),
    );
  }
}
