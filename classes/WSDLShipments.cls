//Generated by wsdl2apex

public class WSDLShipments {
    public class UpdateShipmentsResponse_element {
        public WSDLShipments.ArrayOfString UpdateShipmentsResult;
        private String[] UpdateShipmentsResult_type_info = new String[]{'UpdateShipmentsResult','http://www.frensworkz.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.frensworkz.com/','true','false'};
        private String[] field_order_type_info = new String[]{'UpdateShipmentsResult'};
    }
    public class OperShipmentsReturnValue_element {
        public String s;
        private String[] s_type_info = new String[]{'s','http://www.frensworkz.com/',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.frensworkz.com/','true','false'};
        private String[] field_order_type_info = new String[]{'s'};
    }
    public class ShipmentsSoap {
        public String endpoint_x = 'http://124.207.141.116:8089/Shipments.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.frensworkz.com/', 'WSDLShipments'};
        public void OperShipmentsReturnValue(String s) {
            WSDLShipments.OperShipmentsReturnValue_element request_x = new WSDLShipments.OperShipmentsReturnValue_element();
            WSDLShipments.OperShipmentsReturnValueResponse_element response_x;
            request_x.s = s;
            Map<String, WSDLShipments.OperShipmentsReturnValueResponse_element> response_map_x = new Map<String, WSDLShipments.OperShipmentsReturnValueResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.frensworkz.com/OperShipmentsReturnValue',
              'http://www.frensworkz.com/',
              'OperShipmentsReturnValue',
              'http://www.frensworkz.com/',
              'OperShipmentsReturnValueResponse',
              'WSDLShipments.OperShipmentsReturnValueResponse_element'}
            );
            response_x = response_map_x.get('response_x');
        }
        public WSDLShipments.ArrayOfString UpdateShipments() {
            WSDLShipments.UpdateShipments_element request_x = new WSDLShipments.UpdateShipments_element();
            WSDLShipments.UpdateShipmentsResponse_element response_x;
            Map<String, WSDLShipments.UpdateShipmentsResponse_element> response_map_x = new Map<String, WSDLShipments.UpdateShipmentsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.frensworkz.com/UpdateShipments',
              'http://www.frensworkz.com/',
              'UpdateShipments',
              'http://www.frensworkz.com/',
              'UpdateShipmentsResponse',
              'WSDLShipments.UpdateShipmentsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.UpdateShipmentsResult;
        }
    }
    public class UpdateShipments_element {
        private String[] apex_schema_type_info = new String[]{'http://www.frensworkz.com/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class ArrayOfString {
        public String[] string_x;
        private String[] string_x_type_info = new String[]{'string','http://www.frensworkz.com/',null,'0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.frensworkz.com/','true','false'};
        private String[] field_order_type_info = new String[]{'string_x'};
    }
    public class OperShipmentsReturnValueResponse_element {
        private String[] apex_schema_type_info = new String[]{'http://www.frensworkz.com/','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
}