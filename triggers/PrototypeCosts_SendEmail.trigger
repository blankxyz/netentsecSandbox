//样机费用管理超标时发邮件提醒
//lurrykong
//2013.5.3
trigger PrototypeCosts_SendEmail on PrototypeCosts__c (after update) 
{
	set<id> setSaleArea=new set<id>();
	for(PrototypeCosts__c protype:trigger.new)
	{
		if(protype.n_SaleArea__c!=null)
			setSaleArea.add(protype.n_SaleArea__c);
	}
	//id,办公室主任,SE负责人,办公室主任电子邮件,SE负责人电子邮件			
	list<SalesRegion__c> listSale=[select id,OfficeDirector__c,SEPersonInCharge__c,OfficeDirectorEmail__c,SEPersonInChargeEmail__c from SalesRegion__c where id IN:setSaleArea];
	//销售区域id为键,办公室主任id为值
	map<id,string> mapProOff=new map<id,string>();
	//销售区域id为键,SE负责人id为值
	map<id,string> mapProSE=new map<id,string>();
	if(listSale.size()>0)
	{
		for(SalesRegion__c saler:listSale)
		{
			if(!mapProOff.containsKey(saler.id))
				mapProOff.put(saler.id,saler.OfficeDirectorEmail__c);				
			if(!mapProSE.containsKey(saler.id))
				mapProSE.put(saler.id,saler.SEPersonInChargeEmail__c);
		}
	}	
	//销售区域,年,季度为键,费用指标为值
	map<string,PrototypeCosts__c> mapProtypeCost=new map<string,PrototypeCosts__c>();
	
	for(PrototypeCosts__c protype:trigger.new)
	{
		PrototypeCosts__c oldprotype=trigger.oldMap.get(protype.id);
		if(oldprotype.IfOverWeight50__c==false&&protype.IfOverWeight50__c==true)				//首次超过50%
		{
			if(protype.n_SaleArea__c!=null&&protype.n_Year__c!=null&&protype.Quarter__c!=null)	//销售区域,年,季度不为空
			{
				string str=string.valueOf(protype.n_SaleArea__c)+string.valueOf(protype.n_Year__c)+string.valueOf(protype.Quarter__c);
				if(!mapProtypeCost.containsKey(str))
					mapProtypeCost.put(str,protype);
			}			
		}
		if(oldprotype.IfOverWeight80__c==false&&protype.IfOverWeight80__c==true)				//首次超过80%
		{
			if(protype.n_SaleArea__c!=null&&protype.n_Year__c!=null&&protype.Quarter__c!=null)	//销售区域,年,季度不为空
			{
				string str=string.valueOf(protype.n_SaleArea__c)+string.valueOf(protype.n_Year__c)+string.valueOf(protype.Quarter__c);
				if(!mapProtypeCost.containsKey(str))
					mapProtypeCost.put(str,protype);
			}			
		}
		if(oldprotype.IfOverWeight100__c==false&&protype.IfOverWeight100__c==true)				//首次超过100%	
		{
			if(protype.n_SaleArea__c!=null&&protype.n_Year__c!=null&&protype.Quarter__c!=null)	//销售区域,年,季度不为空
			{
				string str=string.valueOf(protype.n_SaleArea__c)+string.valueOf(protype.n_Year__c)+string.valueOf(protype.Quarter__c);
				if(!mapProtypeCost.containsKey(str))
					mapProtypeCost.put(str,protype);
			}			
		}
	}
	system.debug('..............................mapProtypeCost.values()...............................'+mapProtypeCost.values());
	
	//得出费用指标
	list<PrototypeCosts__c> listPrototypeCost=mapProtypeCost.values();
	
	if(listPrototypeCost.size()>0)
	{
		for(PrototypeCosts__c prc:listPrototypeCost)
		{
			 if(mapProOff.containsKey(prc.n_SaleArea__c)&&mapProSE.containsKey(prc.n_SaleArea__c))
			 {
			 	string Offemail=mapProOff.get(prc.n_SaleArea__c);	system.debug('..................Offemail.....................'+Offemail);
			 	string SEemail=mapProSE.get(prc.n_SaleArea__c);		system.debug('..................SEemail.....................'+SEemail);
			 	if(prc.IfOverWeight50__c==true)
			 	{
			 		DataFormat.SendEmail(prc.id,50,Offemail);
			 		DataFormat.SendEmail(prc.id,50,SEemail);
			 	}
			 	if(prc.IfOverWeight80__c==true)
			 	{
			 		DataFormat.SendEmail(prc.id,80,Offemail);
			 		DataFormat.SendEmail(prc.id,80,SEemail);
			 	}
			 	if(prc.IfOverWeight100__c==true)
			 	{	
			 		DataFormat.SendEmail(prc.id,100,Offemail);
			 		DataFormat.SendEmail(prc.id,100,SEemail);
			 	}
			 }
		}
	}
}