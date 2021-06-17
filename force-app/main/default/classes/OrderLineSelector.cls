public class OrderLineSelector {
    public static List <OrderItem> getOrderItemsbyOrderId (Id orderId){
        list<OrderItem > orderItems = new List<OrderItem>();
        orderItems = [SELECT FIELDS(STANDARD), Product2.orderManager__External_Id__c FROM OrderItem WHERE OrderId =: orderId];
        return orderItems;
    }
    public static List <OrderItem> getOrderItemsbyOrderIds (List<Id> orderIds){
        list<OrderItem > orderItems = new List<OrderItem>();
        orderItems = [SELECT FIELDS(STANDARD) FROM OrderItem WHERE OrderId =: orderIds];
        System.debug('Order Item size ' + orderItems.size());
        return orderItems;
    }
}