public without sharing class OrderSelector {
    public static List <Order> getOrderbyId (Id orderId, List<String> fields, List<String> fieldsValues  ) {
        Order order = new Order();
        List<Order> orderList = new List<Order>();
        if(fields.size()==0){
            order = [ SELECT Id, Status FROM ORDER WHERE id =: orderId];
            orderList.add(order);
            }
        if(fields.size()==1){
            String field = fields[0];
            String fieldValue = fieldsValues[0];
            orderList = Database.query('SELECT Id, ' + field + ' FROM Order WHERE Id =:orderid AND '+ field + ' =: fieldValue');
            }
        return orderList;
    }
}