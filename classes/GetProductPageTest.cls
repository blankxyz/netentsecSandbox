@isTest(SeeAllData=true)
private class GetProductPageTest
{
    @isTest
    static void itShould()
    {
        
        // Given
        //用户
        RecordType RecordTypeData=[Select r.Name, r.Id, r.DeveloperName,r.Description From RecordType r where r.DeveloperName='customer'];
        SalesRegion__c SalesRegion=[Select s.Name, s.Id From SalesRegion__c s where s.Name='上海办事处'];
        CustomerAccount__c a=new CustomerAccount__c();
        Account acc=new Account();
                a.AddressNote__c='合肥';
                a.AddressType__c='sd';
                a.Email__c='982578975@qq.com';
                a.dailishangshuxingField3__c='T1';
                a.Phone__c='123456789';
                a.TwoIndustries__c='金融';
                a.ThreeIndustries__c='商业';
                a.AccountType__c=RecordTypeData.Id;
                a.CustomerServiceLevel__c='sdf';
                a.PrimaryIndustry__c='金融';
                a.Identity__c='好看';
                a.County__c='中国';
                a.ChannelType__c='拂去';
                a.IsService__c='true';
                a.IsMailAddress__c='是';
                a.SellArea__c=SalesRegion.id;
                a.City__c='上海';
                a.Province__c='嘉定';
                a.DetailedAddress__c='详细地址';
                a.Influence__c='十几块';
                a.Name='上海怡海软件技术有限公司';
        insert a;
        system.debug('CustomerID' + acc.id);
        //序列号
        List<ProductSN__c> addProductSNs = new List<ProductSN__c>();
        for(integer i=0;i<20;i++){
            addProductSNs.add(new ProductSN__c(
                ProductCategory__c = 'WOG',
                ProductStatus__c = '在用',
                Name = 'Test'  + i,
                coustmer__c = acc.id
                ));
        }
        insert addProductSNs;
        

        Project_Task__c t = new Project_Task__c(Customer__c = acc.id);
        insert t;
        t = [select id , Customer__c from Project_Task__c where id=:t.id];
        //List<ProductSN__c> 

        //Project_Task__c t = [select id, Customer__c from Project_Task__c where Customer__c != null limit 1 ];
    
        // When
        PageReference pageRef = Page.getProduct;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('clientid', t.Customer__c );
        ApexPages.currentPage().getParameters().put('taskid', t.Id );

        // Then
        getProductControllor ctl = new getProductControllor();
        ctl.selectIds = '\''+addProductSNs[0].id + '\',\'' +addProductSNs[1].id + '\'';
        ctl.getProductList();
        String nextPage = ctl.addProduct().getURL();

        System.assertEquals('/apex/getProduct?clientId='+t.Customer__c + '&TaskId='+t.id, nextPage);

        ctl = new getProductControllor();

        nextPage = ctl.addProduct().getURL();

    }
}