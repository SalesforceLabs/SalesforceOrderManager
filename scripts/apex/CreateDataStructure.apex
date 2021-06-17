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
        Name = ' Product Test',//change the product name if required
        Description = 'This is the Product description.',
        Family = 'Example Product Family',
        QuantityUnitOfMeasure = 'inches',
        DisplayUrl = 'https://www.example.com/',
        ExternalId = 'ID #1234',
        External_Id__c = '00000012', //change the product id if required
        IsActive = true
    );
    insert product;


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

    PricebookEntry priceBookEntry = new PricebookEntry(
        Pricebook2Id = priceBook.Id,
        Product2Id = product.Id,
        UnitPrice = 100.00,
        UseStandardPrice = false,
        IsActive = true
    );

    insert priceBookEntry;

/*********Create Accounts  */
    List <Account> accs = new List <Account>();
    for (Integer i = 0; i<10; i++) ){
        Account acc = new Account();
        acc.Name = 'Account generated via script ' + i; 
        accs.add(acc);
    }
    insert accs;
    for (Integer i = 0; i<accs.size(); i++) ){

    }


