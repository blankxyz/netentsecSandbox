/**
*Dis:SN自动修改SN明细的 硬件开始、结束日期。 Lic开始日期、结束日期
*Author:Gary Hu
*Time:2014年5月26日11:52:21
**/
trigger Trg_SN_AutoUpdateDetails on ProductSN__c (after update) {
    set<Id> sId = new set<Id>();//序列号Id
    //键为 id 值为 ProductSN__c
    
    for(ProductSN__c p: trigger.new)
    {
        if(trigger.oldMap.get(p.id).EmpLicense__c != p.EmpLicense__c || trigger.oldMap.get(p.id).EmpLicenseEndDate__c != p.EmpLicenseEndDate__c || trigger.oldMap.get(p.id).Licensestar__c != p.Licensestar__c || trigger.oldMap.get(p.id).LicensEndRemind__c != p.LicensEndRemind__c)
        {
            sId.add(p.id);
        }
    }
    System.debug(sId+'-------------sId-----------------');
    if(sId.size() > 0)
    {
        //获取序列号明细的SN
        list<ProductSNDetial__c> listProDet = [select SerialNumberType__c,EndDate__c,StartDate__c,ProductSN__c,Remark__c from ProductSNDetial__c where ProductSN__c in: sId];
        List<ProductSNDetial__c> listUpdate = new List<ProductSNDetial__c>();
        for(ProductSNDetial__c listProDetX :listProDet)
        {
            if(trigger.newMap.containsKey(listProDetX.ProductSN__c))
            {
                if(listProDetX.SerialNumberType__c == '硬件License')
                {
                    String h = String.valueOf(DateTime.now().hour());
                    String m = String.valueOf(DateTime.now().minute());
                    String s = String.valueOf(DateTime.now().second());
                
                    String y = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c.year());
                    String mo =String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c.month());
                    String d = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c.day());
                    
                    String dateTimeX = y+'-'+mo+'-'+d+' '+h+':'+m+':'+s;
                    System.debug(dateTimeX+'----------dateTimeX-----------------');
                    DateTime newDate = dateTime.valueOf(dateTimeX);
                    System.debug(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c+'-------nowTime---------');
                    System.debug(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c.year()+'-------year---------'+y);
                    System.debug(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c.month()+'-------month---------'+mo);
                    System.debug(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicense__c.day()+'-------day---------'+d);
                    System.debug( newDate+'----newDate------');
                    
                    System.debug( DateTime.valueOf('2014-05-27 16:34:09')+'-------------DateTime-----------------');
                    System.debug(newDate+'-------------newDate-------------------');
                    listProDetX.StartDate__c = newDate;
                    
                    String ye = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicenseEndDate__c.year());
                    String moe =String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicenseEndDate__c.month());
                    String de = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).EmpLicenseEndDate__c.day());
                    
                    String he = String.valueOf(DateTime.now().hour());
                    String me = String.valueOf(DateTime.now().minute());
                    String se = String.valueOf(DateTime.now().second());
                
                    
                    String dateTimeXe = ye+'-'+moe+'-'+de+' '+he+':'+me+':'+se;
                    DateTime newDateXe = dateTime.valueOf(dateTimeXe);
                    listProDetX.EndDate__c = newDateXe;
                }
                if(listProDetX.SerialNumberType__c == 'License')
                {
                    String yl = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).Licensestar__c.year());
                    String mol =String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).Licensestar__c.month());
                    String dl = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).Licensestar__c.day());
                    
                    String hl = String.valueOf(DateTime.now().hour());
                    String ml = String.valueOf(DateTime.now().minute());
                    String sl = String.valueOf(DateTime.now().second());
                    String dateTimeXl = yl+'-'+mol+'-'+dl+' '+hl+':'+ml+':'+sl;
                    DateTime newDateXl = dateTime.valueOf(dateTimeXl);
                    
                    listProDetX.StartDate__c = newDateXl;
                    
                    String yle = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).Licenseend__c.year());
                    String mole =String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).Licenseend__c.month());
                    String dle = String.valueOf(trigger.newMap.get(listProDetX.ProductSN__c).Licenseend__c.day());
                    
                    String hle = String.valueOf(DateTime.now().hour());
                    String mle = String.valueOf(DateTime.now().minute());
                    String sle = String.valueOf(DateTime.now().second());
                    String dateTimeXle = yle+'-'+mole+'-'+dle+' '+hle+':'+mle+':'+sle;
                    DateTime newDateXle = dateTime.valueOf(dateTimeXle);
                    listProDetX.EndDate__c = newDateXle;
                }
                listProDetX.Remark__c = trigger.newMap.get(listProDetX.ProductSN__c).OrderName__c;
                listUpdate.add(listProDetX);
            }
        }
        update listUpdate;
    }
    
}