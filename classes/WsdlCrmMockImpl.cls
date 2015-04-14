/*
虚拟webservice response对象返回结果
Vito He 
2013-06-17
*/
@isTest
global  class WsdlCrmMockImpl implements WebServiceMock{
	 private Integer flag;
	 
	 global WsdlCrmMockImpl(Integer i){
	 	flag=i;
	 }
     global  void doInvoke(
           Object stub,
           Object request,  
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) { 
	   WsdlCrmAccount.ArrayOfString arrString = new WsdlCrmAccount.ArrayOfString();
	   arrString.string_x = new String[]{'已同步','webServiceTest'};
	   if(flag==0){
	       WsdlCrmAccount.OperatonCrmAccountResponse_element operaElement = new 
	       							WsdlCrmAccount.OperatonCrmAccountResponse_element(); 
	       operaElement.OperatonCrmAccountResult = arrString;
	       response.put('response_x', operaElement);  
	   }else{
	   	   WsdlCrmAccount.OperatonCrmAccountAResponse_element operaElement = new 
	       							WsdlCrmAccount.OperatonCrmAccountAResponse_element(); 
	       operaElement.OperatonCrmAccountAResult = arrString;
	       response.put('response_x', operaElement);
	   } 
   }    
}