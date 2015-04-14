/*
*WsdlorderDetail虚拟webservice response对象返回结果
*Vito He 
*2013-06-17
*/
@isTest
global  class WsdlorderDetailMockImpl implements WebServiceMock{
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
      WsdlorderDetail.ArrayOfString arrs = new WsdlorderDetail.ArrayOfString();
      arrs.string_x = new string[]{'hello','world'};
      WsdlorderDetail.operatorOrderDetailResponse_element operaElement = new 
      		WsdlorderDetail.operatorOrderDetailResponse_element();
      operaElement.operatorOrderDetailResult = arrs; 
	  response.put('response_x', operaElement);
   }    
}