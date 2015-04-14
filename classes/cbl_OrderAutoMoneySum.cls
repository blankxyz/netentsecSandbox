/*
*RogerSun
*2014-04-18
*
*跨区报备的业务机会共享给客户所在区域的办事处主任
*/
public  class cbl_OrderAutoMoneySum 
{
   //Select o.SalesOpportunities__r.OppProperty__c, o.SalesOpportunities__r.AccAearCha__c, o.SalesOpportunities__c, o.Id From Orders__c o
   public void cbl_OrderAutoMoneySum_afterInsert(list<Orders__c> listOrders)
   {
   	    map<id,Opportunity> mapOpportunity=new map<id,Opportunity>();
   	    mapOpportunity=returnOpportunit(listOrders);
   	    list<Orders__Share> listOrdersShare=new list<Orders__Share>();
   		for(Orders__c o:listOrders)
   		{
   			if(o.SalesOpportunities__r.AccAearCha__c!=null)
   			{
   				Orders__Share OrdersShare=new Orders__Share();
   				OrdersShare.AccessLevel='Read';
   				OrdersShare.ParentId=o.id;
   				OrdersShare.UserOrGroupId=mapOpportunity.get(o.SalesOpportunities__c).AccAearCha__c;
   				OrdersShare.RowCause='SharingAccount__c';
   				listOrdersShare.add(OrdersShare);
   			}
   		}
   		if(listOrdersShare!=null && listOrdersShare.size()>0)
   		{
   			insert listOrdersShare;
   		}
   }
   
   public map<id,Opportunity> returnOpportunit(list<Orders__c> listOrders)
   {
   		map<id,Opportunity> mapOpportunity;
   		set<string> setOpportunityId=new set<string>();
   		for(Orders__c o:listOrders)
   		{
   			setOpportunityId.add(o.SalesOpportunities__c);
   		}
   		if(setOpportunityId!=null && setOpportunityId.size()>0)
   		{
   			mapOpportunity=new map<id,Opportunity>([Select o.Id, o.AccAearCha__c From Opportunity o where o.Id in:setOpportunityId]);
   			
   		}
   		return mapOpportunity;
   }
}