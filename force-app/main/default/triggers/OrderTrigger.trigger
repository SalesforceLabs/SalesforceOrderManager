trigger OrderTrigger on Order (after update) {
     if(OrderService.runOnce()){
        List<Order> orders = trigger.new;
        OrderService.orderUpdateHandler(orders);
     }
}