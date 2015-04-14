@isTest
private class clsAccountSearchTest {
    static testMethod void myUnitTest(){
    	Date dtToday = Date.today();
		Integer intYear = dtToday.year();			
		Integer intMonth = dtToday.month();
		Integer intDay = dtToday.day();
		DataFormat df = new DataFormat();
		String strMonth = df.IntToString(intMonth, 2);
		String strDay = df.IntToString(intDay, 2);
		
		List<AutoNumberC__c> anList = [select ID,SerialNo__c from AutoNumberC__c where Name='AccountC'];
        if(anList.size() == 0)
        {
            AutoNumberC__c an = new AutoNumberC__c();
            an.Name = 'AccountC';
            an.SerialNo__c=1;
            
            insert an;
            an.SerialNo__c++;
        }
        
        List<AutoNumberS__c> anF=	[select ID,SerialNoS__c,YearS__c,MonthS__c,DayS__c from AutoNumberS__c where Name='AccountF'];
        if(anF.size() == 0)
        {
            AutoNumberS__c an = new AutoNumberS__c();
            an.Name = 'AccountF';
            insert an;
        }
        
        
        List<AutoNumberS__c> anC = [select ID,SerialNoS__c,YearS__c,MonthS__c,DayS__c from AutoNumberS__c where Name='AccountC']; 
        if(anC.size() == 0)
        {
            AutoNumberS__c an = new AutoNumberS__c();
            an.Name = 'AccountC';
            insert an;
        }
        
        SalesRegion__c sr = new SalesRegion__c();
        sr.Name='华北';
        //sr.SalesVp__c='test';
        insert sr;
        User user = [select Id,Name,Department from User where id =: UserInfo.getUserId()];
        Employee__c emp=new Employee__c();
       	emp.n_EmployeeAear__c=sr.Id;
        emp.n_EmployeeName__c=user.Id;
        insert emp;
        
       
        
                
        list<Account> listAcc = new list<Account>();
        
        for(Integer i=0;i<30;i++){
             Account a = new Account();
              a.Name = 'test' + i;
              a.Industry = '消费类';
              a.Province__c = '河北';
              a.City__c = '石家庄';
              a.ZipCode__c = '450000';
              a.Website = 'www.frensworkz.com';
              a.PrimaryIndustry__c='金融';
			  a.TwoIndustries__c='债券';
			  a.ThreeIndustries__c='银行';
			  a.SellArea__c=sr.id;
			  a.Province__c='北京';
			  a.Phone='053187401697';
              listAcc.add(a);    
        }
        insert listAcc;
        
        SearchBlackWord__c sbw = new SearchBlackWord__c();
        sbw.name = 'Account';
        sbw.BlackWord__c = '有限公司';
        insert sbw;
        
        clsAccountSearch accSearch = new clsAccountSearch();
        accSearch.strKey = '有限公司';
        accSearch.searchAccount();
        accSearch.strKey = 'test有限公司';
        accSearch.searchAccount();
        accSearch.strKey = 'test';
        accSearch.searchAccount();
        
        accSearch.pageCount = 1;
        Integer pc = accSearch.pageCount;
        accSearch.pageNumber = 1;
        Integer ps = accSearch.pageNumber;
        accSearch.categoryNumber = 1;
        Integer cn = accSearch.categoryNumber;
        accSearch.hasNext = true;
        boolean hn = accSearch.hasNext;
        boolean hp = accSearch.hasPrevious;
        accSearch.first();
        accSearch.last();
        accSearch.previous();
        accSearch.next();
        
    }
}