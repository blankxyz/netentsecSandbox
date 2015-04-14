public class cbl_ProductSNDetialCommissioner 
{
    //自定义异常对象  
    public class MyException extends Exception {}
    public void cbl_ProductSNDetialCommissioner_beforeInsert(list<ProductSNDetial__c> listProductSNDetial)
    {
        set<string> setAccount=new set<string>();
        set<string> setProductSN=new set<string>();
        set<string> setId=new set<string>();
        for(ProductSNDetial__c po:listProductSNDetial)
        {
            setProductSN.add(po.ProductSN__c);
            setId.add(po.id);
            
        }
        if(setProductSN!=null && setProductSN.size()>0)
        {
            list<ProductSN__c> listProductSN=new  list<ProductSN__c>([select coustmer__c,id,dailishangmingcheng__c,name from ProductSN__c where id in:setProductSN]);
            map<id,ProductSN__c> mapProductSN=new map<id,ProductSN__c>();
            for(ProductSN__c p:listProductSN)
            {
                if(p.dailishangmingcheng__c!=null && p.coustmer__c==null)
                {
                    setAccount.add(p.dailishangmingcheng__c);
                }
                else if(p.dailishangmingcheng__c==null && p.coustmer__c!=null)
                {
                    setAccount.add(p.coustmer__c);
                }
                else if(p.dailishangmingcheng__c!=null && p.coustmer__c!=null)
                {
                    setAccount.add(p.coustmer__c);
                }
                mapProductSN.put(p.id,p);
            }
            list<ProductSNDetial__c> listProductSNDetials =new list<ProductSNDetial__c>([select id,name,ProductSN__c,AccountCommissioner__c from ProductSNDetial__c where id in:setId]);
            if(setAccount!=null && setAccount.size()>0)
            {
                map<id,Account> mapAccount=new map<id,Account>([select id,ResponsibleForCustomerSpecialist__c from account where id in:setAccount ]);
            
                for(ProductSNDetial__c po:listProductSNDetials)
                {
                    if(mapAccount.containsKey(mapProductSN.get(po.ProductSN__c).coustmer__c))
                    {
                        if(mapAccount.get(mapProductSN.get(po.ProductSN__c).coustmer__c).ResponsibleForCustomerSpecialist__c!=null)
                        {
                            //ProductSNDetial__c pol=new ProductSNDetial__c();
                            po.AccountCommissioner__c=mapAccount.get(mapProductSN.get(po.ProductSN__c).coustmer__c).ResponsibleForCustomerSpecialist__c;
                            //pol.id=po.id;
                            //listProductSNDetials.add(pol);
                        }
                        
                    }
                    else
                    {
                        if(mapAccount.get(mapProductSN.get(po.ProductSN__c).dailishangmingcheng__c).ResponsibleForCustomerSpecialist__c!=null)
                        {
                            //ProductSNDetial__c pol=new ProductSNDetial__c();
                            po.AccountCommissioner__c=mapAccount.get(mapProductSN.get(po.ProductSN__c).dailishangmingcheng__c).ResponsibleForCustomerSpecialist__c;
                            //pol.id=po.id;
                            //listProductSNDetials.add(pol);
                        }
                    }
                    
                }
                //throw new MyException('信息：'+listProductSNDetials);
                if(listProductSNDetials!=null && listProductSNDetials.size()>0)
                {
                    update listProductSNDetials;
                }
            }
            
        }
        
        
    }
    
    public void cbl_ProductSNDetialCommissioner_AfterInsert(list<ProductSNDetial__c> listProductSNDetial)
    {
        set<string> setProduct=new set<string>();
        set<string> setProductId=new set<string>();
        set<string> setProductSn=new set<string>();
        set<string> OrdersName=new set<string>();
        map<string,string> mapOrder=new map<string,string>();
        map<string,string> mapProduct2=new map<string,string>();
        map<string,Product2> mapProduct=new map<string,Product2>();
        map<string,ProductSN__c> mapProductSN=new map<string,ProductSN__c>();
        for(ProductSNDetial__c p:listProductSNDetial)
        {
            if(p.ProductName__c!=null)
            {
                setProduct.add(p.ProductName__c);
            }
            if(p.Products__c!=null)
            {
                setProductId.add(p.Products__c);
            }
            if(p.ProductSNname__c!=null)
            {
                setProductSn.add(p.ProductSNname__c);
            }
            if(p.OrdersName__c!=null)
            {
                OrdersName.add(p.OrdersName__c);
            }
        }
        if(setProduct!=null && setProduct.size()>0)
        {
            list<Product2> listProduct2=new list<Product2>([select id,n_FirstLevel__c,n_SecondLevel__c,n_ThirdLevel__c,n_FourLevel__c,ProductCode from Product2 where ProductCode in:setProduct]);
            for(Product2 p:listProduct2)
            {
                if(p.n_FourLevel__c!=null)
                {
                    mapProduct2.put(p.ProductCode,p.n_FourLevel__c);
                }
                else if(p.n_ThirdLevel__c!=null)
                {
                    mapProduct2.put(p.ProductCode,p.n_ThirdLevel__c);
                }
                else if(p.n_SecondLevel__c!=null)
                {
                    mapProduct2.put(p.ProductCode,p.n_SecondLevel__c);
                }
                else if(p.n_FirstLevel__c!=null)
                {
                    mapProduct2.put(p.ProductCode,p.n_FirstLevel__c);
                }
                mapProduct.put(p.ProductCode,p);
            }
        }
        if(setProductId!=null && setProductId.size()>0)
        {
            list<Product2> listProduct2=new list<Product2>([select id,n_FirstLevel__c,n_SecondLevel__c,n_ThirdLevel__c,n_FourLevel__c,ProductCode from Product2 where id in:setProductId  ]);
            for(Product2 p:listProduct2)
            {
                if(p.n_FourLevel__c!=null)
                {
                    if(!mapProduct2.containsKey(p.ProductCode))
                    {
                        mapProduct2.put(p.id,p.n_FourLevel__c);
                    }
                    
                }
                else if(p.n_ThirdLevel__c!=null)
                {
                    if(!mapProduct2.containsKey(p.ProductCode))
                    {
                        mapProduct2.put(p.id,p.n_ThirdLevel__c);
                    }
                    
                }
                else if(p.n_SecondLevel__c!=null)
                {
                    if(!mapProduct2.containsKey(p.ProductCode))
                    {
                        mapProduct2.put(p.id,p.n_SecondLevel__c);
                    }
                    
                }
                else if(p.n_FirstLevel__c!=null)
                {
                    if(!mapProduct2.containsKey(p.ProductCode))
                    {
                        mapProduct2.put(p.id,p.n_FirstLevel__c);
                    }
                    
                }
                
            }
        }
        if(setProductSn!=null && setProductSn.size()>0)
        {
            list<ProductSN__c> listProductSN=new list<ProductSN__c>([select id,name from ProductSN__c where Name in:setProductSn]);
            for(ProductSN__c p:listProductSN)
            {
                mapProductSN.put(p.name,p);
            }
        }
        
        if(OrdersName!=null && OrdersName.size()>0)
        {
            list<Orders__c> listOrders=new list<Orders__c>([select id,name,OrderNum__c from Orders__c where OrderNum__c in:OrdersName]);
            for(Orders__c o:listOrders)
            {
                if(!mapOrder.containsKey(o.OrderNum__c))
                {
                    mapOrder.put(o.OrderNum__c,o.id);
                }
            }
            //mapOrder
        }
        
        for(ProductSNDetial__c p:listProductSNDetial)
        {
            if(p.ProductName__c!=null)
            {
                if(mapProduct.containsKey(p.ProductName__c))
                {
                    p.Products__c=mapProduct.get(p.ProductName__c).id;
                    p.ProductLevel__c=mapProduct2.get(p.ProductName__c);
                }
                
            }
            if(p.ProductName__c==null)
            {
            
                p.ProductLevel__c=mapProduct2.get(p.Products__c);
            }
            if(p.ProductSNname__c!=null)
            {
                if(mapProductSN.containsKey(p.ProductSNname__c))
                {
                    p.ProductSN__c=mapProductSN.get(p.ProductSNname__c).id;
                }
                
            }
            if(p.OrdersName__c!=null)
            {
                if(mapOrder.containsKey(p.OrdersName__c))
                {
                    p.Order__c=mapOrder.get(p.OrdersName__c);
                }
            }
        }
        
    }
    
}