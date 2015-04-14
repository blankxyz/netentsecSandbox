/*
* 功能: 根据关键字查找客户
* 作者：Alisa
* 日期：2013年4月25日
*/
public without sharing class clsAccountSearch {
    public Integer pageSize{get{return 20;}set;}
    public list<Account> listAccount{get;set;}
    public string strKey{get;set;}  
    String query='select id,Name from Account limit 0';
    private set<string> setBlackWord{get;set;}
    public SalesRegion__c sr{get;set;}
    
    public clsAccountSearch()
    {
        setBlackWord = new set<string>();
        list<SearchBlackWord__c> listBlackWord = [select BlackWord__c from SearchBlackWord__c];
        for(SearchBlackWord__c sbw : listBlackWord)
        {
            setBlackWord.add(sbw.BlackWord__c);
        }
    }
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {                 
                con = new ApexPages.StandardSetController(Database.getQueryLocator(query));                 
            }
            return con;
        }
        set;
    }

    public void searchAccount()
    {
        con.reset();
        listAccount = new List<Account>();
        if(strKey != null && strKey.length() > 0)
        {
            if(setBlackWord.contains(strKey))
            {
                return;
            }
            string strLike = '\'%' + strKey +'%\'';
            con =  new ApexPages.StandardSetController(Database.getQueryLocator('select name,owner.name,ChannelType__c,a.SellArea__r.Name,RecordTypeId from Account a where name like ' + strLike));
            con.setPageSize(pageSize);
            if(con.getResultSize() > 0)
            {
                for(Account acc:(List<Account>)con.getRecords()){
                    listAccount.add(acc);
                    //sr=[select Name from SalesRegion__c where Id=:(acc.SellArea__c)];
                }
            }
            else
            {       
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, '恭喜，该客户不存在，您可以创建该客户.');
                ApexPages.addMessage(myMsg);    
            }
        }
    }
    
    public Integer pageCount{
        get{
          if(categoryNumber==0)return 0;
          Integer i ;
          i = categoryNumber / pageSize;
          if(categoryNumber<=pageSize){
            return 1;
          } 
          if(i*pageSize!=categoryNumber){
            return i+1;
          } else {
            return i;
          }
      
    }set;
  }
    
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
   //获取查询结果数
    public Integer categoryNumber {
        get {
            return con.getResultSize();
        }
        set;
    }
   //判断是否有下一页  
    public Boolean hasNext {
       get {
         return con.getHasNext();
       }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
      // returns the first page of records
   public void first() {
    con.first();
        listAccount.clear();
        for(Account acc:(List<Account>)con.getRecords()){
        listAccount.add(acc);
       }
   }

   // returns the last page of records
   public void last() {
     con.last();
     listAccount.clear();
        for(Account acc:(List<Account>)con.getRecords()){
        listAccount.add(acc);
       }
   }

   // returns the previous page of records
   public void previous() {
      con.previous();
      listAccount.clear();
        for(Account acc:(List<Account>)con.getRecords()){
        listAccount.add(acc);
       }
   }

   // returns the next page of records
   public void next() {
      con.next();
      listAccount.clear();
        for(Account acc:(List<Account>)con.getRecords()){
        listAccount.add(acc);
       }
   }
}