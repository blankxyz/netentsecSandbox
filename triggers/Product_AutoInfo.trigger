/**
*Dis:自动生成产品编码，一级产品编号+二级产品编号+三级产品编号+四级产品编号+流水号，流水号为同类产品的流水号。
*Author:Gary_Hu
*Time:2013年5月2日14:06:11
**/
trigger Product_AutoInfo on Product2 (before insert) {



    set<Id> pFristId =  new set<id>();  //一级产品Id
    set<Id> pSecondId = new set<id>();  //二级产品Id
    set<Id> pThirdId = new set<id>();  //三级产品Id
    set<Id> pFourthId = new set<id>();  //四级产品Id
    
    
    DataFormat df = new DataFormat();
    
    Integer ICGSerialNo = 0; //ICG序列号
    Integer ITMSerialNo = 0; //ITM序列号
    Integer NGFWSerialNo = 0; //NGFW序列号
    Integer NPSSerialNo = 0; //NPS序列号
    Integer ASGSerialNo = 0; //ASG序列号
    Integer MSerialNo = 0; //M序列号
    Integer WOGSerialNo = 0; //WOG序列号
    Integer AndsalesSerialNo = 0; //再销售序列号
    Integer TrainingExpenseSerialNo = 0; //培训费序列号
    Integer AttCostSerialNo = 0; //维修费序列号
    Integer ServiceProductSerialNo = 0; //服务产品序列号
    

    
    for(Product2 pro : trigger.new){
        if(pro.n_FirstLevel__c != null && pro.n_SecondLevel__c != null && pro.n_ThirdLevel__c != null && pro.n_FourLevel__c != null){
            pFristId.add(pro.n_FirstLevel__c);
            pSecondId.add(pro.n_SecondLevel__c);
            pThirdId.add(pro.n_ThirdLevel__c);
            pFourthId.add(pro.n_FourLevel__c);
        System.debug(pro.n_ThirdLevel__c+'pro.n_ThirdLevel__c');
        System.debug(pro.n_FourLevel__c+'pro.n_FourLevel__c');
        }
    }
    //查询出一级别代码
    map<id,ProductionLevel__c> mapProlO = new map<id,ProductionLevel__c>([select n_levelNO__c from ProductionLevel__c where Id in: pFristId or Id in: pSecondId or Id in: pThirdId or Id in:pFourthId ]);

    list<ProductSerialNo__c> listprodSerialNo=[select SerialNo__c,Name from ProductSerialNo__c];
    //Name为键,ProductSerialNo__c对象为值
    map<string,ProductSerialNo__c> mapproSer=new map<string,ProductSerialNo__c>();
    if(listprodSerialNo.size()>0)
    {
        for(ProductSerialNo__c ps:listprodSerialNo)
        {
            if(ps.Name!=null)
            {
                if(!mapproSer.containsKey(ps.Name))
                {
                    mapproSer.put(ps.Name,ps);
                }
            }
        }
    }
    ProductSerialNo__c prICG;  
    ProductSerialNo__c prITM;  
    ProductSerialNo__c prNGFW;
    ProductSerialNo__c prNPS;   
    ProductSerialNo__c prASG; 
    ProductSerialNo__c prM;  
    ProductSerialNo__c prWOG;  
    ProductSerialNo__c prAndsales; 
    ProductSerialNo__c prTrainingExpense; 
    ProductSerialNo__c prAttCost;  
    ProductSerialNo__c prServiceProduct; 
    if(mapproSer.containsKey('ICGSerialNo'))
        prICG=mapproSer.get('ICGSerialNo');
    if(mapproSer.containsKey('ITMSerialNo'))
        prITM=mapproSer.get('ITMSerialNo');
    if(mapproSer.containsKey('NGFWSerialNo'))
        prNGFW=mapproSer.get('NGFWSerialNo');
    if(mapproSer.containsKey('NPSSerialNo'))
        prNPS=mapproSer.get('NPSSerialNo');
    if(mapproSer.containsKey('ASGSerialNo'))
        prASG=mapproSer.get('ASGSerialNo');
    if(mapproSer.containsKey('MSerialNo'))
        prM=mapproSer.get('MSerialNo');
    if(mapproSer.containsKey('WOGSerialNo'))
        prWOG=mapproSer.get('WOGSerialNo');
    if(mapproSer.containsKey('AndsalesSerialNo'))
        prAndsales=mapproSer.get('AndsalesSerialNo');
    if(mapproSer.containsKey('TrainingExpenseSerialNo'))
        prTrainingExpense=mapproSer.get('TrainingExpenseSerialNo');
    if(mapproSer.containsKey('AttCostSerialNo'))
        prAttCost=mapproSer.get('AttCostSerialNo');
    if(mapproSer.containsKey('ServiceProductSerialNo'))
        prServiceProduct=mapproSer.get('ServiceProductSerialNo');

    //操作ICG
    for(Product2 pro : trigger.new){
            String pOne;//一级产品
            String Ptwo;//二级产品
            String pthere;//三级产品
            String pFour;//四级产品

                if(pro.Family == 'ICG'){
                    System.debug(pro.n_ThirdLevel__c+'pro.n_ThirdLevel__c');
                    if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                        pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
                    }
                    if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                        Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
                    }
                    if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                        pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
                    }
                    if(mapProlO.containsKey(pro.n_FourLevel__c)){
                        pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
                    }
                    
                    ICGSerialNo = Integer.valueOf(prICG.SerialNo__c);
                    ICGSerialNo++;
                    pro.ProductCode = pOne + Ptwo + pthere + pFour + df.IntToString(ICGSerialNo, 4);
                }
            
            
    }
    prICG.SerialNo__c = ICGSerialNo;
    //update prICG;
     
    //操作流水号，判断产品系列 ITM
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == 'ITM'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            ITMSerialNo = Integer.valueOf(prITM.SerialNo__c);
            ITMSerialNo++;
            pro.ProductCode = pOne + Ptwo + pthere + pFour + df.IntToString(ITMSerialNo, 4);
        }
            
    }
    prITM.SerialNo__c = ITMSerialNo;
    //update prITM; 
    
    //操作流水号，判断产品系列 NGFW
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == 'NGFW'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            NGFWSerialNo = Integer.valueOf(prNGFW.SerialNo__c);
            NGFWSerialNo++;
            pro.ProductCode = pOne + Ptwo + pthere + pFour + df.IntToString(NGFWSerialNo, 4);
        }
            
    }
    prNGFW.SerialNo__c = NGFWSerialNo;
    //update prNGFW;
    
    //操作流水号，判断产品系列NPS
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == 'NPS'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            NPSSerialNo = Integer.valueOf(prNPS.SerialNo__c);
            NPSSerialNo++;
            pro.ProductCode = pOne + Ptwo + pthere + pFour + df.IntToString(NPSSerialNo, 4);
        }
            
    }
    prNPS.SerialNo__c = NPSSerialNo;
    //update prNPS;
    
    //操作流水号，判断产品系列 ASG(VPN)
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == 'ASG'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            ASGSerialNo = Integer.valueOf(prASG.SerialNo__c);
            ASGSerialNo++;
            pro.ProductCode = pOne + Ptwo + pthere + pFour + df.IntToString(ASGSerialNo, 4);
        }
            
    }
    prASG.SerialNo__c = ASGSerialNo;
    //update prASG;
    
    
    //操作流水号，判断产品系列 M
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == 'M'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            MSerialNo = Integer.valueOf(prM.SerialNo__c);
            MSerialNo++;
            pro.ProductCode =  pOne + Ptwo + pthere + pFour + df.IntToString(MSerialNo, 4);
        }
            
    }
    prM.SerialNo__c = MSerialNo;
    //update prM;
    
    //操作流水号，判断产品系列WOG
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == 'WOG'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            WOGSerialNo = Integer.valueOf(prWOG.SerialNo__c);
            WOGSerialNo++;
            pro.ProductCode =  pOne + Ptwo + pthere + pFour + df.IntToString(WOGSerialNo, 4);
        }
            
    }
    prWOG.SerialNo__c = WOGSerialNo;
   // update prWOG;
    
    //操作流水号，判断产品系列 再销售
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == '再销售'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            AndsalesSerialNo = Integer.valueOf(prAndsales.SerialNo__c);
            AndsalesSerialNo++;
            pro.ProductCode =  pOne + Ptwo + pthere + pFour + df.IntToString(AndsalesSerialNo, 4);
        }
            
    }
    prAndsales.SerialNo__c = AndsalesSerialNo;
    //update prAndsales;
    
    //操作流水号，判断产品系列 培训费
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == '培训费'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            TrainingExpenseSerialNo = Integer.valueOf(prTrainingExpense.SerialNo__c);
            TrainingExpenseSerialNo++;
            pro.ProductCode =  pOne + Ptwo + pthere + pFour + df.IntToString(TrainingExpenseSerialNo, 4);
            prTrainingExpense.SerialNo__c = TrainingExpenseSerialNo;
        }
            
    }
    
    //update prTrainingExpense;
    
        //操作流水号，判断产品系列 维修费
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == '维修费'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            AttCostSerialNo = Integer.valueOf(prAttCost.SerialNo__c);
            AttCostSerialNo++;
            pro.ProductCode =  pOne + Ptwo + pthere + pFour + df.IntToString(AttCostSerialNo, 4);
        }
            
    }
        prAttCost.SerialNo__c = AttCostSerialNo;
        //update prAttCost;
    
        //操作流水号，判断产品系列 服务产品
    for(Product2 pro : trigger.new){
            String pOne;
            String Ptwo;
            String pthere;
            String pFour;
        if(pro.Family == '服务产品'){
            if(mapProlO.containsKey(pro.n_FirstLevel__c)){
                pOne = String.valueOf(mapProlO.get(pro.n_FirstLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_SecondLevel__c)){
                Ptwo = String.valueOf(mapProlO.get(pro.n_SecondLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_ThirdLevel__c)){
                pthere = String.valueOf(mapProlO.get(pro.n_ThirdLevel__c).n_levelNO__c);
            }
            if(mapProlO.containsKey(pro.n_FourLevel__c)){
                pFour = String.valueOf(mapProlO.get(pro.n_FourLevel__c).n_levelNO__c);
            }
            ServiceProductSerialNo = Integer.valueOf(prServiceProduct.SerialNo__c);
            ServiceProductSerialNo++;
            pro.ProductCode =  pOne + Ptwo + pthere + pFour + df.IntToString(ServiceProductSerialNo, 4);
        }
            
    }
        prServiceProduct.SerialNo__c = ServiceProductSerialNo;
        //update prServiceProduct;
        update mapproSer.values();
}