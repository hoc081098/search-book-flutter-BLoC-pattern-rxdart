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
  final Stream<Object> error$;

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
    this.error$,
    this.refresh,
    this._dispose,
  );

  factory DetailBloc(final BookApi api, final Book initial) {
    final refreshController = PublishSubject<Completer>();
    final errorController = PublishSubject<Object>();

    final book$ = DistinctValueConnectableObservable.seeded(
      refreshController.exhaustMap((completer) async* {
        try {
          yield await api.getBookById(initial.id);
        } catch (e) {
          errorController.add(e);
        } finally {
          if (completer != null && !completer.isCompleted) {
            completer.complete();
            completer = null;
          }
        }
      }),
      seedValue: initial,
    );

    final subscriptions = <StreamSubscription>[
      book$.listen((book) {}),
      book$.connect(),
    ];
    final controllers = <StreamController>[
      refreshController,
      errorController,
    ];

    return DetailBloc._(
      book$,
      errorController,
      () {
        final completer = Completer<void>();
        refreshController.add(completer);
        return completer.future;
      },
      () async {
        await Future.wait(subscriptions.map((s) => s.cancel()));
        await Future.wait(controllers.map((c) => c.close()));
      },
    );
  }

  @override
  void dispose() => _dispose();
}
