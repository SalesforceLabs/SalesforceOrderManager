/** Create Pricebook, Product2 record, Order and OrderItem */

/*********Create Price Book  */
    Pricebook2 priceBook = new Pricebook2(
        Name = 'Price Book 2',
        Description = 'This is the Price Book description.',
        IsActive = true
        );
    insert priceBook;

    /*********Create Product & Pricebook Entry */

    Product2 product = new Product2(
        Name = 'Product Test for Asset',//change the product name if required
        Description = 'This is the Product description.',
        Family = 'Example Product Family',
        QuantityUnitOfMeasure = 'inches',
        DisplayUrl = 'https://www.example.com/',
        ExternalId = 'ID #1234',
        //orderManager__External_Id__c = '0000001', //change the product id if required
        IsActive = true,
        orderManager__Create_Asset__c = true
    );
    insert product;
    Product2 product2 = new Product2(
        Name = 'Product Test 2 - non Asset',//change the product name if required
        Description = 'This is the Product description.',
        Family = 'Example Product Family',
        QuantityUnitOfMeasure = 'inches',
        DisplayUrl = 'https://www.example.com/',
        ExternalId = 'ID #1234',
        //orderManager__External_Id__c = '0000002', //change the product id if required
        IsActive = true
    );
    insert product2;


    Pricebook2 standardPriceBook = [
        SELECT Id
        FROM Pricebook2
        WHERE isStandard = true
        LIMIT 1
    ];
    PricebookEntry standardPriceBookEntry = new PricebookEntry(
        Pricebook2Id = standardPriceBook.Id,
        Product2Id = product.Id,
        UnitPrice = 100.00,
        UseStandardPrice = false,
        IsActive = true
    );

    insert standardPriceBookEntry;

        PricebookEntry standardPriceBookEntry2 = new PricebookEntry(
        Pricebook2Id = standardPriceBook.Id,
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

/*********Create Accounts & Order */
    List <Account> accs = new List <Account>();
    for (Integer i = 0; i<10; i++ ){
        Account acc = new Account();
        acc.Name = 'Account generated via script 3nd try ' + i; 
        accs.add(acc);
    }
    insert accs;
    for (Integer i = 0; i<accs.size(); i++){
        Order order = new Order();
        order.AccountId = accs[i].id;
        order.Status = 'Draft';
        order.Type = 'Activation';
        order.EffectiveDate = system.today();
        insert order;
    }

/*********Create OrderItem  */
        OrderItem oi = new OrderItem();
        oi.EndDate = system.today()+100;
        oi.Product2Id = '01t5400000AyyaQAAR';
        oi.OrderId = '80154000001YIYtAAO';
        oi.PricebookEntryId = [SELECT Id FROM PricebookEntry Limit 1].id;
        oi.Quantity = 2;
        insert oi;

