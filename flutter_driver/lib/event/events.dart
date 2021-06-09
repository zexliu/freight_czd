import 'package:event_bus/event_bus.dart';
import 'package:flutterdriver/model/deliver_goods_entity.dart';

EventBus eventBus = EventBus();

class AuthenticatedEvent {
  AuthenticatedEvent();
}


class DeliveryPublishedEvent {
  DeliveryPublishedEvent();
}


class DeliveryOrderedEvent {
  DeliveryOrderedEvent();
}

class DeliveryDeletedEvent{

  final DeliverGoodsRecord record;

  DeliveryDeletedEvent(this.record);
}



class DeliveryMarkedEvent{

  final DeliverGoodsRecord record;

  DeliveryMarkedEvent(this.record);
}

class HomePageChangedEvent{

  final int index;

  HomePageChangedEvent(this.index);
}

