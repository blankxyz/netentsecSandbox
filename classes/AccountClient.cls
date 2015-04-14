/*
客户信息与客户联系人信息同步至用友CRM
RogerSun 
2013-06-03

*/
public with sharing class AccountClient 
{
    @Future(callout=true)
    public static void OrderAccountClient()
    {
        system.debug('测试数据');
        //负责客户工程师，Id,识别编码,客户名称,是否为正式客户,客户记录类型,公司法人,税号,创建时间,账面余额,返点金额,渠道质保金,一级行业,二级行业,三级行业,客户来源,国家地区,上级单位（母公司）,电话,传真,邮编,地址,所在省份,所在城市,设备使用状态,员工数量,互联网出口宽带及网络情况,主要业务
        map<Id,Account> mapAccount=new map<Id,Account>([select a.SellArea__r.Name,a.Owner.EmployeeNumber,a.AccountSourceY__c,a.Id,a.IdentificationCode_c__c,a.Name,a.Whether__c,a.Kundtypklassificering__c,a.Corporate_c__c,a.TaxId_c__c,CreatedDate,a.AvailableBalance_new__c,a.TheRebateAmount_new__c,a.RetentionMoney_New__c,a.PrimaryIndustry__c,a.TwoIndustries__c,a.ThreeIndustries__c,a.CountryOrRegion__c,a.Parent.Name,a.Phone,a.Fax,a.ZipCode__c,a.DetailedAddress__c,a.Province__c,a.City__c,a.UsingStateOfEquipment__c,a.NumberOfEmployees,a.TheInternetBandwidthAndNetwork__c,a.MainBusiness__c,a.WithoutTheUseOfReason__c,a.ResponsibleForCustomerSpecialist__r.EmployeeNumber,a.CustomerEngineerX__r.EmployeeNumber,a.Remarks__c From Account a where a.Whether__c=true and a.IsDeleted=false and (a.Statues__c='未同步'   or a.Statues__c=null) and (a.IdentificationCode_c__c !=null or a.IdentificationCode_c__c !='') LIMIT 100]);
        //a.TwoIndustries__c,a.ThreeIndustries__c,a.AccountSource,a.CountryOrRegion__c,a.Parent,a.Phone,a.Fax,a.ZipCode__c,a.DetailedAddress__c,a.Province__c,a.City__c,a.UsingStateOfEquipment__c,a.NumberOfEmployees,a.TheInternetBandwidthAndNetwork__c
        //二级行业,三级行业,客户来源,国家地区,上级单位（母公司）,电话,传真,邮编,地址,所在省份,所在城市,设备使用状态,员工数量,互联网出口宽带及网络情况,主要业务
        list<Account> accountInformation=new list<Account>();
        set<Id> accountId=mapAccount.keySet();
        for(id i:accountId)  
        {
            accountInformation.add(mapAccount.get(i));
        }
        system.debug('accountInformation is information'+accountInformation);
        list<Contact> contactInformation=[select c.lxDepartment__c,c.Owner.EmployeeNumber,c.Id,c.Name,c.Department,c.Title,c.MobilePhone,c.Phone,c.Email,c.Fax,c.Birthdate,c.IdentificationCode__c,c.CreatedDate,c.ReportsTo.Id From Contact c where c.IsDeleted=false and c.AccountID in:accountId];
        system.debug('联系人信息'+contactInformation);
        //联系人Id，名称、部门、职务、手机、电话、电子邮件、传真、出生日期、客户、创建时间、联系人上司Id
        if(accountInformation.size()>0)
        {
            WsdlCrmAccount.CrmAccountSoap tt=new WsdlCrmAccount.CrmAccountSoap();
            WsdlCrmAccount.ArrayOfAccountArray aa=new WsdlCrmAccount.ArrayOfAccountArray();
            
            aa.AccountArray=(WsdlCrmAccount.AccountArray[])AccountClientOperaton(accountInformation);
            WsdlCrmAccount.ArrayOfString f=new WsdlCrmAccount.ArrayOfString();
            tt.timeout_x=120000;
            if(contactInformation.size()>0)
            { 
                system.debug('客户、联系人同步');
                WsdlCrmAccount.ArrayOfContactArray bb=new WsdlCrmAccount.ArrayOfContactArray();
                bb.ContactArray=(WsdlCrmAccount.ContactArray[])contactClientOperaton(contactInformation);
                f=tt.OperatonCrmAccount(aa,bb);
                system.debug('客户、联系人同步返回值f'+f);
                updateStatuesData(f);
                system.debug('有联系人');
            }
            else
            {
                system.debug('客户同步信息');
                f=tt.OperatonCrmAccountA(aa);
                system.debug('客户同步返回值f'+f);
                updateStatuesData(f);
                system.debug('无联系人');
            }
            
            
        }
        
    }
    public static list<WsdlCrmAccount.AccountArray> AccountClientOperaton(list<Account> a)
    {
        list<WsdlCrmAccount.AccountArray> h=new list<WsdlCrmAccount.AccountArray>();
        for(Account aa:a)
        {
            WsdlCrmAccount.AccountArray b=new WsdlCrmAccount.AccountArray();
            b.identifyCode=aa.IdentificationCode_c__c;
            b.accountname=aa.name;
            b.acctInt02='正式客户';
            b.accountType=aa.Kundtypklassificering__c;
            b.createTime=aa.CreatedDate;
            b.acctInt03=aa.PrimaryIndustry__c;
            b.acctInt04=aa.TwoIndustries__c;
            b.acctInt24=aa.ThreeIndustries__c;
            b.acctInt05=aa.AccountSourceY__c;
            b.billingCountry=aa.CountryOrRegion__c;
            b.parentAccount=aa.Parent.Name;
            b.accountPhone=aa.Phone;
            b.accountFax=aa.Fax;
            b.shippingZipcode=aa.ZipCode__c;
            b.shippingAddress=aa.DetailedAddress__c;
            b.acctInt01=aa.Province__c;
            b.acctInt08=aa.City__c;
            b.acctChar09=aa.WithoutTheUseOfReason__c;
            b.acctRefid01=aa.ResponsibleForCustomerSpecialist__r.EmployeeNumber;
            b.acctRefid02=aa.CustomerEngineerX__r.EmployeeNumber;
            b.SalesRegion=aa.SellArea__r.Name;
            system.debug('b.SalesRegion'+b.SalesRegion);
            b.BusinessOwners=aa.Owner.EmployeeNumber;
            system.debug('b.BusinessOwners'+b.BusinessOwners);
            b.acctInt29=aa.UsingStateOfEquipment__c;
            system.debug('b.acctInt29'+b.acctInt29);
            b.Remark=aa.Remarks__c;
            system.debug('b.Remark'+b.Remark);
            //a.SellArea__r.Name,a.Owner.EmployeeNumber
            h.add(b);
        }
        return h;
    }
    public static list<WsdlCrmAccount.ContactArray> contactClientOperaton(list<Contact> b)
    {
        list<WsdlCrmAccount.ContactArray> hh=new list<WsdlCrmAccount.ContactArray>();
        for(Contact bb:b)
        {
            WsdlCrmAccount.ContactArray h=new WsdlCrmAccount.ContactArray();
            h.onlyCode=bb.Id;
            h.contactName=bb.Name;
            h.department=bb.Department;
            h.position=bb.Title;
            h.mobile=bb.MobilePhone;
            h.officePhone=bb.Phone;
            h.email=bb.Email;
            h.fax=bb.Fax;
            h.birthdate=bb.Birthdate;
            h.identifyCodeAccount=bb.IdentificationCode__c;
            h.createtime1=bb.CreatedDate;
            h.rptContact=bb.ReportsTo.Id;
            h.ndeptid=bb.lxDepartment__c;
            h.nowneruserid=bb.Owner.EmployeeNumber;
            hh.add(h);
        }
        
        return hh;
    }
    
    public static  void updateStatuesData(WsdlCrmAccount.ArrayOfString f)
    { 
             Map<string,string> numIdMap = new Map<string,string>();
             string[] ss = f.string_x;
              system.debug('from string is ss :'+ss);
               for(string s:ss)
             {
                string[] numID = s.split(',');
                for(string sNum:numID)
                {
                    string[] sNumId=sNum.split('\\+');
                    if(sNumId[1]!=null && sNumId[0]!=null)
                    {
                        numIdMap.put(sNumId[1],sNumId[0]);
                    }
                    
                    system.debug('asd :'+sNumId[0]);
                    system.debug('das:'+sNumId[1]);
                }   
             }
             system.debug('返回值按照Id和标识码赋值给map（numIdMap） :'+numIdMap.size());
             List<Account > acc = [select IdentificationCode_c__c from Account where IdentificationCode_c__c IN: numIdMap.keySet()]; 
             system.debug('根据map中的id获取Account表中id :'+numIdMap);
             for(Account a:acc)
             {
                a.Statues__c=numIdMap.get(a.IdentificationCode_c__c);
                system.debug('a.IdentificationCode_c__c'+numIdMap.get(a.IdentificationCode_c__c));
             }
             update acc;
             system.debug('修改完成');
    }
   
}