/**
*Dis:数据处理格式化
*Author：Gary_Hu
*Time:2013年3月28日10:25:13
**/
//发送电子邮件
//lurrykong
//2013.5.11
public class DataFormat {
	
	public set<string> setService=new set<string>{'服务产品','再销售','培训费','维修费','FU3','UVP','QA'};	//服务产品
	public set<string> setEquipMent=new set<string>{'ICG','ITM','NGFW','NPS','ASG(VPN)','ASG','M','WOG','NGFW设备模式','NGFW服务模式Y1-Y2','NGFW服务模式Y3-Y5'};	//设备产品
	public set<string> setPart=new set<string>{'配件'}; 		//配件
	
	public map<string,string> mapGetService()
	{
		map<string,string> mapService=new map<string,string>();
		for(string s:setService)
		{
			mapService.put(s,s);
		}
		return mapService;
	}
	
	public map<string,string> mapGetEquipMent()
	{
		map<string,string> mapEquipMent=new map<string,string>();
		for(string s:setEquipMent)
		{
			mapEquipMent.put(s,s);
		}
		return mapEquipMent;
	}
	
	/*
	public set<string> getsetService()//static为什么不行呢？
	{
		return setService;
	}
	public set<string> getsetEquipMent()
	{
		return setEquipMent;
	}
	public set<string> getsetPart()
	{
		return setPart;
	}
	*/
	    //输出指定长度的字符串,前面用0补充
    public String IntToString(Integer intNumber, Integer length)
    {
        String strNumber = String.valueOf(intNumber);
        String strFormat = '';
        Integer intNumberLength = strNumber.length();
        for(Integer i=0;i<length-intNumberLength; i++)
        {
            strFormat += '0';
        }
        return strFormat + strNumber;
    }
    //根据超标百分比,发送邮件给办公室主任和SE负责人			/*参数:费用指标,超标的百分比,电子邮件*/
	public static void SendEmail(ID Pcid,Integer chaoin,string OFFemail)
	{		
		system.debug('......................OFFemail.............................'+OFFemail);
	    //获取系统的url
	    String str=System.Url.getSalesforceBaseUrl().toExternalForm();
	    //电子邮件地址
	    String[] toAddresses=new String[]{OFFemail};
	    //创建一个单一的Email对象实例
	    Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
	    email.setSubject('内部样机超标提醒');
	    //设置发送地址
	    email.setToAddresses(toAddresses);
	    //设置这个Email状态为活动
	    email.setSaveAsActivity(false);
	    email.setPlainTextBody('您好：'+'\n'+'本季度的费用指标已经超出,详细信息请看'+'\n'+str+'/'+Pcid);	      
	    //返回一个SendEmailResult对象
	    Messaging.Sendemailresult[] r=Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
	    system.debug('..................Pcid........................'+Pcid);	    	
	    system.debug('..................chaoin........................'+chaoin);
	    system.debug('..................OFFemail........................'+OFFemail);      	
	}
	
	//发票同步提醒
	public static void SendEmailInvoi(ID Pcid,Integer chaoin)
	{	
		string OFFemail=null;
		list<EmailRemind__c> listEmailRemind=new 	list<EmailRemind__c>([select name,Email__c from EmailRemind__c where IsDeleted = false]);
		for(EmailRemind__c e: listEmailRemind)
		{
			if(string.isBlank(OFFemail))
			{
				OFFemail=e.Email__c;
			}
			else
			{
				OFFemail += ':' + e.Email__c;
			}
		}
		 String[] toAddresses;
	    if(OFFemail.indexOf(':')>0)
	    {
	    	 toAddresses=OFFemail.split(':', 0);   //addresses.split(':', 0);
	    }
	    else
	    {
	    	 toAddresses=new String[]{OFFemail}; 
	    }
		
		system.debug('......................OFFemail.............................'+OFFemail);
	    //获取系统的url
	    String str=System.Url.getSalesforceBaseUrl().toExternalForm();
	    //电子邮件地址
	   
	    //创建一个单一的Email对象实例
	    Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
	    email.setSubject('对不起，该渠道代理商下还未新建销售指标，请确保信息完整后进行操作');
	    //设置发送地址
	    email.setToAddresses(toAddresses);
	    //设置这个Email状态为活动
	    email.setSaveAsActivity(false);
	    email.setPlainTextBody('您好：'+'\n'+'对不起，该渠道代理商下还未新建销售指标，请确保信息完整后进行操作'+'\n'+str+'/'+Pcid);	      
	    //返回一个SendEmailResult对象
	    Messaging.Sendemailresult[] r=Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
	        	
	}
	//给商务人员发邮件
	public static void SendEmailBuiness(set<id> setUser,set<id> setSaleregin,set<id> setQuoteId)
	{
		list<User> listuser=[Select id,Name,UserRole.Name,Email,UserRoleId From User where id IN:setUser];
		list<SalesRegion__c> listSalereg=[Select id,Name from SalesRegion__c where id IN:setSaleregin];
		list<Quote> listQuote=[Select id,Name from Quote where id IN:setQuoteId];
		//获取系统的url
	    String str=System.Url.getSalesforceBaseUrl().toExternalForm();
	    //电子邮件地址
	    String[] toAddresses=new String[]{};
	    for(User user:listuser)
	    {
	    	if(user.Email!=null)
	    		toAddresses.add(user.Email);
	    }
	    system.debug('................listuser.......................'+listuser);
	    system.debug('................listSalereg.......................'+listSalereg);
	    system.debug('................listQuote.......................'+listQuote);
	    if(toAddresses!=null&&toAddresses.size()>0&&listuser.size()>0&&listuser!=null&&listSalereg.size()>0&&listSalereg!=null&&listQuote.size()>0&&listQuote!=null)
	    {
		    //创建一个单一的Email对象实例
		    Messaging.Singleemailmessage email=new Messaging.Singleemailmessage();
		    email.setSubject('转订单提醒');
		    //设置发送地址
		    email.setToAddresses(toAddresses);
		    //设置这个Email状态为活动
		    email.setSaveAsActivity(false);
		    email.setPlainTextBody('您好:'+'\n'+'报价单需要转订单,详细信息请看'+'\n'+str+'/'+listQuote[0].Id);	      
		    //返回一个SendEmailResult对象
		    Messaging.Sendemailresult[] r=Messaging.sendEmail(new Messaging.Singleemailmessage[]{email});
	    	system.debug('.................email.....................'+email);
	    }
	    	 
	}

	//给区域下的商务部负责人发邮件
	
	
	































}