public class AreaSalesTaskController{



    public decimal amoSumS { get {
            getDepartmentSalesTaskData();
            return amoSumS ;
        } set; }
    public decimal amoSum;
    public decimal planSumS {get; set;}
    public decimal planPercent {get; set;}
    public String width {get; set;}
    public String chartFilter { 
        get {
            if (chartFilter == Null) chartFilter = 'all';
            return chartFilter;
        }
        set;
    }
   public String chartYear { 
        get {
            if (chartYear == Null) chartYear = String.valueOf(System.today().year());
            return chartYear;
        }
        set;
    }
    public String chartQuarter { 
        get {
            if (chartQuarter == Null) chartQuarter = 'all';
            return chartQuarter;
        }
        set;
    }
    public static List<SelectOption> getChartFilterOptions() {
        List<SelectOption> years = new List<SelectOption>();
        years.add(new SelectOption('all','全公司'));
        years.add(new SelectOption('area1','区域'));
        years.add(new SelectOption('area2','华北大区'));
        years.add(new SelectOption('area3','行业部'));
        return years;
    }
    public static List<SelectOption> getChartYearOptions() {
        List<SelectOption> years = new List<SelectOption>();
        years.add(new SelectOption('2014','2014'));
        years.add(new SelectOption('2015','2015'));
        years.add(new SelectOption('2016','2016'));
        years.add(new SelectOption('2017','2017'));
        return years;
    }
    public static List<SelectOption> getChartQuarterOptions() {
        List<SelectOption> years = new List<SelectOption>();
        years.add(new SelectOption('all','全年'));
        years.add(new SelectOption('Q1','Q1'));
        years.add(new SelectOption('Q2','Q2'));
        years.add(new SelectOption('Q3','Q3'));
        years.add(new SelectOption('Q4','Q4'));
        return years;
    }
    public AreaSalesTaskController() {
        
    }
    public List<PieWedgeData> getDepartmentPieData()  {
    List<PieWedgeData> data = new List<PieWedgeData>();
    Date startDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
    Date endDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    Date QStartDate;
    Date QEndDate;
    if(ChartQuarter == 'all'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }else if(ChartQuarter == 'Q1'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 3, 31);
    }else if(ChartQuarter == 'Q2'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 04, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 6, 30);
    }else if(ChartQuarter == 'Q3'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 07, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 9, 30);
    }else if(ChartQuarter == 'Q4'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 10, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }
    List<Orders__c > dataList1 = [select OrderAmount__c, SalesRegion__c, SalesRegion__r.branchdepartment__c,SalesRegion__r.branchdepartment__r.name from Orders__c where ordersDate__c >=:startDate and ordersDate__c <=:endDate and ordersDate__c >=:QStartDate and ordersDate__c <=:QEndDate and  ( name like '%TRY%' or name like '%ORD%' or name like '%STO%') order by SalesRegion__c];
            Map<Id, decimal> areasMap = new Map<Id, decimal>();
            Map<Id, decimal> areasPlannedSaleMap = new Map<Id, decimal>();
            Id area; 
            for(Orders__c rec : dataList1 ) {
            if(chartFilter == 'all'){
                if(rec.SalesRegion__r.branchdepartment__c != null){
                    area = rec.SalesRegion__r.branchdepartment__c;
                }else{
                    area = rec.SalesRegion__c;
                }
             }else if(chartFilter == 'area1'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '区域办事处总部'){
                    area = rec.SalesRegion__c;
                }else{
                    continue;
                }  
             }else if(chartFilter == 'area2'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '华北区管理'){
                    area = rec.SalesRegion__c;
                }else{
                    continue;
                }  
             }else if(chartFilter == 'area3'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '政企行业部'){
                    area = rec.SalesRegion__c;
                }else{
                    continue;
                }  
             }
             
                if(areasMap.keyset().contains(area)) {
                    //easMap.get(area) = areasMap.get(area) + rec.OrderAmount__c;
                    areasMap.put(area,areasMap.get(area) + rec.OrderAmount__c);
                } else {
                    areasMap.put(area,rec.OrderAmount__c);

                }    
                     
            }  
            Map<decimal, Id> amountMap = new Map<decimal, Id>();
            Map<Id, decimal> areasMapOrder = new Map<Id, decimal>();
            decimal amount = 0;
            for(Id areaId : areasMap.keyset()){
                amount =areasMap.get(areaId);
                if(amountMap.containsKey(amount))
                {
                    amount += 0.001;
                }
                amountMap.put(amount,areaId);
            }
            List<Decimal> amountList = new List<Decimal>();
            amountList.addAll(amountMap.keySet());
            amountList.sort();

            list<SalesRegion__c> listSalesRegion=[select Name,Id from SalesRegion__c where Id in: areasMap.keyset()];
            list<SalesPlan__c> listSalesPlan=[select Department__c,Id, PlannedSale__c, Q1PlannedSale__c, Q2PlannedSale__c, Q3PlannedSale__c, Q4PlannedSale__c from SalesPlan__c where Department__c in: areasMap.keyset() and year__c = :chartYear];
             map<Id, string> mapSalesRegion=new map<Id, string>();
             for(SalesRegion__c s:listSalesRegion)
             {
                mapSalesRegion.put(s.Id, s.Name);
                for(SalesPlan__c plan :listSalesPlan){
                    if(s.id == plan.Department__c){
                         if(ChartQuarter == 'all'){
                            areasPlannedSaleMap.put(s.Id,plan.PlannedSale__c);
                        }else if(ChartQuarter == 'Q1'){
                            areasPlannedSaleMap.put(s.Id,plan.Q1PlannedSale__c);
                        }else if(ChartQuarter == 'Q2'){
                            areasPlannedSaleMap.put(s.Id,plan.Q2PlannedSale__c);
                        }else if(ChartQuarter == 'Q3'){
                            areasPlannedSaleMap.put(s.Id,plan.Q3PlannedSale__c);
                        }else if(ChartQuarter == 'Q4'){
                            areasPlannedSaleMap.put(s.Id,plan.Q4PlannedSale__c);
                        }
                     }
                }
                
             } 
             
             for (decimal amountOrder : amountList ) {
                  if(areasMap.get(amountMap.get(amountOrder)) > 0){
                      data.add(new PieWedgeData(mapSalesRegion.get(amountMap.get(amountOrder)), areasMap.get(amountMap.get(amountOrder))));
                  }
             }
            return data;
          }
    
    public class PieWedgeData   {
                      public String name { get; set; } 
                       public decimal data { get; set; } 
   
                       public PieWedgeData(String name, decimal data) { 
                                   this.name = name; 
                                   this.data = data; 
                       } 
          }

    public List<AreaSalesTaskData> getDepartmentSalesTaskData()  {

        system.debug('============季度=============' + chartQuarter);
        system.debug('============年度=============' + chartYear);
        system.debug('============部门=============' + chartFilter);        
    Date startDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
    Date endDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    Date QStartDate;
    Date QEndDate;
    if(ChartQuarter == 'all'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }else if(ChartQuarter == 'Q1'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 3, 31);
    }else if(ChartQuarter == 'Q2'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 04, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 6, 30);
    }else if(ChartQuarter == 'Q3'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 07, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 9, 30);
    }else if(ChartQuarter == 'Q4'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 10, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }
    List<Orders__c > dataList1 = [select OrderAmount__c, SalesRegion__c, SalesRegion__r.branchdepartment__c,SalesRegion__r.branchdepartment__r.name from Orders__c where ordersDate__c >=:startDate and ordersDate__c <=:endDate and ordersDate__c >=:QStartDate and ordersDate__c <=:QEndDate and  ( name like '%TRY%' or name like '%ORD%' or name like '%STO%') order by SalesRegion__c];
            Map<Id, decimal> areasMap = new Map<Id, decimal>();
            Map<Id, decimal> areasPlannedSaleMap = new Map<Id, decimal>();
            Id area;
            amoSum = 0;
            for(Orders__c rec : dataList1 ) {
             if(chartFilter == 'all'){
                if(rec.SalesRegion__r.branchdepartment__c != null){
                    area = rec.SalesRegion__r.branchdepartment__c;
                }else{
                    area = rec.SalesRegion__c;
                }
             }else if(chartFilter == 'area1'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '区域办事处总部'){
                    area = rec.SalesRegion__c;
                }else{
                    continue;
                }  
             }else if(chartFilter == 'area2'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '华北区管理'){
                    area = rec.SalesRegion__c;
                }else{
                    continue;
                }  
             }else if(chartFilter == 'area3'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '政企行业部'){
                    area = rec.SalesRegion__c;
                }else{
                    continue;
                }  
             }
            
            if(rec.OrderAmount__c != null){
                amoSum = rec.OrderAmount__c + amoSum ;
            }
 
            if(areasMap.keyset().contains(area)) {
                    //easMap.get(area) = areasMap.get(area) + rec.OrderAmount__c;
                    areasMap.put(area,areasMap.get(area) + rec.OrderAmount__c);
                } else {
                    areasMap.put(area,rec.OrderAmount__c);

                }         
            }
            Map<decimal, Id> amountMap = new Map<decimal, Id>();
            decimal amount = 0;
            for(Id areaId : areasMap.keyset()){
                amount =areasMap.get(areaId);
                if(amountMap.containsKey(amount))
                {
                    amount += 0.001;
                }
                amountMap.put(amount,areaId);
            }
            List<Decimal> amountList = new List<Decimal>();
            amountList.addAll(amountMap.keySet());
            amountList.sort();
            
            amoSumS = amoSum;      
            list<SalesRegion__c> listSalesRegion=[select Name,Id from SalesRegion__c where Id in: areasMap.keyset()];
            list<SalesPlan__c> listSalesPlan=[select Department__c,Id, PlannedSale__c, Q1PlannedSale__c, Q2PlannedSale__c, Q3PlannedSale__c, Q4PlannedSale__c from SalesPlan__c where Department__c in: areasMap.keyset() and year__c = :chartYear];
             map<Id, string> mapSalesRegion=new map<Id, string>();
             for(SalesRegion__c s:listSalesRegion)
             {
                mapSalesRegion.put(s.Id, s.Name);
                for(SalesPlan__c plan :listSalesPlan){
                    if(s.id == plan.Department__c){
                        if(ChartQuarter == 'all'){
                            areasPlannedSaleMap.put(s.Id,plan.PlannedSale__c);
                        }else if(ChartQuarter == 'Q1'){
                            areasPlannedSaleMap.put(s.Id,plan.Q1PlannedSale__c);
                        }else if(ChartQuarter == 'Q2'){
                            areasPlannedSaleMap.put(s.Id,plan.Q2PlannedSale__c);
                        }else if(ChartQuarter == 'Q3'){
                            areasPlannedSaleMap.put(s.Id,plan.Q3PlannedSale__c);
                        }else if(ChartQuarter == 'Q4'){
                            areasPlannedSaleMap.put(s.Id,plan.Q4PlannedSale__c);
                        }
                     }
                }
             }
          List<AreaSalesTaskData> posList = new List<AreaSalesTaskData>();
          AreaSalesTaskData pos;
          for (decimal amountOrder : amountList ) {
                 pos = new AreaSalesTaskData();
                  if(areasMap.get(amountMap.get(amountOrder)) > 0 || areasPlannedSaleMap.get(amountMap.get(amountOrder)) > 0){
                      pos.orderAmount= areasMap.get(amountMap.get(amountOrder));
                      if(areasPlannedSaleMap.get(amountMap.get(amountOrder))>0){
                          pos.plannedSale= areasPlannedSaleMap.get(amountMap.get(amountOrder));
                      }else{
                          pos.plannedSale= 0;
                      }
                      pos.area = mapSalesRegion.get(amountMap.get(amountOrder));
                      posList.add(pos);
                  }
          }
          planSumS = 0;
          for (AreaSalesTaskData posDetail : posList ) {
              planSumS = posDetail.plannedSale + planSumS;
          }
          planPercent=0;
          if(planSumS>0){
              planPercent = (amoSum * 100 / planSumS).setScale(2);
          }
          system.debug('++++posList+'+posList);
          return posList; 
    }
    public List<ProductsSalesData> getProductsSalesData()  {
    Date startDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
    Date endDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    Date QStartDate;
    Date QEndDate;
    if(ChartQuarter == 'all'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }else if(ChartQuarter == 'Q1'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 3, 31);
    }else if(ChartQuarter == 'Q2'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 04, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 6, 30);
    }else if(ChartQuarter == 'Q3'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 07, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 9, 30);
    }else if(ChartQuarter == 'Q4'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 10, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }
    List<Orders__c > dataList1 = [select OrderAmount__c, SalesRegion__c,SalesRegion__r.name, SalesRegion__r.branchdepartment__c,SalesRegion__r.branchdepartment__r.name, Type__c from Orders__c where ordersDate__c >=:startDate and ordersDate__c <=:endDate and ordersDate__c >=:QStartDate and ordersDate__c <=:QEndDate and  ( name like '%TRY%' or name like '%ORD%' or name like '%STO%') order by SalesRegion__c];
            Map<Id, ProductsSalesData> areasMap = new Map<Id, ProductsSalesData>();
            Map<Id, decimal> areasPlannedSaleMap = new Map<Id, decimal>();
            Id area;
            map<Id, string> mapSalesRegion=new map<Id, string>();
            for(Orders__c rec : dataList1 ) {
             if(chartFilter == 'all'){
                if(rec.SalesRegion__r.branchdepartment__c != null){
                    area = rec.SalesRegion__r.branchdepartment__c;
                    mapSalesRegion.put(area, rec.SalesRegion__r.branchdepartment__r.name);
                }else{
                    area = rec.SalesRegion__c;
                    mapSalesRegion.put(area, rec.SalesRegion__r.name);
                }
             }else if(chartFilter == 'area1'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '区域办事处总部'){
                    area = rec.SalesRegion__c;
                    mapSalesRegion.put(area, rec.SalesRegion__r.name);
                }else{
                    continue;
                }  
             }else if(chartFilter == 'area2'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '华北区管理'){
                    area = rec.SalesRegion__c;
                    mapSalesRegion.put(area, rec.SalesRegion__r.name);
                }else{
                    continue;
                }  
             }else if(chartFilter == 'area3'){
                
                if(rec.SalesRegion__r.branchdepartment__c != null && rec.SalesRegion__r.branchdepartment__r.name == '政企行业部'){
                    area = rec.SalesRegion__c;
                    mapSalesRegion.put(area, rec.SalesRegion__r.name);
                }else{
                    continue;
                }  
             }
             

                if(areasMap.keyset().contains(area)) {
                    if(rec.Type__c == 'NGFW' ){
                        areasMap.get(area).orderAmountNGFW = areasMap.get(area).orderAmountNGFW + rec.OrderAmount__c;
                    }else if(rec.Type__c == 'ICG' ){
                        areasMap.get(area).orderAmountICG = areasMap.get(area).orderAmountICG + rec.OrderAmount__c;
                    }else if(rec.Type__c == 'ITM' ){
                        areasMap.get(area).orderAmountITM = areasMap.get(area).orderAmountITM + rec.OrderAmount__c;
                    }else {
                        areasMap.get(area).orderAmountOthers = areasMap.get(area).orderAmountOthers + rec.OrderAmount__c;
                    }
                } else {
                    ProductsSalesData pos = new ProductsSalesData();
                    pos.area = mapSalesRegion.get(area);
                    pos.orderAmountNGFW = 0;
                    pos.orderAmountICG = 0;
                    pos.orderAmountITM = 0;
                    pos.orderAmountOthers = 0;
                    if(rec.Type__c == 'NGFW' ){
                        pos.orderAmountNGFW = rec.OrderAmount__c;
                        areasMap.put(area,pos);
                    }else if(rec.Type__c == 'ICG' ){
                        pos.orderAmountICG = rec.OrderAmount__c;
                        areasMap.put(area,pos);
                    }else if(rec.Type__c == 'ITM' ){
                        pos.orderAmountITM = rec.OrderAmount__c;
                        areasMap.put(area,pos);
                    }else {
                        pos.orderAmountOthers = rec.OrderAmount__c;
                        areasMap.put(area,pos);
                    }

                }    
              }               
          List<ProductsSalesData> posList = new List<ProductsSalesData>();
          for (Id areaId : areasMap.keyset() ) {
                      posList.add(areasMap.get(areaId));
          }
          system.debug('++++posList+'+posList);
          return posList; 
    }
