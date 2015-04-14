/**
 * 虚拟webservice response对象返回结果
Roger Sun 
2014-06-18
 */
@isTest
global class WSDLInvoiceTransmission_MockImp implements WebServiceMock  {

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
	  
	   
	      
	       
	       WSDLInvoiceTransmission.InvoiceTransmissionImResponse_element operaElementAcc=new
	       WSDLInvoiceTransmission.InvoiceTransmissionImResponse_element();
	       response.put('response_x', operaElementAcc);
	   
   }    
}