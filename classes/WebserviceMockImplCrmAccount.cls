@isTest
global class WebserviceMockImplCrmAccount implements WebServiceMock
{
global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        WsdlCrmAccount.OperatonCrmAccountResponse_element respElement = 
           new WsdlCrmAccount.OperatonCrmAccountResponse_element();
        respElement.OperatonCrmAccountResult = new WsdlCrmAccount.ArrayOfString();            
        response.put('response_x', respElement); 

   }
}