public List<ProductsSalesTaskData> getProductsSalesTaskData()  {
    Date startDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
    Date endDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    Date QStartDate;
    Date QEndDate;
    if(ChartQuarter == 'all'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }else if(ChartQuarter == 'Q1'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 3, 31);
    }else if(ChartQuarter == 'Q2'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 04, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 6, 30);
    }else if(ChartQuarter == 'Q3'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 07, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 9, 30);
    }else if(ChartQuarter == 'Q4'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 10, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }
    List<Orders__c > dataList1 = [select OrderAmount__c, Type__c from Orders__c where ordersDate__c >=:startDate and ordersDate__c <=:endDate and ordersDate__c >=:QStartDate and ordersDate__c <=:QEndDate and  ( name like '%TRY%' or name like '%ORD%' or name like '%STO%') order by Type__c];
            Map<String, decimal> productsMap = new Map<String, decimal>();
            for(Orders__c rec : dataList1 ) {
                if(productsMap.keyset().contains(rec.Type__c)) {
                    productsMap.put(rec.Type__c,productsMap.get(rec.Type__c) + rec.OrderAmount__c);
                } else {
                    productsMap.put(rec.Type__c,rec.OrderAmount__c);

                }         
            }
            //system.debug('++++productsMap++'+productsMap );
            Map<decimal, String> amountMap = new Map<decimal, String>();
            //Map<String, decimal> productsMapOrder = new Map<String, decimal>();
            decimal amount = 0;
            for(String TypeId : productsMap.keyset()){
                amount =productsMap.get(TypeId);
                if(amountMap.containsKey(amount))
                {
                    amount += 0.001;
                }
                amountMap.put(amount,TypeId);
            }
            List<Decimal> amountList = new List<Decimal>();
            amountList.addAll(amountMap.keySet());
            amountList.sort();
          List<ProductsSalesTaskData> posList = new List<ProductsSalesTaskData>();
          ProductsSalesTaskData pos;

          for (decimal amountOrder : amountList ) {
                 pos = new ProductsSalesTaskData();
                  if(productsMap.get(amountMap.get(amountOrder)) > 0 && amountMap.get(amountOrder) != null){
                      pos.orderAmount= productsMap.get(amountMap.get(amountOrder));
                      pos.Product = amountMap.get(amountOrder);
                      posList.add(pos);
                  }
          }
          system.debug('++++posList+'+posList);
          return posList; 
    }
    public List<PieWedgeData> getProductsSalesPieData()  {
    List<PieWedgeData> data = new List<PieWedgeData>();
    Date startDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
    Date endDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    Date QStartDate;
    Date QEndDate;
    if(ChartQuarter == 'all'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }else if(ChartQuarter == 'Q1'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 01, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 3, 31);
    }else if(ChartQuarter == 'Q2'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 04, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 6, 30);
    }else if(ChartQuarter == 'Q3'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 07, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 9, 30);
    }else if(ChartQuarter == 'Q4'){
        QStartDate = Date.newInstance(Integer.valueOf(chartYear), 10, 01);
        QEndDate = Date.newInstance(Integer.valueOf(chartYear), 12, 31);
    }
    List<Orders__c > dataList1 = [select OrderAmount__c, Type__c from Orders__c where ordersDate__c >=:startDate and ordersDate__c <=:endDate and ordersDate__c >=:QStartDate and ordersDate__c <=:QEndDate and  ( name like '%TRY%' or name like '%ORD%' or name like '%STO%') order by Type__c];
            Map<String, decimal> productsMap = new Map<String, decimal>();
            for(Orders__c rec : dataList1 ) {
                if(productsMap.keyset().contains(rec.Type__c)) {
                    productsMap.put(rec.Type__c,productsMap.get(rec.Type__c) + rec.OrderAmount__c);
                } else {
                    productsMap.put(rec.Type__c,rec.OrderAmount__c);

                }         
            } 
            Map<decimal, String> amountMap = new Map<decimal, String>();
            decimal amount = 0;
            for(String TypeId : productsMap.keyset()){
                amount =productsMap.get(TypeId);
                if(amountMap.containsKey(amount))
                {
                    amount += 0.001;
                }
                amountMap.put(amount,TypeId);
            }
            List<Decimal> amountList = new List<Decimal>();
            amountList.addAll(amountMap.keySet());
            amountList.sort();           

          for (decimal amountOrder : amountList ) {

                  if(productsMap.get(amountMap.get(amountOrder)) > 0 && amountMap.get(amountOrder) != null){

                      data.add(new PieWedgeData(amountMap.get(amountOrder), productsMap.get(amountMap.get(amountOrder))));
                  }
          }
          return data; 
    }
       public class AreaSalesTaskData{ 
          public decimal orderAmount{get; set;}
          public decimal plannedSale{get; set;}
          public String area {get; set;}
      }
      public class ProductsSalesTaskData{ 
          public decimal orderAmount{get; set;}
          public decimal plannedSale{get; set;}
          public String Product{get; set;}
      } 
      public class ProductsSalesData { 
          public decimal orderAmountNGFW{get; set;}
          public decimal orderAmountICG{get; set;}
          public decimal orderAmountITM{get; set;}
          public decimal orderAmountOthers{get; set;}
          public String area {get; set;}
      }
}