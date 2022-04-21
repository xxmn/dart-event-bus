import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:test/test.dart';

class EventA {
  String text;

  EventA(this.text);
}

class EventB {
  String text;

  EventB(this.text);
}

class EventWithMap {
  Map myMap;

  EventWithMap(this.myMap);
}

main() {
  group('[EventBus]', () {
    test('Fire one event', () {
      List<EventA> events = [];
      // given
      EventBus eventBus = EventBus();
      eventBus.addListener<EventA>(
        (e) => events.add(e),
        onDone: () {
          // print("-----------on Done.............");
          expect(events.length, 2);
        },
      );

      // when
      eventBus.fire(EventA('a1'));
      eventBus.fire(EventA('a2'));
      eventBus.destroy();
    });

    test('Fire two events of same type', () {
      List<EventA> events = [];
      // given
      EventBus eventBus = EventBus();
      eventBus.addListener<EventA>(
        (e) => events.add(e),
        onDone: () => expect(events.length, 2),
      );

      // when
      eventBus.fire(EventA('a1'));
      eventBus.fire(EventA('a2'));
      eventBus.destroy();
    });

    test('Fire events of different type', () {
      List<EventA> eventsA = [];
      List<EventB> eventsB = [];

      // given
      EventBus eventBus = EventBus();
      eventBus.addListener<EventA>(
        (e) => eventsA.add(e),
        onDone: () => expect(eventsA.length, 1),
      );
      eventBus.addListener<EventB>(
        (e) => eventsB.add(e),
        onDone: () => expect(eventsB.length, 1),
      );

      // when
      eventBus.fire(EventA('a1'));
      eventBus.fire(EventB('b1'));
      eventBus.destroy();
    });

    test('Fire events of different type, receive all types', () {
      List events = [];

      // given
      EventBus eventBus = EventBus();
      eventBus.addListener(
        (e) => events.add(e),
        onDone: () => expect(events.length, 3),
      );

      // when
      eventBus.fire(EventA('a1'));
      eventBus.fire(EventB('b1'));
      eventBus.fire(EventB('b2'));
      eventBus.destroy();
    });

    test('Fire event with a map type', () {
      List<EventWithMap> events = [];
      // given
      EventBus eventBus = EventBus();
      eventBus.addListener<EventWithMap>(
        (e) => events.add(e),
        onDone: () => expect(events.length, 1),
      );

      // when
      eventBus.fire(EventWithMap({'a': 'test'}));
      eventBus.destroy();
    });
  });
}
