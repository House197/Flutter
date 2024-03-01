import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorInfoProvider = StateNotifierProvider<ActorMapNotifier, Map<String, Actor>>((ref) {
  final getMovie = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(getMovie: getMovie);
});

typedef GetActorCallback = Future<Actor> Function(String movieId);

class ActorMapNotifier {
  final GetActorCallback getActors;

  ActorMapNotifier({required this.getActors});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final movie = await getMovie(movieId);
    state = {...state, movieId: movie};
  }
}
