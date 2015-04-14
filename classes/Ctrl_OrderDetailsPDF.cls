/**
*Dis 订单明细PDF打印控制类
*Author:Gary Hu
*Time:2015年3月3日11:23:23
**/
public class Ctrl_OrderDetailsPDF {
	
	//订单Id
	public String Oid{get;set;}
	
	//订单金额大写
	public String upOrderAmount{get;set;}
	
	public Orders__c ObjOrder{get;set;}
	
	//订单明细List
	public List<OrderDetails__c> listOrderDetails{get;set;}
	
	public Ctrl_OrderDetailsPDF()
	{
		//订单Id
		Oid=ApexPages.currentPage().getParameters().get('id');
		
		//订单明细List
		listOrderDetails = [
			select Name, n_ProductByOrd__r.Name,Product_Description__c,n_ProCount__c,Final_Price__c,Final_Amount__c,n_CustomModels__c,shebeixuliehaoField2__c
			,n_ProductByOrd__r.CPMCZW__c,n_ProductByOrd__r.MSHT__c,ProDis__c,ProNameCn__c
			from OrderDetails__c where n_OrderNo__c =: Oid
		];	
		for(OrderDetails__c o:listOrderDetails)
		{
			if(string.isNotBlank(o.n_ProductByOrd__r.MSHT__c))
			{

				//产品描述
				String proDis = o.n_ProductByOrd__r.MSHT__c;
				proDis = wrapLine(proDis);
				o.ProDis__c = wrapLine(proDis,10);
				
				
			}
			if(string.isNotBlank(o.n_ProductByOrd__r.CPMCZW__c))
			{
								
				//产品名称
				String proName = o.n_ProductByOrd__r.CPMCZW__c;
				proName =  wrapLine(proName);
				o.ProNameCn__c = wrapLine(proName,10);
			}
			if(string.isNotBlank(o.n_ProductByOrd__r.Name))
			{
								
				//产品名称
				String proType = o.n_ProductByOrd__r.Name;
				proType =  wrapLine(proType);
				o.ProType__c = wrapLine(proType,10);
			}
		}
		//订单对象
		ObjOrder = [select Final_Price__c from Orders__c where id =: Oid];
		
		upOrderAmount = getMoneyLetters(ObjOrder.Final_Price__c);
		
	}
	
	//截取字符串的长度
	public String wrapLine(String oldStr, Integer chartNum)
    {
        if(oldStr!=null) 
        {
            Integer flag = 0;
            String retStr = '';
            List<String> lineList = oldStr.split('\n');
            for(Integer i=0;i<lineList.size(); i++)
            {
                String lineStr = lineList[i];
                while(lineStr.length() > chartNum)
                {
                         retStr += lineStr.substring(0,chartNum) + '\n';
                         lineStr = lineStr.substring(chartNum);
                }
                if(lineStr.length() > 0)
                {
                         retStr += lineStr + '\n';
                }
        }
        return retStr;
        }else
        {
        return '';
        }
    }
    
    //去除多余的html
	public  String wrapLine(String input){
		String result = '';
		if (input == null || input.trim().equals('')) {
			return '';
		}else{
			String str = input.replaceAll('\\&[a-zA-Z]{1,10};', '').replaceAll('<[^>]*>', '');
			result = str.replaceAll('[(/>)<]', '');
		}
		return result;
	}
	
	//将金额改为大写
	public String getMoneyLetters(Decimal  TotalSum)
    {
        string str1 = '零壹贰叁肆伍陆柒捌玖';            //0-9所对应的汉字 
        string str2 = '万仟佰拾亿仟佰拾万仟佰拾元角分'; //数字位所对应的汉字 
        string str3 = '';    //从原num值中取出的值 
        string str4 = '';    //数字的字符串形式 
        string str5 = '';  //人民币大写金额形式 
        integer i;    //循环变量 
        integer j;    //num的值乘以100的字符串长度 
        string ch1 = '';    //数字的汉语读法 
        string ch2 = '';    //数字位的汉字读法 
        integer nzero = 0;  //用来计算连续的零值是几个 
        integer temp;            //从原num值中取出的值 
       // Decimal  TotalSum;   
        
         
        long num = (TotalSum * 100).longValue(); 
        //num = num * 100;        //将num乘100并转换成字符串形式 
        str4 = String.valueof(num);
        j = str4.length();      //找出最高位 
        if (j > 15){return '溢出';} 
        str2 = str2.Substring(15-j);   //取出对应位数的str2的值。如：200.55,j为5所以str2=佰拾元角分 
           
        //循环取出每一位需要转换的值 
        for(i=0;i<j;i++) 
        { 
            str3 = str4.Substring(i, i+1);          //取出需转换的某一位的值, from left to right
            system.debug(str3);
            temp = integer.valueof(str3);           //转换为数字 
            
            if (i != (j-3) && i != (j-7) && i != (j-11) && i != (j-15)) 
            {     
                //当所取位数不为元、万、亿、万亿上的数字时 
                if (str3 == '0') 
                { 
                    ch1 = ''; 
                    ch2 = ''; 
                    nzero = nzero + 1; 
                } 
                else 
                { 
                    if(str3 != '0' && nzero != 0) 
                    { 
                        ch1 = '零' + str1.Substring(temp, temp + 1); 
                        ch2 = str2.Substring(i,i + 1); 
                        nzero = 0; 
                    } 
                    else 
                    { 
                        ch1 = str1.Substring(temp, temp + 1); 
                        ch2 = str2.Substring(i, i + 1); 
                        nzero = 0; 
                    } 
                } 
            } 
            else 
            {  
                //该位是万亿，亿，万，元位等关键位 
                if (str3 != '0' && nzero != 0) 
                { 
                    ch1 = '零' + str1.Substring(temp, temp + 1); 
                    ch2 = str2.Substring(i, i + 1); 
                    nzero = 0; 
                } 
                else 
                { 
                    if (str3 != '0' && nzero == 0) 
                    { 
                        ch1 = str1.substring(temp, temp + 1); 
                        ch2 = str2.substring(i,i + 1); 
                        nzero = 0; 
                    } 
                    else 
                    { 
                        if (str3 == '0' && nzero >= 3) 
                        { 
                            ch1 = ''; 
                            ch2 = ''; 
                            nzero = nzero + 1; 
                        } 
                        else 
                        { 
                            if (j >= 11) 
                            { 
                                ch1 = ''; 
                                nzero = nzero + 1; 
                            } 
                            else 
                            { 
                                ch1 = ''; 
                                ch2 = str2.Substring(i, i+1); 
                                nzero = nzero + 1; 
                            } 
                        } 
                    } 
                } 
            } 
            if (i == (j-11) || i == (j-3) || i == (j-7)) 
            {  
                //如果该位是亿位或元位，则必须写上 
                ch2 = str2.Substring(i, i+1); 
            } 
            str5 = str5 + ch1 + ch2; 
 
            if (i == j-1 && str3 == '0' ) 
            {    
                //最后一位（分）为0时，加上“整” 
                str5 = str5 + '整'; 
            } 
        } 
        if (TotalSum == 0) 
        { 
            str5 = '零元整'; 
        } 
        return str5; 
    }
    
}