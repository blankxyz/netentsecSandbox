@isTest(SeeAllData=true)
//Quote_BuinessPeople触发器的测试类
//lurrykong
//2013.5.13
private class trgTest_Quote_BuinessPeople {

    static testMethod void myUnitTest() 
    {
	        Profile profile=[Select p.Name, p.Id From Profile p where Name='Chatter External User'];
	        Pricebook2 pricebook = [select Id from Pricebook2 where isStandard=true limit 1];
	    	User user=new User();											 
		    user.Phone='87413065';   
		    user.MobilePhone='15167988026';
		    user.Username='LurryKong@frensworkz.com28';
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
    		SalesRegion__c bussalesregion=new SalesRegion__c();
    		bussalesregion.OfficeDirector__c=user.id;
    		bussalesregion.Name='商务部';
    		insert bussalesregion;
    		Employee__c emp=new Employee__c();					//员工
    		emp.n_EmployeeAear__c=salesregion.id;
    		emp.n_EmployeeName__c=user.id;
    		insert emp;   		
    		Employee__c empBusine=new Employee__c();					//员工
    		empBusine.n_EmployeeAear__c=bussalesregion.id;
    		empBusine.n_EmployeeName__c=user.id;
    		insert empBusine;    		
	    	String Closetime='2005'+'-'+'10'+'-'+'5';
	        Date dte=date.valueOf(Closetime);
    		//记录类型
	        RecordType rtp= [Select r.Name, r.Id, r.Description From RecordType r where Name='渠道代理商'];    		
            Account acc=new Account();
	        acc.Name='五粮液';
	        acc.Fax='8088';
	        acc.Description='五粮液';
	        acc.Phone='053187401697';
	        acc.Industry='Finance';
	        acc.RecordTypeId=rtp.id;
	        acc.PrimaryIndustry__c='金融';
			acc.TwoIndustries__c='债券';
			acc.ThreeIndustries__c='银行';
			acc.SellArea__c=SalesRegion.id;
			acc.Province__c='北京';
	        
	    	insert acc;
	    	Opportunity opp=new Opportunity(); 
	        opp.Name='玩具';
	        opp.Description='业务机会';
	        opp.CloseDate=dte;  
	        opp.AccountId=acc.Id;
	        opp.StageName='开拓';
	        opp.Probability=100;					//可行性
	        opp.SalesRegion__c=salesregion.id;
	        insert opp; 
	    	Quote quote=new Quote();
	        quote.OpportunityId=opp.Id;
	        quote.Pricebook2Id=pricebook.Id;
	        quote.Name='报价';
	        quote.Status='已批准';
	        quote.Orders__c=false;
	        quote.yanhoukaipiaoliyouField3__c='延后开票';
	        insert quote;  
	        opp.StageName='关单';
	        update opp;
	        quote.Orders__c=true;
	        update quote;
    
    
    
    
    
    
    
    }
}