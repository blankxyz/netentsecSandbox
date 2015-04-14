/*
*RogerSun
*2014-04-21
*客户的专员负责人变更后相应的序列号明细中的专员也变更
*/
public class cbl_accountChangeCharge {
	//自定义异常对象  
    public class MyException extends Exception {}
	public void cbl_accountChangeCharge_afterUpdate(list<Account> listAccount,map<id,Account> mapOldAccount,map<id,Account> mapAccount)
	{
		set<string> setAccountId=new set<string>();
		for(Account a:listAccount)
		{
			if(a.ResponsibleForCustomerSpecialist__c!=mapOldAccount.get(a.id).ResponsibleForCustomerSpecialist__c)
			{
				setAccountId.add(a.id);
			}
		}
		
		if(setAccountId!=null && setAccountId.size()>0)
		{
			map<id,ProductSN__c> mapProductSN=new map<id,ProductSN__c>([select id,name,coustmer__c from ProductSN__c where coustmer__c in:setAccountId]);
			//throw new MyException('信息：'+mapAccount+'+'+mapProductSN);
			list<ProductSNDetial__c>  listProductSNDetial=new list<ProductSNDetial__c>([select id,AccountCommissioner__c,	ProductSN__c from ProductSNDetial__c where ProductSN__c in:mapProductSN.keyset()]);
			if(listProductSNDetial!=null && listProductSNDetial.size()>0)
			{
				for(ProductSNDetial__c po:listProductSNDetial)
				{
					po.AccountCommissioner__c=mapAccount.get(mapProductSN.get(po.ProductSN__c).coustmer__c).ResponsibleForCustomerSpecialist__c;
				}
				update listProductSNDetial;
			}
			
		}
	}
	public void cbl_accountCheckRepeat(list<Account> listAccount)
	{
		system.debug('listAccount is infor:'+listAccount);
		set<string> setAccountName=new set<string>();
		set<string> setAccountSellArea=new set<string>();
		for(Account a:listAccount)
		{
			if(a.IsConversion__c!='转换')
			{
				system.debug('信息进来'+a.IsConversion__c);
				setAccountName.add(a.name);
			    setAccountSellArea.add(a.SellArea__c);
			}
			
		}
		if(setAccountName!=null && setAccountName.size()>0)
		{
			list<Lead> listLead=new list<Lead>([Select l.Company,l.suozaibumen__c From Lead l where l.Company in:setAccountName and l.suozaibumen__c in:setAccountSellArea]);
			system.debug('listLead is infor:'+listLead);
			map<string,Lead> mapLead=new map<string,Lead>();
			if(listLead!=null && listLead.size()>0)
			{
				for(Lead l:listLead)
				{
					mapLead.put(l.Company+l.suozaibumen__c,l);
				}
				for(Account a:listAccount)
				{
					if(mapLead.containsKey(a.name+a.SellArea__c))
					{
						a.addError('该部门下存在潜在客户：'+a.name);
					}
				}
			}
		}
		
		
		
	}
	

}