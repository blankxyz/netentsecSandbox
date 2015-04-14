/*
Author: Roger_Sun
Created on: 2014/3/14
Description: 
        生成流水号 
Constraint:   
对于批量导入超过100条数据的处理：
	1.添加静态方法存储自动编号的值
	2.直到处理完最后的一条数据，再去update 自动编号对象： CodeSerialNo__c
	3.解决了同步访问问题。（map根据不同的序列号，产生不同的序列号对象）
注意：
	参数: 1.头，2.类型，3.生成序列号的数据长度
*/   
public class UtilsCreateAutoNum {
    
    //一个序列号类型对应一个序列号对象单元 
    public static map<String,CodeSerialNoUnit> mapNameSerial = new map<String,CodeSerialNoUnit>(); 
    
    //自定义异常对象  
    public class MyException extends Exception {} 
    
    //生成序列号并返回string类型，sql语句只用于本系统 如：  T201302020001 
    //parm head  头
    //parm name  序列号类型 
    //parm size  生成序列号的数据长度
    public static string createAutoNum(string head,string name,Integer size)
    { 
    	if(!mapNameSerial.containsKey(name)){
    		CodeSerialNoUnit unit = new CodeSerialNoUnit();
    		OrderNumber__c codeSerialNo = new  OrderNumber__c();
    		unit.codeSerialNo = codeSerialNo;
    		unit.CodeNo = -1;
    		unit.counter = 0;
    		unit.size = size;
    		mapNameSerial.put(name,unit);
    	}
        Date dtToday = Date.today(); 
        Integer intYear = dtToday.year();           
        Integer intMonth = dtToday.month();
        Integer intDay = dtToday.day();
        DataFormat df = new DataFormat();
        CodeSerialNoUnit serialUnit = mapNameSerial.get(name);
        if(serialUnit.CodeNo==-1)
        {
        	List<OrderNumber__c> listSerialNo = Database.query('Select SerialNo__c,Year__c,Day__c,Month__c,Name from OrderNumber__c where Name=\''+name+'\' FOR UPDATE' );
        	system.debug('listSerialNo is infor:'+listSerialNo);
        	if(listSerialNo!=null && listSerialNo.size()==1)
	        {
	            serialUnit.codeSerialNo = listSerialNo.get(0);  
	            if(serialUnit.codeSerialNo.Year__c == intYear && serialUnit.codeSerialNo.Month__c == intMonth && serialUnit.codeSerialNo.Day__c == intDay){
	                serialUnit.CodeNo = Integer.valueOf(serialUnit.codeSerialNo.SerialNo__c); 
	            }else{  
	                serialUnit.codeSerialNo.Year__c = intYear;
	                serialUnit.codeSerialNo.Month__c = intMonth;
	                serialUnit.codeSerialNo.Day__c = intDay; 
	                serialUnit.CodeNo = 0;
	            }
	        }
	        else
	        {
	        	throw new MyException('没有查到对应的序列号对象，或查到两条以上对象');
	        }
        }
        serialUnit.CodeNo++;  //缓存的数据累加 
        serialUnit.counter++; //计数器累加  
        if(serialUnit.size == serialUnit.counter){     
	        serialUnit.codeSerialNo.SerialNo__c = serialUnit.CodeNo;  //最后一条则赋值
        	Database.update(serialUnit.codeSerialNo,false);        
        	mapNameSerial.remove(name);
        	//update unitCodeSerialNo;  
        	//serialUnit.CodeNo = -1;
        }  
        Datetime dateStyle = datetime.newInstance(Integer.valueOf(serialUnit.codeSerialNo.Year__c),Integer.valueOf(serialUnit.codeSerialNo.Month__c),Integer.valueOf(serialUnit.codeSerialNo.Day__c)); 
	    return  head + dateStyle.format('yyyyMMdd') + df.IntToString(Integer.valueOf(serialUnit.CodeNo),4); 
    }
}