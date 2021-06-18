trigger OrderTrigger on Order (after update) {
     if(OrderService.runOnce()){
        List<Order> orders = trigger.new;
        List<Order> oldOrders = trigger.old;
        List<Order> ordersWithUpdatedStatus = new List<Order>();
        for(Order ord : orders){
            Order oldOrd = Trigger.oldMap.get(ord.ID);
            if(ord.Status != oldOrd.Status) {
                ordersWithUpdatedStatus.add(ord);
            }
        }
        OrderService.orderUpdateHandler(ordersWithUpdatedStatus);
     }
}