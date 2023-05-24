@isTest
public class OrderService_Test {
  @testSetup
  static void setup() {
    Pricebook2 priceBook = new Pricebook2(
      Name = 'Price Book 2',
      Description = 'This is the Price Book description.',
      IsActive = true
    );
    insert priceBook;

    Product2 product = new Product2(
      Name = 'Product Test for Asset',
      Description = 'This is the Product description.',
      Family = 'Example Product Family',
      QuantityUnitOfMeasure = 'inches',
      DisplayUrl = 'https://www.example.com/',
      ExternalId = 'ID #1234',
      IsActive = true,
      orderManager__Create_Asset__c = true
    );
    insert product;
    Product2 product2 = new Product2(
      Name = 'Product Test 2 - non Asset',
      Description = 'This is the Product description.',
      Family = 'Example Product Family',
      QuantityUnitOfMeasure = 'inches',
      DisplayUrl = 'https://www.example.com/',
      ExternalId = 'ID #1234',
      IsActive = true
    );
    insert product2;

    Id standardPricebookId = Test.getStandardPricebookId();
    /*
        Pricebook2 standardPriceBook = [
            SELECT Id
            FROM Pricebook2
            WHERE isStandard = true
            LIMIT 1
        ];
        */
    PricebookEntry standardPriceBookEntry = new PricebookEntry(
      Pricebook2Id = standardPricebookId,
      Product2Id = product.Id,
      UnitPrice = 100.00,
      UseStandardPrice = false,
      IsActive = true
    );

    insert standardPriceBookEntry;

    PricebookEntry standardPriceBookEntry2 = new PricebookEntry(
      Pricebook2Id = standardPricebookId,
      Product2Id = product2.Id,
      UnitPrice = 100.00,
      UseStandardPrice = false,
      IsActive = true
    );

    insert standardPriceBookEntry2;

    PricebookEntry priceBookEntry = new PricebookEntry(
      Pricebook2Id = priceBook.Id,
      Product2Id = product.Id,
      UnitPrice = 100.00,
      UseStandardPrice = false,
      IsActive = true
    );

    insert priceBookEntry;

    PricebookEntry priceBookEntry2 = new PricebookEntry(
      Pricebook2Id = priceBook.Id,
      Product2Id = product2.Id,
      UnitPrice = 100.00,
      UseStandardPrice = false,
      IsActive = true
    );

    insert priceBookEntry2;

    List<Account> accs = new List<Account>();
    for (Integer i = 0; i < 10; i++) {
      Account acc = new Account();
      acc.Name = 'Account generated for test ' + i;
      accs.add(acc);
    }
    insert accs;
    for (Integer i = 0; i < accs.size(); i++) {
      Order order = new Order();
      order.AccountId = accs[i].id;
      order.Status = 'Draft';
      order.Type = '';
      order.EffectiveDate = system.today();
      order.Pricebook2Id = priceBook.id;
      insert order;
    }
    Id accId = [
      SELECT Id, Name
      FROM Account
      WHERE NAme = 'Account generated for test 0'
      LIMIT 1
    ]
    .id;
    OrderItem oi = new OrderItem();
    oi.EndDate = system.today() + 100;
    oi.Product2Id = [
      SELECT Id, Name
      FROM Product2
      WHERE Name = 'Product Test for Asset'
      LIMIT 1
    ]
    .id;
    oi.OrderId = [SELECT Id, AccountId FROM Order WHERE AccountId = :accid].id;
    oi.PricebookEntryId = priceBookEntry.id;
    oi.Quantity = 2;
    oi.UnitPrice = 20;
    insert oi;
  }

