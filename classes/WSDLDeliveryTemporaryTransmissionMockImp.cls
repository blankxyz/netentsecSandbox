/**
 * 虚拟webservice response对象返回结果
Roger Sun 
2014-06-18
 */
@isTest
global class WSDLDeliveryTemporaryTransmissionMockImp implements WebServiceMock  {

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
	  
	   
	      
	       
	       WSDLDeliveryTemporaryTransmission.DeliveryTemporaryTransmissionImResponse_element operaElementAcc=new
	       WSDLDeliveryTemporaryTransmission.DeliveryTemporaryTransmissionImResponse_element();
	       response.put('response_x', operaElementAcc);
	   
   }    
}