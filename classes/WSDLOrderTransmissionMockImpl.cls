/**
 *  * 虚拟webservice response对象返回结果
Roger Sun 
2014-06-18
 */
@isTest
global class WSDLOrderTransmissionMockImpl implements WebServiceMock {
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
	       WSDLOrderTransmission.OrderTransmissionImResponse_element operaElementAcc=new
	       WSDLOrderTransmission.OrderTransmissionImResponse_element();
	       response.put('response_x', operaElementAcc);
	       
           }
	       
}