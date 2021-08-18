public class OrderLineSelector {
    private static String className = 'OrderLineSelector';

    public static List <OrderItem> getOrderItemsbyOrderIdFiltered (Id orderId, List<String> fieldsToQuery){
        list<OrderItem > orderItemsReturned = new List<OrderItem>();
        try {
            list<OrderItem > orderItems = new List<OrderItem>();
            if(fieldsToQuery.size()==0){
                orderItems = [SELECT FIELDS(STANDARD),Order.AccountId, Product2.orderManager__External_Id__c, Product2.Name,
                                Product2.orderManager__Create_Asset__c 
                                FROM OrderItem WHERE OrderId =: orderId AND Product2.orderManager__Create_Asset__c = true];
            }
            if(fieldsToQuery.size()!=0){
                String query = ' ';
                for(Integer i = 0; i < fieldsToQuery.size(); i++){
                    String fieldName = fieldsToQuery[i];
                    if(i!=fieldsToQuery.size()-1){
                        query = query + ' ' + fieldName + ' , ';
                    }
                    if(i == fieldsToQuery.size()-1) {
                        query = query + ' '+ fieldName + ' ';
                    }
                }
                System.debug('The fields included in the query for the order item are ' + query);
                String queryString = 'SELECT Id , OrderId , Order.AccountId , Product2.Name, Product2.orderManager__Create_Asset__c ,  ' + query + ' FROM OrderItem WHERE OrderId = :orderId AND Product2.orderManager__Create_Asset__c = true';
                System.debug('OrderLineSelector - The query is ' + queryString);
                orderItems = Database.query(queryString);
                for (OrderItem oi : orderItems){
                    orderItemsReturned.add(oi);
                }
            }
        } catch (QueryException e){
            String errorDescription = 'Order Line Selector failed';
            ErrorHandling.createError(e, className,orderId, errorDescription);
        }
        System.debug('The Number of order items returned is ' + orderItemsReturned.size());
        return orderItemsReturned;
    }
}