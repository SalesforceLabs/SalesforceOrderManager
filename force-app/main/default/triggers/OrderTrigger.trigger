trigger OrderTrigger on Order(after update) {
  if (OrderService.runOnce()) {
    List<Order> ordersWithUpdatedStatus = new List<Order>();
    for (Order ord : (List<Order>) Trigger.new) {
      Order oldOrd = Trigger.oldMap.get(ord.ID);
      if (ord.Status != oldOrd.Status) {
        ordersWithUpdatedStatus.add(ord);
      }
    }
    OrderService.orderUpdateHandler(ordersWithUpdatedStatus);
  }
}
