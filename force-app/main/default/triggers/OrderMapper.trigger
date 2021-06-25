trigger OrderMapperTrigger on orderManager__Order_Mapper__mdt (before Insert, before Update) {
    List<orderManager__Order_Mapper__mdt> orderMappers = trigger.new;
    List<orderManager__Order_Mapper__mdt> oldOrderMappers = trigger.old;
    Set<Id> existigRecords= new Set<Id>();
    /*
    for(orderManager__Order_Mapper__mdt orderMapper:orderMappers){
        existigRecords = OrderMapperService.validateRecord();
        if(existigRecords.size()>0){
            orderMapper.addError( new myException('Another Order Mapper record with the same configuration already exists'));
        }
    }
    */
}