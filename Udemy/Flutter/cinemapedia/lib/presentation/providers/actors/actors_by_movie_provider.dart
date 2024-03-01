import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef GetActorCallback = Future<Actor> Function(String movieId);

class ActorMapNotifier {}