  @isTest
  static void orderToAsset() {
    orderManager__Order_Mapper__mdt orderMapper = [
      SELECT
        Id,
        DeveloperName,
        orderManager__Active__c,
        orderManager__Order_Status__c,
        orderManager__Source_Object__c,
        orderManager__Source_Object_Record_Type__c,
        orderManager__Target_Object2__c
      FROM orderManager__Order_Mapper__mdt
      WHERE DeveloperName = 'Order_to_Asset' AND orderManager__Active__c = TRUE
      LIMIT 1
    ];

    orderManager__Order_Filter__mdt orderFilter = [
      SELECT
        Id,
        orderManager__Field_Name__c,
        orderManager__Field_Value__c,
        orderManager__Order_Mapper__c
      FROM orderManager__Order_Filter__mdt
      WHERE
        orderManager__Order_Mapper__c = :orderMapper.id
        AND orderManager__Field_Name__c = 'Type'
      LIMIT 1
    ];

    List<orderManager__Order_Mapper__mdt> orderMappers = OrderMapperSelector.getOrderMappers();

    Id accId = [
      SELECT Id, Name
      FROM Account
      WHERE NAme = 'Account generated for test 0'
      LIMIT 1
    ]
    .id;
    Order orderToProcess = [
      SELECT Id, AccountId, Type, Status
      FROM Order
      WHERE AccountId = :accid
      LIMIT 1
    ];
    orderToProcess.Status = orderMapper.orderManager__Order_Status__c;
    orderToProcess.Type = orderFilter.orderManager__Field_Value__c;
    update orderToProcess;

    OrderItem oi = [
      SELECT Id, EndDate, Quantity
      FROM OrderItem
      WHERE OrderId = :orderToProcess.Id
      LIMIT 1
    ];
    orderToProcess.Status = 'Activated';
    update orderToProcess;
    List<Asset> assetCreated = new List<Asset>(
      [
        SELECT Id, InstallDate, Quantity
        FROM Asset
        WHERE AccountId = :accid
        LIMIT 1
      ]
    );
    if (assetCreated.size() > 0) {
      System.assertEquals(
        assetCreated[0].InstallDate,
        oi.EndDate,
        'Asset Installed Date is not equal to the Order Item End Date'
      );
    }
  }

  @isTest
  static void orderToAssetOrderWithException() {
    List<orderManager__Order_Mapper__mdt> orderMappers = OrderMapperSelector.getOrderMappers();
    System.debug(
      'The size of the order mapper is ' +
        orderMappers.size() +
        ' and status on the Order Mapper is ' +
        orderMappers[0].orderManager__Order_Status__c +
        ' and the Active flas is set to ' +
        orderMappers[0].orderManager__Active__c
    );
    Id accId = [
      SELECT Id, Name
      FROM Account
      WHERE NAme = 'Account generated for test 1'
      LIMIT 1
    ]
    .id;
    Order orderToProcess = [
      SELECT Id, AccountId, Status
      FROM Order
      WHERE AccountId = :accid
      LIMIT 1
    ];

    List<String> fieldsToQuery = new List<String>();
    fieldsToQuery.add('NEVER_EXISTING_FIELD');
    test.startTest();
    Order filteredOrder = new Order();
    try {
      filteredOrder = OrderSelector.getOrderbyId(
        orderToProcess.id,
        fieldsToQuery
      );
    } catch (QueryException e) {
      System.assert(
        e.getMessage().contains('OrderSelector'),
        'Unexpected exception message.'
      );
    }
    test.stopTest();
  }
  @isTest
  static void orderLineSelectorException() {
    List<orderManager__Order_Mapper__mdt> orderMappers = OrderMapperSelector.getOrderMappers();
    System.debug(
      'The size of the order mapper is ' +
        orderMappers.size() +
        ' and status on the Order Mapper is ' +
        orderMappers[0].orderManager__Order_Status__c +
        ' and the Active flas is set to ' +
        orderMappers[0].orderManager__Active__c
    );
    Id accId = [
      SELECT Id, Name
      FROM Account
      WHERE NAme = 'Account generated for test 1'
      LIMIT 1
    ]
    .id;
    Order orderToProcess = [
      SELECT Id, AccountId, Status
      FROM Order
      WHERE AccountId = :accid
      LIMIT 1
    ];

    List<String> fieldsToQuery = new List<String>();
    fieldsToQuery.add('NEVER_EXISTING_FIELD');
    test.startTest();
    try {
      list<OrderItem> orderItems = new List<OrderItem>(
        OrderLineSelector.getOrderItemsbyOrderIdFiltered(
          orderToProcess.id,
          fieldsToQuery
        )
      );
    } catch (QueryException e) {
      System.assert(
        e.getMessage().contains('OrderLineSelector'),
        'Unexpected exception message.'
      );
    }
    test.stopTest();
  }

  @isTest
  static void customException() {
    Id accId = [
      SELECT Id, Name
      FROM Account
      WHERE NAme = 'Account generated for test 0'
      LIMIT 1
    ]
    .id;
    Order orderToProcess = [
      SELECT Id, AccountId, Status
      FROM Order
      WHERE AccountId = :accid
      LIMIT 1
    ];
    test.startTest();
    ErrorHandling.createCustomError(
      'OrderLineSelector',
      orderToProcess.Id,
      'Description'
    );

    test.stopTest();
    orderManager__Error_Handler__c errorHandler = [
      SELECT Id, Class_Name__c, Description__c
      FROM orderManager__Error_Handler__c
      WHERE orderManager__Order_Id__c = :orderToProcess.Id
      LIMIT 1
    ];
    System.assert(
      errorHandler.Class_Name__c.contains('OrderLineSelector'),
      'Unexpected exception message.'
    );
  }
}
