/**
*Test:trgTest_Product_AutoInfo
*Author:Vito_He
*Time:2013年5月13日13:31:21
**/
@isTest(SeeAlldata=true) 
private class trgTest_Product_AutoInfo {

    static testMethod void myUnitTest() {
    	//产品级别
    	list<ProductionLevel__c> proLevels = new list<ProductionLevel__c>();
    	list<Product2> productList = new list<Product2>();
    	ProductionLevel__c p1 = new ProductionLevel__c();
    	p1.n_level__c = '一级';
    	proLevels.add(p1);
    	
    	ProductionLevel__c p2 = new ProductionLevel__c();
    	p2.n_level__c = '二级';
    	proLevels.add(p2);
    	
    	ProductionLevel__c p3 = new ProductionLevel__c();
    	p3.n_level__c = '三级';
    	proLevels.add(p3);
    	
    	ProductionLevel__c p4 = new ProductionLevel__c();
    	p4.n_level__c = '四级';
    	proLevels.add(p4);
    	insert proLevels;
        
        Product2 pro1 = new Product2();
        pro1.Name = 'lenove1';
        pro1.n_FirstLevel__c = p1.id;
        pro1.n_SecondLevel__c = p2.id;
        pro1.n_ThirdLevel__c = p3.id;
        pro1.n_FourLevel__c = p4.id;
        pro1.Family = 'ICG';
        productList.add(pro1);
        
        Product2 pro2 = new Product2();
        pro2.Name = 'lenove2';
        pro2.n_FirstLevel__c = p1.id;
        pro2.n_SecondLevel__c = p2.id;
        pro2.n_ThirdLevel__c = p3.id;
        pro2.n_FourLevel__c = p4.id;
        pro2.Family = 'ITM';
        productList.add(pro2);
        
        Product2 pro3 = new Product2();
        pro3.Name = 'lenove3';
        pro3.n_FirstLevel__c = p1.id;
        pro3.n_SecondLevel__c = p2.id;
        pro3.n_ThirdLevel__c = p3.id;
        pro3.n_FourLevel__c = p4.id;
        pro3.Family = 'NGFW';
        productList.add(pro3);
        
        Product2 pro4 = new Product2();
        pro4.Name = 'lenove4';
        pro4.n_FirstLevel__c = p1.id;
        pro4.n_SecondLevel__c = p2.id;
        pro4.n_ThirdLevel__c = p3.id;
        pro4.n_FourLevel__c = p4.id;
        pro4.Family = 'NPS';
        productList.add(pro4);
        
        Product2 pro5 = new Product2();
        pro5.Name = 'lenove5';
        pro5.n_FirstLevel__c = p1.id;
        pro5.n_SecondLevel__c = p2.id;
        pro5.n_ThirdLevel__c = p3.id;
        pro5.n_FourLevel__c = p4.id;
        pro5.Family = 'ASG';
        productList.add(pro5);
        
        Product2 pro6 = new Product2();
        pro6.Name = 'lenove5';
        pro6.n_FirstLevel__c = p1.id;
        pro6.n_SecondLevel__c = p2.id;
        pro6.n_ThirdLevel__c = p3.id;
        pro6.n_FourLevel__c = p4.id;
        pro6.Family = 'M';
        productList.add(pro6);
        
        Product2 pro7 = new Product2();
        pro7.Name = 'lenove5';
        pro7.n_FirstLevel__c = p1.id;
        pro7.n_SecondLevel__c = p2.id;
        pro7.n_ThirdLevel__c = p3.id;
        pro7.n_FourLevel__c = p4.id;
        pro7.Family = 'WOG';
        productList.add(pro7);
        
        Product2 pro8 = new Product2();
        pro8.Name = 'lenove5';
        pro8.n_FirstLevel__c = p1.id;
        pro8.n_SecondLevel__c = p2.id;
        pro8.n_ThirdLevel__c = p3.id;
        pro8.n_FourLevel__c = p4.id;
        pro8.Family = '再销售';
        productList.add(pro8);
        
        Product2 pro9 = new Product2();
        pro9.Name = 'lenove5';
        pro9.n_FirstLevel__c = p1.id;
        pro9.n_SecondLevel__c = p2.id;
        pro9.n_ThirdLevel__c = p3.id;
        pro9.n_FourLevel__c = p4.id;
        pro9.Family = '培训费';
        productList.add(pro9);
        
        Product2 pro10 = new Product2();
        pro10.Name = 'lenove5';
        pro10.n_FirstLevel__c = p1.id;
        pro10.n_SecondLevel__c = p2.id;
        pro10.n_ThirdLevel__c = p3.id;
        pro10.n_FourLevel__c = p4.id;
        pro10.Family = '维修费';
        productList.add(pro10);
        
        Product2 pro11 = new Product2();
        pro11.Name = 'lenove5';
        pro11.n_FirstLevel__c = p1.id;
        pro11.n_SecondLevel__c = p2.id;
        pro11.n_ThirdLevel__c = p3.id;
        pro11.n_FourLevel__c = p4.id;
        pro11.Family = '服务产品';
    	productList.add(pro11);
    	 
    	insert productList;
    }
}