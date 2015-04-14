/*
查询Salesforce中客户为真实客户，并且客户识别编码为空的客户信息
客户信息同步至U8后返回客户同步后U8中客户编码
rogerSun 

*/
global class  CustomerUpdates implements Database.Batchable<SObject>, Database.AllowsCallouts
{
     global Database.queryLocator start(Database.BatchableContext ctx)
     {
           return Database.getQueryLocator([Select a.Id,a.TaxId_c__c, a.Kundtypklassificering__c, a.Province__c, a.PrimaryIndustry__c, a.Name, a.CreatedDate, a.Corporate_c__c From Account a where a.Whether__c=true and a.IsDeleted=false and (a.IdentificationCode_c__c=null or a.IdentificationCode_c__c='') LIMIT 100]); 
     }
     global void execute(Database.BatchableContext ctx, List<Account> scope)
     {
        if (scope.size()>0 && scope != null)
        {
            WSDLUpdateClient.UpdateClientSoap tt =  new WSDLUpdateClient.UpdateClientSoap();
            list<WSDLUpdateClient.CustomArray> dd=approOrderConvert(scope); 
             WSDLUpdateClient.ArrayOfCustomArray aa=new WSDLUpdateClient.ArrayOfCustomArray();  
             aa.CustomArray=(WSDLUpdateClient.CustomArray[])dd;
             system.debug('获取salesforce数据库查询出满足条件值 :'+aa);
             WSDLUpdateClient.ArrayOfString f=new WSDLUpdateClient.ArrayOfString();
            f=tt.CustomersByValue(aa);
            system.debug('获取WSDLUpdateClient中CustomersByValue方法返回值赋值给f :'+f);
              tt.timeout_x=120000;
              if(f.string_x.size()>0)
              {
                 Operator(f);    
              }
              
             system.debug('修改完成');
        }
    }
    
    public static void Operator(WSDLUpdateClient.ArrayOfString f)
    {  
             Map<string,string> numIdMap = new Map<string,string>();
             string[] ss = f.string_x;
              system.debug('返回值赋给string数组ss :'+ss);
             for(string s:ss)
             {
                string[] numID = s.split(',');
                for(string sNum:numID)
                {
                    string[] sNumId=sNum.split('\\+');
                    numIdMap.put(sNumId[1],sNumId[0]);
                    system.debug('识别编码 :'+sNumId[0]);
                    system.debug('客户ID :'+sNumId[1]);
                }   
             }
             system.debug('返回值按照Id和标识码赋值给map（numIdMap） :'+numIdMap.size());
             List<Account> acc = [select id from Account where id IN: numIdMap.keySet()]; 
             system.debug('根据map中的id获取Account表中id :'+numIdMap);
             for(Account a:acc)
             {
                a.IdentificationCode_c__c=numIdMap.get(a.Id);
             }
            update acc;
    }

     //将系统中的对象转换成WSDLUpdateClient中的各个内部类
     public static List<WSDLUpdateClient.CustomArray> approOrderConvert(List<Account> list_objOrder)
    {
        List<WSDLUpdateClient.CustomArray> list_AppOrderHeader = new List<WSDLUpdateClient.CustomArray>() ;
        integer i;
        i=0;
        if(list_objOrder == null || list_objOrder.size() ==0)
        {
            return list_AppOrderHeader;
        }
         for(Account objOrder : list_objOrder)
        {
            //order header
            WSDLUpdateClient.CustomArray obj_orderHeader = new WSDLUpdateClient.CustomArray();
           obj_orderHeader.Id=objOrder.Id;
           system.debug('obj_orderHeader.Id'+'第'+i+'个'+obj_orderHeader.Id);
           
           obj_orderHeader.Corporate=objOrder.Corporate_c__c;
            system.debug('obj_orderHeader.Corporate'+'第'+i+'个'+obj_orderHeader.Corporate);
            
           obj_orderHeader.CreatedDate=objOrder.CreatedDate;
            system.debug('obj_orderHeader.CreatedDate'+'第'+i+'个'+obj_orderHeader.CreatedDate);
            
           obj_orderHeader.Name=objOrder.Name;
            system.debug('obj_orderHeader.Name'+'第'+i+'个'+obj_orderHeader.Name);
            
           obj_orderHeader.PrimaryIndustry=objOrder.PrimaryIndustry__c;
            system.debug(' obj_orderHeader.PrimaryIndustry'+ '第'+i+'个'+obj_orderHeader.PrimaryIndustry);
            
           obj_orderHeader.Province=objOrder.Province__c;
            system.debug('obj_orderHeader.Province'+'第'+i+'个'+obj_orderHeader.Province);
            
           obj_orderHeader.RecordTypeName=objOrder.Kundtypklassificering__c;
            system.debug('obj_orderHeader.RecordTypeName'+'第'+i+'个'+obj_orderHeader.RecordTypeName);
            
           obj_orderHeader.TaxId=objOrder.TaxId_c__c;
            system.debug('obj_orderHeader.TaxId'+'第'+i+'个'+obj_orderHeader.TaxId);
            
            list_AppOrderHeader.add(obj_orderHeader) ;
            i=i+1;
        }
        return list_AppOrderHeader;
    }
   global void finish(Database.BatchableContext ctx)
   {
            
    }
}