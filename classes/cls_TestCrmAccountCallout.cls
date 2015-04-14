/*
客户信息与客户联系人信息同步至用友CRM
Vito He 
2013-06-17
*/
@isTest
private class cls_TestCrmAccountCallout {

    static testMethod void myUnitTest() {
    	
        Test.setMock(WebServiceMock.class, new WsdlCrmMockImpl(0));
        
        WsdlCrmAccount.ArrayOfString output = callOperatonCrmAccount(); 
		
		String[] ss = new String[]{'已同步','webServiceTest'};
        System.assertEquals(ss[1], output.string_x[1]); 
        system.debug('-----------------output-------------'+output.string_x); 
        
    } 
    
     static testMethod void myUnitTest2() {
        Test.setMock(WebServiceMock.class, new WsdlCrmMockImpl(1));
 
        WsdlCrmAccount.ArrayOfString output = callOperatonCrmAccountA();
        
        system.debug('-----------------output2-------------'+output.string_x); 
    } 
    
    
    public static WsdlCrmAccount.ArrayOfString callOperatonCrmAccount() {
        WsdlCrmAccount.CrmAccountSoap sample = new WsdlCrmAccount.CrmAccountSoap(); 
        sample.endpoint_x = 'http://124.207.141.117:7001/CrmAccount.asmx';
        
        WsdlCrmAccount.ArrayOfAccountArray aa = new WsdlCrmAccount.ArrayOfAccountArray();
        WsdlCrmAccount.ArrayOfContactArray bb = new WsdlCrmAccount.ArrayOfContactArray();
        WsdlCrmAccount.AccountArray[] accArr = new WsdlCrmAccount.AccountArray[1];
        WsdlCrmAccount.AccountArray acc1 = new WsdlCrmAccount.AccountArray();
        acc1.identifyCode = 'onlyCode';
        acc1.accountname = 'ceshi0008'; 
        acc1.acctInt02 = '正式客户'; 
        acc1.accountType = '最终客户';
        acc1.createTime =dateTime.valueOf('2013-01-09 12:34:00');
        acc1.acctInt03 = '金融';
        acc1.acctInt04 = '金融监督';
        acc1.acctInt24 = '银监会';
        acc1.acctInt05 = '网络广告';
        acc1.billingCountry = '中国';
        acc1.parentAccount = '北京市西城区教委';
        acc1.accountPhone = '110';
        acc1.accountFax = '119';
        acc1.shippingZipcode = '100000';
        acc1.shippingAddress = '北京海淀区';
        acc1.acctInt01 = '北京';
        acc1.acctInt08 = '北京';
        acc1.acctChar09 = '没有原因';
        acc1.acctRefid01 = '30003';
        acc1.acctRefid02 = '10007';
        accArr[0]=acc1;

        
        WsdlCrmAccount.ContactArray[] conArr = new WsdlCrmAccount.ContactArray[1];
        WsdlCrmAccount.ContactArray con1 = new WsdlCrmAccount.ContactArray();
        con1.onlyCode = 'onlyCode1';
        con1.contactName = '刘家窑';
        con1.department = '组织部';
        con1.position = '部长';
        con1.mobile = '18621593328';
        con1.officePhone = '010-9876087';
        con1.email = 'wnh@qq.com';
        con1.fax = '123456';
        con1.birthdate = dateTime.valueOf('1997-09-08 12:12:12');
        con1.identifyCodeAccount = 'onlyCode';
        con1.createtime1 = dateTime.valueOf('2013-06-12 12:32:12');
        con1.rptContact = null;
        conArr[0]=con1;
        
        aa.AccountArray = accArr;
        bb.ContactArray = conArr;
        
        WsdlCrmAccount.ArrayOfString echo = sample.OperatonCrmAccount(aa,bb);
        return echo;
    }   
    
    
    public static WsdlCrmAccount.ArrayOfString callOperatonCrmAccountA() {
        WsdlCrmAccount.CrmAccountSoap sample = new WsdlCrmAccount.CrmAccountSoap(); 
        sample.endpoint_x = 'http://124.207.141.117:7001/CrmAccount.asmx';
        
        WsdlCrmAccount.ArrayOfAccountArray aa = new WsdlCrmAccount.ArrayOfAccountArray();
        WsdlCrmAccount.AccountArray[] accArr = new WsdlCrmAccount.AccountArray[1];
        WsdlCrmAccount.AccountArray acc1 = new WsdlCrmAccount.AccountArray();
        acc1.identifyCode = 'onlyCode';
        acc1.accountname = 'ceshi0008'; 
        acc1.acctInt02 = '正式客户'; 
        acc1.accountType = '最终客户';
        acc1.createTime =dateTime.valueOf('2013-01-09 12:34:00');
        acc1.acctInt03 = '金融';
        acc1.acctInt04 = '金融监督';
        acc1.acctInt24 = '银监会';
        acc1.acctInt05 = '网络广告';
        acc1.billingCountry = '中国';
        acc1.parentAccount = '北京市西城区教委';
        acc1.accountPhone = '110';
        acc1.accountFax = '119';
        acc1.shippingZipcode = '100000';
        acc1.shippingAddress = '北京海淀区';
        acc1.acctInt01 = '北京';
        acc1.acctInt08 = '北京';
        acc1.acctChar09 = '没有原因';
        acc1.acctRefid01 = '30003';
        acc1.acctRefid02 = '10007';
        accArr[0]=acc1;

        aa.AccountArray = accArr;
        
        WsdlCrmAccount.ArrayOfString echo = sample.OperatonCrmAccountA(aa);
        return echo;
    }   
}