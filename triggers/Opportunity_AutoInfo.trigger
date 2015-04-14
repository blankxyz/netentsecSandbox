/**
*Dis:创建业务机会时给区域办事处主任，区域销售经理赋值
*Dis:创建业务机会时给   客户区域办事处主任，客户区域销售助理 赋值
*Dis:创建业务机会自动给技术支持邮件赋值
*Dis:创建业务机会时，当销售区域为空时，自动给销售区域加上创建人的所在区域，并且可以进行修改
*Dis:
*Author：Gary_Hu
*Time:2013年4月2日13:13:43
*Modify:Vito_He 如果阶段为丢单的时候，丢单原因必须填写，销售区域为空的时候默认为员工的区域
*********************我是高雅华丽的分割线*********************************
*Time:2014年3月13日16:19:25
*Dis:报备业务机会以后新建事件，推送给销售副主任。在用户对象加一个字段“是否弹出业务机会报备事件提醒”（字段仅对销售副主任和系统管理员可见）
*Author:Gary_Hu
*********************我是高雅华丽的分割线*********************************
*RogerSun
*982578975@qq.com
*1、业务机会所有人变更后销售自动添加销售部门  cbl_OpportunityChangeOwner
*2、跨区报备的客户、订单、业务机会共享给客户所在区域办事处主任
*2014-05-22
**/
trigger Opportunity_AutoInfo on Opportunity (before insert,before update) {

cbl_OpportunityChangeOwner OpportunityChangeOwner=new cbl_OpportunityChangeOwner();
    Set<Id> acId = new Set<Id>();       //查询负责人信息，根据区域
    String uProFile = null;             //商务简档
    ID selaAearId = null;
    set<Id> sId = new set<Id>(); //区域Id
    set<Id> uId = new set<Id>(); //用户Id
    set<Id> oId = new set<Id>(); //所有人Id
        if(trigger.isBefore)
        {
            if(trigger.isInsert)
            {
                OpportunityChangeOwner.cbl_OpportunityChangeOwner_ChangeOwner(trigger.new);
                for(Opportunity opp:trigger.new)
                {
                    if(opp.AccountId != null){
                    acId.add(opp.AccountId);
                    }
                    if(opp.SalesRegion__c != null){
                        sId.add(opp.SalesRegion__c);
                    }
                    if(opp.OwnerId != null){
                        oId.add(opp.OwnerId);
                    }
                }
                 
            }
            else if(trigger.isUpdate)
            {
                list<Opportunity> listOpportunity=new list<Opportunity>();
                 listOpportunity=new list<Opportunity>();
                for(Opportunity opp:trigger.new)
                {
                   
                    Opportunity oppOld=trigger.oldMap.get(opp.id);
                    if(opp.OwnerId!=oppOld.OwnerId)
                    {
                        listOpportunity.add(opp);
                       
                    }
                    if(opp.AccountId!=oppOld.AccountId || opp.OwnerId!=oppOld.OwnerId || opp.SalesRegion__c!=oppOld.SalesRegion__c)
                    {
                        acId.add(opp.AccountId);
                        sId.add(opp.SalesRegion__c);
                        oId.add(opp.OwnerId);
                    }
                   
                }
                 OpportunityChangeOwner.cbl_OpportunityChangeOwner_ChangeOwner(listOpportunity);
            }
        }
   
     //自定义异常对象  
    public class MyException extends Exception {}
   
    
    if(sId  != null && sId.size()>0)
    {
        //键为所选区域，值为区域(区域办事处主任,区域销售助理)
        map<id,SalesRegion__c> mapOfficeX = new map<id,SalesRegion__c>([Select OfficeDirector__c,OperationsAssistant__c From SalesRegion__c s where Id in: sId]);
        
        //键为所选客户，值为区域(客户所在区域办事处主任,客户区域销售助理,客户工程师)
        map<id,Account> mapAccountX = new map<id,Account>([select SellArea__r.OfficeDirector__r.Email,SellArea__r.OfficeDirector__c, SellArea__r.OperationsAssistant__c,CustomerEngineerX__r.Email,SellArea__c,CustomerEngineer__r.Email  from Account where Id in: acId]);
         system.debug('mapAccountX的集合信息是：'+mapAccountX);
        //获取客户下的的SE负责人的电子邮件
        
        
        for(Opportunity opp:trigger.new){
            if(mapOfficeX.size() > 0){
                if(mapOfficeX.containsKey(opp.SalesRegion__c)){
                    opp.AreaCha__c = mapOfficeX.get(opp.SalesRegion__c).OfficeDirector__c;  
                    opp.AreaManager__c = mapOfficeX.get(opp.SalesRegion__c).OperationsAssistant__c;     
                }
            }else{
                opp.addError('对不起该区域下没有区域办事处主任，区域销售助理，请重新选择销售区域,或者完善区域下的相关信息');
            }
            if(mapAccountX.size() > 0){
                if(mapAccountX.containsKey(opp.AccountId)){
                    opp.AccAearCha__c = mapAccountX.get(opp.AccountId).SellArea__r.OfficeDirector__c; 
                    system.debug('客户所在销售主任'+opp.AccAearCha__c); 
                    opp.AccAearMan__c = mapAccountX.get(opp.AccountId).SellArea__r.OperationsAssistant__c;
                    opp.AcountcAear__c = mapAccountX.get(opp.AccountId).SellArea__c;
                    //如果勾选了需要se,且客户工程师为空
                    if(opp.NeedSE__c == true){
                        if(mapAccountX.get(opp.AccountId).CustomerEngineer__r.Email == null){
                            opp.TsEmail__c = mapAccountX.get(opp.AccountId).SellArea__r.OfficeDirector__r.Email;
                            System.debug('----------mapAccountX------------'+mapAccountX.get(opp.AccountId).CustomerEngineerX__r.Email);
                        }else{
                            system.debug('-------------???????????????????????????????-----------');
                            opp.TsEmail__c = mapAccountX.get(opp.AccountId).CustomerEngineer__r.Email;
                        }
                    }
                }
            }
        }
    
    }
    
    
    

    
  
    
    
    if(trigger.isUpdate){
        //获取当前用户的简档
        set<Id> oIdl = new set<Id>(); //所有人Id
        list <User> uProFileL = [Select u.Profile.Name, u.ProfileId From User u where (u.Profile.Name = '渠道部简档' or u.Profile.Name = '系统管理员' ) and u.Id =: UserInfo.getUserId()];
        for(Opportunity o : trigger.new){
            if( trigger.oldMap.get(o.id).Status__c == o.Status__c && o.Status__c == '报备成功'){
                oIdl.add(o.OwnerId);
            }
        }
        
        //报备业务机会以后新建事件，推送给销售副主任。
        if(oIdl != null && oIdl.size() > 0){
             //键为所选区域，值为区域(区域办事处主任,区域销售助理,是否弹出业务机会报备事件提醒)
             list<Employee__c> listEmpDeputy = new list<Employee__c>([Select n_EmployeeName__c,n_salesDeputy__c,n_salesDeputy__r.EventToRemind__c,n_salesDeputy__r.SpecialRemind__c,n_salesDeputy__r.Email from Employee__c where  n_EmployeeName__c in: oIdl]);
             System.debug(oId+'----------oId-------------');
             System.debug(listEmpDeputy+'---------------listEmpDeputy--------------');
             //键为 员工名称、值为员工对象
             map<Id,Employee__c> mapEmpsalesDeputy = new map<Id,Employee__c>();
             if(listEmpDeputy.size() > 0){
                for(Employee__c listEmpDeputyX : listEmpDeputy){
                    System.debug(listEmpDeputyX.n_salesDeputy__c+'---------------listEmpDeputyX.n_salesDeputy__c--------------');
                    if(!mapEmpsalesDeputy.containsKey(listEmpDeputyX.n_salesDeputy__c)){
                        mapEmpsalesDeputy.put(listEmpDeputyX.n_EmployeeName__c,listEmpDeputyX);
                    }
                }
             }
             System.debug('-----------mapEmpsalesDeputy---------------'+mapEmpsalesDeputy);
             //活动
             List<Task> taskList = new List<Task>();
             if(mapEmpsalesDeputy.size() > 0){
                 for(Opportunity o : trigger.new){
                    
                    if(trigger.oldMap.get(o.id).Status__c != o.Status__c){
                        System.debug('fffffffffffffffff'+o.OwnerId);
                        if(mapEmpsalesDeputy.containsKey(o.OwnerId)){
                                System.debug('xxxx--new--xxxx'+mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__r.EventToRemind__c+'xxxxxx'+o.Status__c+'xxxxxx'+mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__r);
                                if(mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__c != null){
                                    
                                    if(o.Status__c == '报备审批中' && mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__r.EventToRemind__c == true){
                                        Task task = new Task();
                                        task.OwnerId=  mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__c;//被分配人
                                        task.WhatId = o.Id;
                                        task.Subject = o.Name+'商机报备成功提醒';//主题
                                        task.Description = '报备成功通知提醒';
                                        task.Status = '未开始';// 状态
                                        task.Priority = '普通';// 优先级别
                                        task.IsReminderSet = true; //是否提醒（提醒）
                                        task.ReminderDateTime = DateTime.now().addMinutes(1);   
                                        taskList.add(task); 
                                        if(Trigger.oldMap.get(o.id).SalesDealingMan__c != mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__c)
                                        {
                                            o.SalesDealingMan__c = mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__c;
                                            o.SalseDealingManEmail__c = mapEmpsalesDeputy.get(o.OwnerId).n_salesDeputy__r.Email;
                                        }
                                    }
                                }
                            }
                        }
                    }
                 //添加任务
                 insert(taskList);
                 
               }
             }
        }
        
         
        
        
    }