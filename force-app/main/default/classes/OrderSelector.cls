public without sharing class OrderSelector {
    private static String className = 'OrderSelector';
    public static  Order getOrderbyId (Id orderId, List<String> fieldsToQuery) {
        Order orderToCheck = new Order();
        List<Order> orderList = new List<Order>();
        System.debug('FieldsToQuery size is ' + fieldsToQuery.size());
        try{
            if(fieldsToQuery.size()==0){
            orderList = Database.query('SELECT Id FROM Order WHERE Id =:orderid');
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
                System.debug('The fields included in the query for the order are ' + query);
                orderList = Database.query('SELECT Id , ' + query + ' FROM Order WHERE Id =:orderid');
            }
            orderToCheck = orderList[0];
        }
        catch (QueryException e){
            ErrorHandling.createDMLError(e, className,orderId);
        }
        return orderToCheck;
    }
}