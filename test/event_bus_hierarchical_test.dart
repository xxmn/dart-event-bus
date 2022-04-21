import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:test/test.dart';

class EventA extends SuperEvent {
  String text;

  EventA(this.text);
}

class EventB extends SuperEvent {
  String text;

  EventB(this.text);
}

class SuperEvent {}

main() {
  group('[EventBus] (hierarchical)', () {
    test('Listen on same class', () {
      List<EventA> events = [];
      // given
      EventBus eventBus = EventBus();
      eventBus.addListener<EventA>(
        (EventA e) => events.add(e),
        onDone: () => expect(events.length, 1),
      );

      // when
      eventBus.fire(EventA('a1'));
      eventBus.fire(EventB('b1'));
      eventBus.destroy();
    });

    test('Listen on superclass', () {
      List<SuperEvent> events = [];
      // given
      EventBus eventBus = EventBus();
      eventBus.addListener<SuperEvent>(
        (SuperEvent e) => events.add(e),
        onDone: () => expect(events.length, 2),
      );

      // when
      eventBus.fire(EventA('a1'));
      eventBus.fire(EventB('b1'));
      eventBus.destroy();
    });
  });
}
