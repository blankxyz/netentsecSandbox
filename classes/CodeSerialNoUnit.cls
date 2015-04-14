/*
Author: Vito_He
Created on: 2013/8/12
Description: 
        生成流水号单元对象
Constraint:   
	流水号单元对象
*/ 
public  class CodeSerialNoUnit {
	
	public Integer CodeNo;                 //存储序列号数字
	public Integer counter;                //自增计数器
	public OrderNumber__c codeSerialNo;   //序列号对象
	
	public Integer size;                   //流水号数据长度
}