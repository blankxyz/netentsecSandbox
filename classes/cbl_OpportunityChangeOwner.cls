/*
*1、业务机会所有人变更后自动添加销售部门
*
*RogerSun
*982578975@qq.com
*2014-04-18
*/
public class cbl_OpportunityChangeOwner {
     //自定义异常对象  
    public class MyException extends Exception {}
    public void cbl_OpportunityChangeOwner_ChangeOwner(list<Opportunity> listOpportunity)
    {
       if(listOpportunity != null && listOpportunity.size() > 0 )
       {
            set<string> setOpp=new set<string>();
            for(Opportunity opp:listOpportunity)
            {
                setOpp.add(opp.OwnerId);
            }
            list<Employee__c> listEmployee=new list<Employee__c>([Select e.n_salesDeputy__c, e.UserName__c, e.n_EmployeeAear__c, e.n_EmployeeAear__r.OperationsAssistant__c, e.n_EmployeeAear__r.OfficeDirector__c,e.n_EmployeeName__c, e.Id From Employee__c e where e.n_EmployeeName__c in:setOpp]);
            map<string,Employee__c> mapEmployee=new map<string,Employee__c>();
            if(listEmployee!=null && listEmployee.size()>0)
            {
                for(Employee__c e:listEmployee)
                {
                    mapEmployee.put(e.n_EmployeeName__c,e);
                } 
                for(Opportunity opp:listOpportunity)
                {
                    opp.SalesRegion__c=mapEmployee.get(opp.OwnerId).n_EmployeeAear__c;
                    opp.AreaCha__c = mapEmployee.get(opp.OwnerId).n_EmployeeAear__r.OfficeDirector__c;
                    opp.AreaManager__c = mapEmployee.get(opp.OwnerId).n_EmployeeAear__r.OperationsAssistant__c;
                }
            }
       }
       
        
    }
    public void cbl_OpportunityChangeOwner_ShareInfor(list<Opportunity> listOpportunity)
    {
        list<OpportunityShare> listOpportunityShare=new list<OpportunityShare>();
        for(Opportunity opp:listOpportunity)
        {
            if(opp.OppProperty__c=='跨区报备' && opp.AccAearCha__c!=opp.OwnerId)
            {
                system.debug('listOpportunity 的信息是:'+listOpportunity);
                OpportunityShare OpportunityShareData=new OpportunityShare();
                OpportunityShareData.UserOrGroupId=opp.AccAearCha__c;
                OpportunityShareData.OpportunityAccessLevel='Read';
                OpportunityShareData.OpportunityId =opp.id;
                listOpportunityShare.add(OpportunityShareData);
                
            }
            
        }
        if(listOpportunityShare!=null && listOpportunityShare.size()>0)
        {
            system.debug('listOpportunityShare is infor:'+listOpportunityShare);
            insert listOpportunityShare;
        }
    }
    public void cbl_OpportunityChangeOwner_UpdateShareInfor(list<Opportunity> listOpportunity,map<id,Opportunity> mapOldOpportunity)
    {
        list<OpportunityShare> listOpportunityShare=new list<OpportunityShare>();
        set<string> setOpportunityId=new set<string>();
        set<string> setUserId=new set<string>();
        set<string> setOldUserId=new set<string>();
        map<id,Opportunity> mapOpportunity=new map<id,Opportunity>();
        for(Opportunity opp:listOpportunity)
        {
            Opportunity oppOld=mapOldOpportunity.get(opp.id);
            if((opp.OppProperty__c!=oppOld.OppProperty__c || opp.OwnerId!=oppOld.OwnerId )&& opp.OppProperty__c=='跨区报备' && opp.OwnerId != opp.AccAearCha__c)
            {
                OpportunityShare OpportunityShareData=new OpportunityShare();
                OpportunityShareData.UserOrGroupId=opp.AccAearCha__c;
                OpportunityShareData.OpportunityAccessLevel='Read';
                OpportunityShareData.OpportunityId =opp.id;
                listOpportunityShare.add(OpportunityShareData);
                if(opp.OwnerId!=oppOld.OwnerId)
                {
                    
                    setOldUserId.add(oppOld.AccAearCha__c);
                }
                setOpportunityId.add(opp.id);
                setUserId.add(opp.AccAearCha__c);
                mapOpportunity.put(opp.id,opp);
            }   
        }
        if(listOpportunityShare!=null && listOpportunityShare.size()>0)
        {
            insert listOpportunityShare;
        }
        if(setOpportunityId!=null && setOldUserId!=null)
        {
            list<OpportunityShare> listOldOpportunityShare=new list<OpportunityShare>([Select o.UserOrGroupId, o.RowCause, o.OpportunityId, o.OpportunityAccessLevel, o.Id From OpportunityShare o where o.UserOrGroupId in:setOldUserId and o.OpportunityId in:setOpportunityId]);
            if(listOldOpportunityShare!=null && listOldOpportunityShare.size()>0)
            {
                
                //delete listOldOpportunityShare;
            }
            set<string> setOrderId=new set<string>();
            list<Orders__c> listOrders=new list<Orders__c>([Select o.SalesOpportunities__c, o.Id From Orders__c o where o.SalesOpportunities__c in:setOpportunityId]);
            list<Orders__Share> listOrdersShare=new list<Orders__Share>();
            if(listOrders!=null && listOrders.size()>0)
            {
                for(Orders__c o:listOrders)
                {
                    setOrderId.add(o.id);
                    Orders__Share OrdersShare=new Orders__Share();
                    OrdersShare.AccessLevel='Read';
                    OrdersShare.ParentId=o.id;
                    OrdersShare.UserOrGroupId=mapOpportunity.get(o.SalesOpportunities__c).AccAearCha__c;
                    listOrdersShare.add(OrdersShare);
                }
            }
            list<Orders__Share> listOldOrdersShare=new list<Orders__Share>();
            if(setOrderId!=null && setOrderId.size()>0)
            {
                listOldOrdersShare=[Select o.UserOrGroupId, o.RowCause, o.ParentId, o.Id From Orders__Share o where o.UserOrGroupId in:setOldUserId and o.ParentId in:setOrderId];
            }
            if(listOldOrdersShare!=null && listOldOrdersShare.size()>0)
            {
                //delete listOldOrdersShare;
            }
            if(listOrdersShare !=null && listOrdersShare.size()>0)
            {
                insert listOrdersShare;
            }
            
        }
    }
}