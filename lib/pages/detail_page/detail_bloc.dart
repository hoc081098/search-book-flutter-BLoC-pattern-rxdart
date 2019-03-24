import 'dart:async';

import 'package:demo_bloc_pattern/api/book_api.dart';
import 'package:demo_bloc_pattern/model/book_model.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';

// ignore_for_file: close_sinks

class DetailBloc implements BaseBloc {
  ///
  ///
  ///
  final ValueObservable<Book> book$;

  ///
  ///
  ///
  final Future<void> Function() refresh;

  ///
  /// Clean up resource
  ///
  final void Function() _dispose;

  DetailBloc._(
    this.book$,
    this.refresh,
    this._dispose,
  );

  factory DetailBloc(final BookApi api, final Book initial) {
    final refreshController = PublishSubject<Completer>();

    final book$ = DistinctValueConnectableObservable.seeded(
      refreshController.exhaustMap((completer) {
        return Observable.fromFuture(api.getBookById(initial.id)).doOnEach((_) {
          if (completer != null && !completer.isCompleted) {
            completer.complete();
            completer = null;
          }
        });
      }),
      seedValue: initial,
    );

    final subscriptions = <StreamSubscription>[
      book$.listen((book) {}),
      book$.connect(),
    ];

    return DetailBloc._(
      book$,
      () {
        final completer = Completer<void>();
        refreshController.add(completer);
        return completer.future;
      },
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
      },
    );
  }

  @override
  void dispose() => _dispose();
}
