// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';

// Temporary stubs while we build out a PlatformMessages-based implementation.

const Duration delay = const Duration(seconds: 1);

class FirebaseDatabase {
  FirebaseDatabase() {
    // Add fake data to the database
    new Timer(delay, _addFakeData);
  }

  void _addFakeData() {
    DatabaseReference._childAdded.add(new Event({
      'sender': {
        'name': 'Collin Jackson',
        'color': Colors.purple[500].value,
      },
      'text': 'Hello'
    }));
    DatabaseReference._childAdded.add(new Event({
      'sender': {
        'name': 'Seth Ladd',
        'color': Colors.blue[500].value,
      },
      'text': 'Ahoy-hoy!'
    }));
  }

  static FirebaseDatabase _instance = new FirebaseDatabase();
  static FirebaseDatabase get instance => _instance;
  DatabaseReference reference() => new DatabaseReference();
}

class DatabaseReference {
  static StreamController<Event> _childAdded = new StreamController<Event>();
  Stream<Event> get onChildAdded => _childAdded.stream;
  DatabaseReference push() => new DatabaseReference();
  Future set(Map<String, dynamic> value) {
    _childAdded.add(new Event(value));
    return new Future.value(value);
  }
}

class FirebaseAuth {
  static FirebaseAuth get instance => new FirebaseAuth();
  Future signInAnonymously() {
    return new Future.value(<String, dynamic>{});
  }
}

class Event {
  Event(dynamic val) : snapshot = new DataSnapshot(val);
  final DataSnapshot snapshot;
}

class DataSnapshot {
  dynamic _val;
  DataSnapshot(this._val);
  dynamic val() => _val;
}

class FirebaseMessaging {
}
