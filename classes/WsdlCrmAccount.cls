//Generated by wsdl2apex

public class WsdlCrmAccount {
    public class ArrayOfAccountArray {
        public WsdlCrmAccount.AccountArray[] AccountArray;
        private String[] AccountArray_type_info = new String[]{'AccountArray','http://tempuri.org/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'AccountArray'};
    }
    public class OperatonCrmAccount_element {
        public WsdlCrmAccount.ArrayOfAccountArray aa;
        public WsdlCrmAccount.ArrayOfContactArray bb;
        private String[] aa_type_info = new String[]{'aa','http://tempuri.org/',null,'0','1','false'};
        private String[] bb_type_info = new String[]{'bb','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'aa','bb'};
    }
    public class OperatonCrmAccountResponse_element {
        public WsdlCrmAccount.ArrayOfString OperatonCrmAccountResult;
        private String[] OperatonCrmAccountResult_type_info = new String[]{'OperatonCrmAccountResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'OperatonCrmAccountResult'};
    }
    public class OperatonCrmAccountA_element {
        public WsdlCrmAccount.ArrayOfAccountArray aa;
        private String[] aa_type_info = new String[]{'aa','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'aa'};
    }
    public class CrmAccountSoap {
        public String endpoint_x = 'http://124.207.141.116:8089/CrmAccount.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/', 'WsdlCrmAccount'};
        public WsdlCrmAccount.ArrayOfString OperatonCrmAccount(WsdlCrmAccount.ArrayOfAccountArray aa,WsdlCrmAccount.ArrayOfContactArray bb) {
            WsdlCrmAccount.OperatonCrmAccount_element request_x = new WsdlCrmAccount.OperatonCrmAccount_element();
            WsdlCrmAccount.OperatonCrmAccountResponse_element response_x;
            request_x.aa = aa;
            request_x.bb = bb;
            Map<String, WsdlCrmAccount.OperatonCrmAccountResponse_element> response_map_x = new Map<String, WsdlCrmAccount.OperatonCrmAccountResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/OperatonCrmAccount',
              'http://tempuri.org/',
              'OperatonCrmAccount',
              'http://tempuri.org/',
              'OperatonCrmAccountResponse',
              'WsdlCrmAccount.OperatonCrmAccountResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.OperatonCrmAccountResult;
        }
        public WsdlCrmAccount.ArrayOfString OperatonCrmAccountA(WsdlCrmAccount.ArrayOfAccountArray aa) {
            WsdlCrmAccount.OperatonCrmAccountA_element request_x = new WsdlCrmAccount.OperatonCrmAccountA_element();
            WsdlCrmAccount.OperatonCrmAccountAResponse_element response_x;
            request_x.aa = aa;
            Map<String, WsdlCrmAccount.OperatonCrmAccountAResponse_element> response_map_x = new Map<String, WsdlCrmAccount.OperatonCrmAccountAResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/OperatonCrmAccountA',
              'http://tempuri.org/',
              'OperatonCrmAccountA',
              'http://tempuri.org/',
              'OperatonCrmAccountAResponse',
              'WsdlCrmAccount.OperatonCrmAccountAResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.OperatonCrmAccountAResult;
        }
    }
    public class AccountArray {
        public String identifyCode;
        public String accountname;
        public String acctInt02;
        public String accountType;
        public DateTime createTime;
        public String acctInt03;
        public String acctInt04;
        public String acctInt24;
        public String acctInt05;
        public String billingCountry;
        public String parentAccount;
        public String accountPhone;
        public String accountFax;
        public String shippingZipcode;
        public String shippingAddress;
        public String acctInt01;
        public String acctInt08;
        public String acctChar09;
        public String acctRefid01;
        public String acctRefid02;
        public String SalesRegion;
        public String BusinessOwners;
        public String acctInt29;
        public String Remark;
        private String[] identifyCode_type_info = new String[]{'identifyCode','http://tempuri.org/',null,'0','1','false'};
        private String[] accountname_type_info = new String[]{'accountname','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt02_type_info = new String[]{'acctInt02','http://tempuri.org/',null,'0','1','false'};
        private String[] accountType_type_info = new String[]{'accountType','http://tempuri.org/',null,'0','1','false'};
        private String[] createTime_type_info = new String[]{'createTime','http://tempuri.org/',null,'1','1','true'};
        private String[] acctInt03_type_info = new String[]{'acctInt03','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt04_type_info = new String[]{'acctInt04','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt24_type_info = new String[]{'acctInt24','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt05_type_info = new String[]{'acctInt05','http://tempuri.org/',null,'0','1','false'};
        private String[] billingCountry_type_info = new String[]{'billingCountry','http://tempuri.org/',null,'0','1','false'};
        private String[] parentAccount_type_info = new String[]{'parentAccount','http://tempuri.org/',null,'0','1','false'};
        private String[] accountPhone_type_info = new String[]{'accountPhone','http://tempuri.org/',null,'0','1','false'};
        private String[] accountFax_type_info = new String[]{'accountFax','http://tempuri.org/',null,'0','1','false'};
        private String[] shippingZipcode_type_info = new String[]{'shippingZipcode','http://tempuri.org/',null,'0','1','false'};
        private String[] shippingAddress_type_info = new String[]{'shippingAddress','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt01_type_info = new String[]{'acctInt01','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt08_type_info = new String[]{'acctInt08','http://tempuri.org/',null,'0','1','false'};
        private String[] acctChar09_type_info = new String[]{'acctChar09','http://tempuri.org/',null,'0','1','false'};
        private String[] acctRefid01_type_info = new String[]{'acctRefid01','http://tempuri.org/',null,'0','1','false'};
        private String[] acctRefid02_type_info = new String[]{'acctRefid02','http://tempuri.org/',null,'0','1','false'};
        private String[] SalesRegion_type_info = new String[]{'SalesRegion','http://tempuri.org/',null,'0','1','false'};
        private String[] BusinessOwners_type_info = new String[]{'BusinessOwners','http://tempuri.org/',null,'0','1','false'};
        private String[] acctInt29_type_info = new String[]{'acctInt29','http://tempuri.org/',null,'0','1','false'};
        private String[] Remark_type_info = new String[]{'Remark','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'identifyCode','accountname','acctInt02','accountType','createTime','acctInt03','acctInt04','acctInt24','acctInt05','billingCountry','parentAccount','accountPhone','accountFax','shippingZipcode','shippingAddress','acctInt01','acctInt08','acctChar09','acctRefid01','acctRefid02','SalesRegion','BusinessOwners','acctInt29','Remark'};
    }
    public class ArrayOfContactArray {
        public WsdlCrmAccount.ContactArray[] ContactArray;
        private String[] ContactArray_type_info = new String[]{'ContactArray','http://tempuri.org/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'ContactArray'};
    }
    public class ArrayOfString {
        public String[] string_x;
        private String[] string_x_type_info = new String[]{'string','http://tempuri.org/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class OperatonCrmAccountAResponse_element {
        public WsdlCrmAccount.ArrayOfString OperatonCrmAccountAResult;
        private String[] OperatonCrmAccountAResult_type_info = new String[]{'OperatonCrmAccountAResult','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'OperatonCrmAccountAResult'};
    }
    public class ContactArray {
        public String onlyCode;
        public String contactName;
        public String department;
        public String position;
        public String mobile;
        public String officePhone;
        public String email;
        public String fax;
        public DateTime birthdate;
        public String identifyCodeAccount;
        public DateTime createtime1;
        public String rptContact;
        public String ndeptid;
        public String nowneruserid;
        private String[] onlyCode_type_info = new String[]{'onlyCode','http://tempuri.org/',null,'0','1','false'};
        private String[] contactName_type_info = new String[]{'contactName','http://tempuri.org/',null,'0','1','false'};
        private String[] department_type_info = new String[]{'department','http://tempuri.org/',null,'0','1','false'};
        private String[] position_type_info = new String[]{'position','http://tempuri.org/',null,'0','1','false'};
        private String[] mobile_type_info = new String[]{'mobile','http://tempuri.org/',null,'0','1','false'};
        private String[] officePhone_type_info = new String[]{'officePhone','http://tempuri.org/',null,'0','1','false'};
        private String[] email_type_info = new String[]{'email','http://tempuri.org/',null,'0','1','false'};
        private String[] fax_type_info = new String[]{'fax','http://tempuri.org/',null,'0','1','false'};
        private String[] birthdate_type_info = new String[]{'birthdate','http://tempuri.org/',null,'1','1','true'};
        private String[] identifyCodeAccount_type_info = new String[]{'identifyCodeAccount','http://tempuri.org/',null,'0','1','false'};
        private String[] createtime1_type_info = new String[]{'createtime1','http://tempuri.org/',null,'1','1','true'};
        private String[] rptContact_type_info = new String[]{'rptContact','http://tempuri.org/',null,'0','1','false'};
        private String[] ndeptid_type_info = new String[]{'ndeptid','http://tempuri.org/',null,'0','1','false'};
        private String[] nowneruserid_type_info = new String[]{'nowneruserid','http://tempuri.org/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
        private String[] field_order_type_info = new String[]{'onlyCode','contactName','department','position','mobile','officePhone','email','fax','birthdate','identifyCodeAccount','createtime1','rptContact','ndeptid','nowneruserid'};
    }
}