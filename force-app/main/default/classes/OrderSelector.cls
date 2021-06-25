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
        if(fields.size()==2){
            String field1 = fields[0];
            String fieldValue1 = fieldsValues[0];
            String field2 = fields[1];
            String fieldValue2 = fieldsValues[1];
            orderList = Database.query('SELECT Id, ' + field1 + ' , ' + field2 + ' FROM Order WHERE Id =:orderid AND '+ field1 + ' =: fieldValue1 AND ' + field2 + ' =: fieldValue2');
            }

        if(fields.size()==3){
            String field1 = fields[0];
            String fieldValue1 = fieldsValues[0];
            String field2 = fields[1];
            String fieldValue2 = fieldsValues[1];
            String field3 = fields[2];
            String fieldValue3 = fieldsValues[2];
            orderList = Database.query('SELECT Id, ' + field1 + ' , ' +  field2 + ' , ' +  field3 + ' FROM Order WHERE Id =:orderid AND '+ field1 + ' =: fieldValue1 AND ' + field2 + ' =: fieldValue2 AND ' + field3 + ' =: fieldValue3');
            }
        if(fields.size()==4){
            String field1 = fields[0];
            String fieldValue1 = fieldsValues[0];
            String field2 = fields[1];
            String fieldValue2 = fieldsValues[1];
            String field3 = fields[2];
            String fieldValue3 = fieldsValues[2];
            String field4 = fields[3];
            String fieldValue4 = fieldsValues[3];

            orderList = Database.query('SELECT Id, ' + field1 + ' , ' +  field2 + ' , ' +  field3 + ' , ' +  field4 + ' FROM Order WHERE Id =:orderid AND '+ field1 + ' =: fieldValue1 AND ' + field2 + ' =: fieldValue2 AND ' + field3 + ' =: fieldValue3 AND '+ field4 + ' =: fieldValue4');
            }
        return orderList;
    }
}