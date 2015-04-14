/*
WsdlorderDetail的测试类
rogersun
2013-06-17
*/
public with sharing class cls_TestWsdlorderDetail 
{
	static testMethod void operDataWsdlorderDetail() 
    {	
    	Test.setMock(WebServiceMock.class, new WsdlorderDetailMockImpl());
    	 
    	WsdlorderDetail.ArrayOfString output = callOperatorOrderDetail();
    	
    	system.debug('-------------------output---------------'+output.string_x); 
    	     
    } 
    
    public static WsdlorderDetail.ArrayOfString callOperatorOrderDetail(){
    	WsdlorderDetail.orderDetailSoap samp=new WsdlorderDetail.orderDetailSoap();
    	samp.endpoint_x = 'http://124.207.141.117:7001/orderDetail.asmx';
    	
    	WsdlorderDetail.orderArray c=new WsdlorderDetail.orderArray();
    	list<WsdlorderDetail.orderArray> a=new list<WsdlorderDetail.orderArray>();
    	    c.contractnumber = 'ORD201605100002';//订单编号
            c.contractname = '北京通力集团-ITM';//订单名称
            c.cntrtint09 = '网康科技';//平台分类
            c.cntrtint14 = '001';//请选择帐套号
            c.cntrtint10 = '直销';//销售类型
            c.cntrtint12 = 'ITM';//产品类型
            c.accountid = '苹果公司';//付款方
            c.copartnerid = '苹果公司';//合作伙伴
            c.cntrtrefid01 = '北京通力集团';//实际客户
            c.cntrtchar05 = null;//订单摘要
            c.createtime = null;    //订单日期
            c.cntrtint05 = null;//是否再销售
            c.cntrtint16 = null;//一级行业(行业)
            c.cntrtmulti02 = '50%分给陈总';//合作情况
            c.cntrtchar08 = '50%分给陈总';//合作业绩分配
            c.cntrtint01 = null;//开票状态
            c.cntrtint18 = '足额收款';//收款状态
            c.cntrtint19 = '是';//核算收入状态
            c.contractamount = 1000.0;    //订单金额
            c.contractpaymentdate = null;    //付款日期
            c.contractdeliveredquantity = 0.0;    //已交付数量
            c.contractdeliverydate = null;    //交付日期
            c.contractundeliveredquantity = 99999;    //未交付数量
            c.cntrtrefid02 = '苹果公司';//出货方
            c.contractquantity = 0.0;    //订单数量
            c.cntrtchar09 = '苹果公司';
            c.cntrtmulti04 = null;
    	    a.add(c);
    	    WsdlorderDetail.ArrayOfOrderArray d=new WsdlorderDetail.ArrayOfOrderArray();
    	    d.orderArray=a;
    	    
    	  WsdlorderDetail.orderDetailArray orderDetailArray=new WsdlorderDetail.orderDetailArray();
    	  list<WsdlorderDetail.orderDetailArray> e=new list<WsdlorderDetail.orderDetailArray>();
            orderDetailArray.contractnumber1 = 'ORD201605100002';//订单编号
            orderDetailArray.prodname = '250G/并口硬盘';//产品名称
            orderDetailArray.standardPrice = 500;//标准价
            orderDetailArray.bookPrice = 99999000;//价格表价格
            orderDetailArray.unitname = null;//计量单位

            orderDetailArray.discount = 0.0;//折500扣
            orderDetailArray.finalprice = 500;//成交价
            orderDetailArray.prodquantity = 2.0;//产品数量
            orderDetailArray.prodamount = 1000;//金额
            orderDetailArray.dcntrtchar03 = null;//license期限
            orderDetailArray.dcntrtchar10 = '61305060006';//客户id
            orderDetailArray.dcntrtrefid02 = '北京通力集团';//实际客户名称
            orderDetailArray.dcntrtchar09 = null;//软件版本号
            orderDetailArray.dcntrtchar08 = 'asda0000';//定制编号
            orderDetailArray.dcntrtint02 = 'asdfa000';//定制类型
            orderDetailArray.onlyCodeId = 'a0JO0000001lpjRMAQ12';//唯一编码 订单明细id
            orderDetailArray.dcntrtchar06 = null;//定制型号
    	    e.add(orderDetailArray);
    	    WsdlorderDetail.ArrayOfOrderDetailArray f=new WsdlorderDetail.ArrayOfOrderDetailArray();
    	    f.orderDetailArray=e;
    	    WsdlorderDetail.ArrayOfString echo=new WsdlorderDetail.ArrayOfString();
    	    echo=samp.operatorOrderDetail(d,f); 
    	    return echo;
    }
}