@isTest(SeeAllData=true)
private class SupportProject_test 
{
    static testMethod void myUnitTest() 
    {
        Profile profile=[Select p.Name, p.Id From Profile p where Name='售前技术'];
        User manager=new User();                                            
        manager.Phone='87413065';   
        manager.MobilePhone='15167988026';
        manager.Username='LurryKong@fccz.com17';
        manager.Alias='DeLi';  //匿称
        manager.CommunityNickname='DeLi';//绰号
        manager.TimeZoneSidKey='Australia/Sydney';
        manager.LocaleSidKey='en_AU';
        manager.EmailEncodingKey='ISO-8859-1';
        manager.ProfileId=profile.Id;
        manager.LanguageLocaleKey='en_US';
        manager.FirstName='于';
        manager.LastName='NN';
        manager.Fax='0031388';
        manager.Email='dlwork123@163.com';
        insert manager;
        
        User user=new User();                                            
        user.Phone='87413065';   
        user.MobilePhone='15167988026';
        user.Username='LurryKong1@fccz.com17';
        user.Alias='DeLi1';  //匿称
        user.CommunityNickname='DeLi1';//绰号
        user.TimeZoneSidKey='Australia/Sydney';
        user.LocaleSidKey='en_AU';
        user.EmailEncodingKey='ISO-8859-1';
        user.ProfileId=profile.Id;
        user.LanguageLocaleKey='en_US';
        user.FirstName='于';
        user.LastName='NN';
        user.Fax='0031388';
        user.Email='dlwork1213@163.com';
        user.ManagerId = manager.id;
        insert user;
        
        SalesRegion__c SalesRegion=new SalesRegion__c();
        SalesRegion.Name='华北云计算事业部';
        SalesRegion.SEPersonInCharge__c = user.id;
        insert SalesRegion;

        Account acc=new Account();
        acc.Phone='25652855';
        acc.PrimaryIndustry__c='金融';
        acc.TwoIndustries__c='债券';
        acc.ThreeIndustries__c='银行';
        acc.SellArea__c=SalesRegion.id;
        acc.Province__c='北京';
        acc.Name='客户test';
        //acc.SellArea__c=listSalesRegion[0].Id;
        
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name='业务机会test12';
        opp.StageName='初步';
        opp.CloseDate=Date.today();
        opp.AccountId=acc.Id;
        opp.SalesRegion__c=SalesRegion.id;
        opp.Status__c='状态test';
        opp.NeedSE__c=true;
        opp.TsEmail__c=null;
        opp.OppProperty__c='普通报备';
        opp.InterregionalApproval__c=true;
        opp.Status__c='报备审批中';
        opp.ApprovalDate__c=datetime.valueOfGmt(string.valueOf(datetime.now())).addDays(-5);
        insert opp;
                
        Employee__c emp = new Employee__c();
        emp.n_EmployeeAear__c = SalesRegion.Id;
        emp.n_EmployeeName__c = user.Id;
        emp.n_salesDeputy__c = user.Id;
        emp.Employee_Email__c = 'shuang_li@netentsec.com';
        insert emp;
        
        SupportProjectApply__c  spa = new SupportProjectApply__c ();
        spa.Opportunity__c=opp.id;
        
        insert spa;
        spa.Project_Manager__c=emp.id;
        spa.approve_status__c='审批成功';
        update spa;

        
         Project__c proj = new Project__c();
        proj.Opportunity__c=opp.id;
        proj.Project_Manager__c =emp.id;
        proj.Deadline__c= Date.today();
        proj.Kickoff__c= Date.today();
        insert proj;
        
        Project_TeamMember__c projTeam = new Project_TeamMember__c();
        projTeam.project__c = proj.id;
        projTeam.Team_Member__c = emp.id;
        insert projTeam;
        
        Project_TeamMember__c projTeam2 = new Project_TeamMember__c();
        projTeam2.project__c = proj.id;
        projTeam2.Team_Member__c = emp.id;
        insert projTeam2;
        delete projTeam2;
        
        Milestone__c projMile = new Milestone__c();
        projMile.Project__c = proj.id;
        insert projMile;
        
        Project_Task__c projTask = new Project_Task__c();
        projTask.Project_Milestone__c = projMile.id;
        projTask.Assigned_To__c = emp.id;
        projTask.name = '测试';
        projTask.Start_Date__c = datetime.now();
        projTask.Due_Date__c = datetime.now();
        insert projTask;
        
        Time__c projTime = new Time__c();
        projTime.Date_Incurred__c= Date.today();
        projTime.StartTime__c= datetime.now();
        projTime.EndTime__c= datetime.now().addMinutes(1);
        projTime.Project_Task__c = projTask.id;
        insert projTime ;
        

    }
}