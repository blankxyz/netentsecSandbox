/**
*Test:clsOppAutoUpdate
*Author:Gary_Hu
*Time:2013年5月15日19:07:16
**/

@isTest
private class trg_TestclsOppAutoUpdate {

    static testMethod void myUnitTest() {
        Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
        list<RecordType> listrtp=[Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='ChannelCustomers']; 
        list<RecordType> listrOp=[Select r.Name, r.Id, r.Description From RecordType r where DeveloperName='OPPService'];
         DateTime nowToday = Date.today();  //当前时间
        User user=new User();                                            
        user.Phone='87413065';   
        user.MobilePhone='15167988026';
        user.Username='LurryKong@fccz.com8';
        user.Alias='DeLi';  //匿称
        user.CommunityNickname='DeLi';//绰号
        user.TimeZoneSidKey='Australia/Sydney';
        user.LocaleSidKey='en_AU';
        user.EmailEncodingKey='ISO-8859-1';
        user.ProfileId=profile.Id;
        user.LanguageLocaleKey='en_US';
        user.FirstName='于';
        user.LastName='NN';
        user.Fax='0031388';
        user.Email='dlwork123@163.com';
        insert user;

        SalesRegion__c salesregion=new SalesRegion__c();
        salesregion.OfficeDirector__c=user.id;
        salesregion.Name='日本';
        insert salesregion;  
        Account acc=new Account();
        acc.Name='五粮液';
        acc.Fax='8088';
        acc.Description='五粮液';
        acc.Phone='053187401697';
        acc.Industry='Finance';
        acc.RecordTypeId=listrtp[0].id;
        acc.PrimaryIndustry__c='金融';
		acc.TwoIndustries__c='债券';
		acc.ThreeIndustries__c='银行';
		acc.SellArea__c=SalesRegion.id;
		acc.Province__c='北京';
        insert acc;
        Opportunity opp=new Opportunity();      
        opp.OppProperties__c='商业市场';       
        opp.Name='五粮液商机';
        opp.Description='业务机会';
        opp.CloseDate=  Date.valueOf(nowToday.addDays(-40));
        opp.AccountId=acc.Id;
        opp.StageName='开拓';
        opp.Probability=100;                    //可行性
        opp.SalesRegion__c = salesregion.Id;
        opp.NeedSE__c = true;
        opp.RecordTypeId = listrOp[0].Id;
        opp.OwnerId = UserInfo.getUserId();
        insert opp;
        Test.startTest();
        scheduleOppAutoUpdate soda = new scheduleOppAutoUpdate();
        clsOppAutoUpdate coda = new clsOppAutoUpdate();
        Database.executeBatch(coda,50);
        string schLead = DateTime.now().second()+' '+DateTime.now().minute()+' '+DateTime.now().hour()+' * * ?';
        system.schedule('TestclsOppAutoUpdate',schLead,soda);
        Test.stopTest(); 
        
        
        
        

           
    }
}