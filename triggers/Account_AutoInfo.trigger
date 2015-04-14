/**
*Dis:自动生成客户编号：年月日+4位流水号
*Dis:若客户为最终客户：“6”+“年（后两位）月日”+“流水号（4位）。流水号以天为单位，每天从1开始。
*Dis:若客户为渠道代理商：“3”+“年（后两位）月日”+“流水号（4位）。流水号以天为单位，每天从1开始。
*Dis:添加客户查重，系统自动提醒“此客户已存在，请联系**(手机号)”。
*Dis:自动加客户区域。
*Author：Gary
*Date:2013年3月28日9:55:56
**/
trigger Account_AutoInfo on Account (before insert,before update) {

    Integer intSerialNo = 0;//客户编号流水号
    Integer intSerialNoC = 0;//渠道代理商编号流水号
    Integer intSerialNoF = 0;//最终客户编号流水号
    Date dtToday = Date.today();
    Integer intYear = dtToday.year();           
    Integer intMonth = dtToday.month();
    Integer intDay = dtToday.day();
    DataFormat df = new DataFormat();
    String strMonth = df.IntToString(intMonth, 2);
    String strDay = df.IntToString(intDay, 2);
    String recordTypeS = null;//记录名称
    Set<Id> aTid = new Set<Id>(); //类型Id
    set<String> aName = new set<String>(); //客户名称
    Boolean isSe = false;   //销售区域SE
    Set<Id> sId = new Set<Id>(); //销售区域
    set<Id> linkId = new set<Id>();//联系人信息
    //map<id,String> maprecordTypeS = new map<id,String>(); //类型Id为键，类型名称为值
    for(Account acct:trigger.new){
        //记录类型编号
        if(acct.RecordTypeId != null){
            aTid.add(acct.RecordTypeId);
        }
        //客户名称
        if(Trigger.isInsert||(Trigger.isUpdate&&Trigger.oldMap.get(acct.id).name!=acct.Name)){
            if(acct.Name != null){
                aName.add(acct.Name);
            }
        }
        if(acct.SellArea__c != null){
            sId.add(acct.SellArea__c);
        }
        
        //是否需要SE
        if(acct.SEchange__c == true){
            isSe = true;
        }

    }

    
    
    

    if(trigger.isInsert){
        map<id,RecordType> maprec = new map<id,RecordType>([select Name from RecordType where id in : aTid]);
        if(maprec.size() != 0){
            //客户编号
            list<AutoNumberC__c> an = [select ID,SerialNo__c from AutoNumberC__c where Name='AccountC']; //获取随机编号for客户
                for(Account acc:trigger.new){
                    if(acc.AccountNumber == null){
                        if(an.size() > 0){
                            for(AutoNumberC__c anX : an){
                                intSerialNo = Integer.valueOf(anX.SerialNo__c);
                                intSerialNo++;
                                if(maprec.containsKey(acc.RecordTypeId))
                                {
                                    RecordType rec = maprec.get(acc.RecordTypeId);
                                    if(rec.Name=='最终客户')
                                    {
                                        acc.AccountNumber = 'F'+String.valueOf(intYear)+strMonth+strDay+df.IntToString(intSerialNo, 4);
                                    }
                                }
                                if(maprec.containsKey(acc.RecordTypeId)){
                                    RecordType rec=maprec.get(acc.RecordTypeId);
                                    if(rec.Name =='渠道代理商'){
                                        acc.AccountNumber = 'C'+String.valueOf(intYear)+strMonth+strDay+df.IntToString(intSerialNo, 4);
                                    }
                                }
                                anX.SerialNo__c = intSerialNo;
                            }
                        }
                    }
                }
                System.debug(intSerialNo+'++++++++++++intSerialNo++++++++++++++++');
                update an;
            
            
                //最终客户服务编号
                //list<AutoNumberS__c> anF =  [select ID,SerialNoS__c,YearS__c,MonthS__c,DayS__c from AutoNumberS__c where Name='AccountF']; 
                list<AutoNumberS__c> anF = new list<AutoNumberS__c>();
                list<AutoNumberS__c> anC = new list<AutoNumberS__c>();
                list<AutoNumberS__c> anAll = [select ID,SerialNoS__c,YearS__c,MonthS__c,DayS__c,Name from AutoNumberS__c];
                for(AutoNumberS__c autoN : anAll)
                {
                	if(autoN.Name=='AccountF')
                	{
                		anF.add(autoN);
                	} 
                	else if(autoN.Name=='AccountC')
                	{
                		anC.add(autoN);
                	}
                }
                //list<AutoNumberS__c> NewAuto=new list<AutoNumberS__c>();
                    for(Account accs:trigger.new){
                        if(maprec.containsKey(accs.RecordTypeId))
                            {
                                RecordType rec = maprec.get(accs.RecordTypeId);
                                if(rec.Name=='最终客户')
                                {
                                    
                                    System.debug(intSerialNoF+'+++++++++++intSerialNoF+++++++++++++');
                                    if(anF.size() > 0){
                                        for(AutoNumberS__c anFX : anF){
                                            if(anFX.YearS__c == intYear && anFX.MonthS__c == intMonth && anFX.DayS__c == intDay){
                                                intSerialNoF = Integer.valueOf(anFX.SerialNoS__c); 
                                                System.debug(intSerialNoF+'+++++++++intSerialNoF1++++++++++++++');
                                            }else{
                                                anFX.YearS__c = intYear;
                                                anFX.MonthS__c = intMonth;
                                                anFX.DayS__c = intDay;
                                                System.debug(intSerialNoF+'+++++++++intSerialNoF2++++++++++++++');
                                            }
                                            intSerialNoF ++;
                                            if(accs.n_ServiceCode__c == null){
                                                accs.n_ServiceCode__c = '6'+String.valueOf(intYear).subString(2)+strMonth+strDay+df.IntToString(intSerialNoF, 4);
                                            }
                                            
                                            anFX.SerialNoS__c = intSerialNoF;
                                            //System.debug(anFX.SerialNoS__c+'+++++++++++anFX.SerialNoS__c+++++++++++++');
                                            //NewAuto.add(anFX);
                                        }
                                    }
                                }
                            }
                    }
                    update anF; 
                    //渠道代理商编号流水号
                    //list<AutoNumberS__c> anC = [select Name,SerialNoS__c,YearS__c,MonthS__c,DayS__c from AutoNumberS__c where Name='AccountC']; 
                    map<String,AutoNumberS__c> mapAutC = new map<String,AutoNumberS__c>();
                    for(AutoNumberS__c anCx : anC){
                        if(!mapAutC.containsKey(string.valueOf(anCx.Name))){
                            mapAutC.put(string.valueOf(anCx.Name),anCx);
                        }
                    }
                    for(Account accc:trigger.new){
                        System.debug('+++++++++++++++++++++++++++=dddd!');
                        if(maprec.containsKey(accc.RecordTypeId)){
                            RecordType rec = maprec.get(accc.RecordTypeId);
                            if(rec.Name=='渠道代理商'){
                                
                                System.debug(intSerialNoC+'++++++++++++++++++++++++++++++++++');
                                String AccountC ='AccountC';
                                if(mapAutC.containsKey(AccountC)){
                                    System.debug(mapAutC.get(AccountC).SerialNoS__c+'mapAutC.get(AccountC).SerialNoS__c+++++++++++');
                                    if(mapAutC.get(AccountC).YearS__c  == intYear && mapAutC.get(AccountC).MonthS__c == intMonth && mapAutC.get(AccountC).DayS__c == intDay){
                                        intSerialNoC = Integer.valueOf(mapAutC.get(AccountC).SerialNoS__c) ;
                                    }else{
                                        mapAutC.get(AccountC).YearS__c = intYear;
                                        mapAutC.get(AccountC).MonthS__c = intMonth;
                                        mapAutC.get(AccountC).DayS__c = intDay;
                                    }
                                    intSerialNoC++;
                                    if(accc.n_ServiceCode__c == null){
                                        accc.n_ServiceCode__c = '3'+String.valueOf(intYear).subString(2)+strMonth+strDay+df.IntToString(intSerialNoC, 4);
                                    }
                                    
                                    mapAutC.get(AccountC).SerialNoS__c = intSerialNoC;
                                }
                            }
                        }
                    }
                update anC;
            }
        //获取联系人的相关信息
        /*
        for(Account acc:trigger.new)
        {
        	if(acc.LinkName__c != null)
        	{
        		acc.addError('对不起，该客户下还没有创建联系人您不能选取其他客户的联系人。如有需要，请先创建客户后，然后进行联系人添加');
        	}
        }
        list<Contact > listC = [select InvoiceAddress__c,Phone,PostCard__c from Contact where Id in : linkId];
		for(Contact listCX : listC)
		{
			for(Account acc:trigger.new)
			{
				if(listCX.InvoiceAddress__c != null)
				{
					acc.InvoiceAddress__c = listCX.InvoiceAddress__c;
				}
				if(listCX.Phone != null)
				{
					acc.LinkPhone__c = listCX.Phone;
				}
				if(listCX.PostCard__c != null)
				{
					acc.ZipCode__c = listCX.PostCard__c;
				}
			}
		}        
        */
        
    }

    if(aName.size()>0){
                //客户查重
        list<Account> list_acn = [select Name,Id,Owner.Name,Owner.MobilePhone  from Account where Name in : aName];
        //客户查重
        for(Account accCheck : trigger.new){
            if(trigger.isInsert){
                if(list_acn.size() != 0){
                    for(Account accRs : list_acn){
                        if(accRs.Name == accCheck.Name ){
                            accCheck.addError('此'+accRs.Name+'客户信息已存在，请联系'+accRs.Owner.Name+'(手机号：'+accRs.Owner.MobilePhone+')'); 
                        }
                    }
                }   
            }
            if(trigger.isUpdate){
                if(list_acn.size() != 0 &&  trigger.oldMap.get(accCheck.id).Name != accCheck.Name){
                    for(Account accRs : list_acn){
                        if(accRs.Name == accCheck.Name ){
                            accCheck.addError('此'+accRs.Name+'客户信息已存在，请联系'+accRs.Owner.Name+'(手机号：'+accRs.Owner.MobilePhone+')'); 
                            
                        }
                    }
                }
            }

            System.debug(sId.size()+'+++++++++++++sId.size()++++++++++++++++');
        }
    }


        //键为区域Id,值为区域Se
        map<id,SalesRegion__c> mapSeEm = new map<id,SalesRegion__c>([Select s.SEPersonInCharge__r.Email, s.SEPersonInCharge__c, s.OfficeDirector__r.Email, s.OfficeDirector__c From SalesRegion__c s where Id in: sId]);
        for(Account accInfo:trigger.new){
            //自动加客户区域,给se邮件赋值
            if(accInfo.SEchange__c == true && accInfo.SellArea__c != null){
                if(mapSeEm.size() > 0){
                    if(mapSeEm.containsKey(accInfo.SellArea__c)){
                        if(mapSeEm.get(accInfo.SellArea__c).SEPersonInCharge__r.Email != null){
                            accInfo.SeEmail__c = mapSeEm.get(accInfo.SellArea__c).SEPersonInCharge__r.Email;
                        }else{
                            accInfo.SeEmail__c = mapSeEm.get(accInfo.SellArea__c).OfficeDirector__r.Email;
                        }
                    }
                }
            }
        }
      /*
	    //当更改客户名称时，自动在chatter上发消息
	    if(Trigger.isUpdate){
		    for(Account accInfo:trigger.new){
				if(trigger.oldMap.get(accInfo.id).Name != accInfo.Name){
			    	FeedItem post = new FeedItem();
					post.ParentId = Userinfo.getUserId();
					post.Body= '将  '+trigger.oldMap.get(accInfo.id).Name+'  '+'修改成'+'  '+accInfo.Name + '  请知晓！';
					post.LinkUrl ='https://cs5.salesforce.com/'+accInfo.Id;
					insert post;
				}
		    }
		   
	    }
	   */
	//只允许的管理员的修改客户名称
	if(Trigger.isUpdate){
		//获取当前用户的简档
        list <User> uProFileL = [Select u.Profile.Name, u.ProfileId From User u where  u.Profile.Name = '系统管理员'  and u.Id =: UserInfo.getUserId()];
        System.debug(uProFileL.size()+'++++++++++++++++++');
        for(Account accInfo:trigger.new){
        	if(trigger.oldMap.get(accInfo.id).Name != accInfo.Name && uProFileL.size() == 0){
        		accInfo.addError('对不起，您不能修改该客户的名称，若要修改请联系管理员！');
        	}
        }
        for(Account accInfo:trigger.new)
        {
        	if(trigger.oldMap.get(accInfo.id).LinkName__c != accInfo.LinkName__c && accInfo.LinkName__c != null)
        	{
        		linkId.add(accInfo.LinkName__c);
        	}
        }
        if(linkId.size() > 0)
        {
        	 list<Contact > listC = [select InvoiceAddress__c,Phone,PostCard__c from Contact where Id in : linkId];
	         for(Contact listCX : listC)
			{
				for(Account acc:trigger.new)
				{
					if(listCX.InvoiceAddress__c != null)
					{
						acc.InvoiceAddress__c = listCX.InvoiceAddress__c;
					}
					if(listCX.Phone != null)
					{
						acc.LinkPhone__c = listCX.Phone;
					}
					if(listCX.PostCard__c != null)
					{
						acc.ZipCode__c = listCX.PostCard__c;
					}
				}
			}  
        }
        
	}
    
}