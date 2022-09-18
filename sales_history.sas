proc contents data=orstar.customer_dim;
run;
/*create big Sales_history*/
%macro checkencoding; 
%if %superq(sysencoding)=%nrstr(utf-8) %then %do; 
libname orstar cvp "&path\orstar" cvpmultiplier=2;
libname library cvp "&path\orfmt" cvpmultiplier=2;
%end; 
%else %do; 
libname orstar base "&path\orstar" ;
libname library base "&path\orfmt" ;
%end; 
options nofmterr;
%mend ;
%checkencoding; 

proc sql feedback;
	create table orion.sales_history as
		select f.*, c.customer_country, p.product_group, p.product_category,t.year_id, t.Month_Num, t.Weekday_eu, t.week_name,
			f.Total_Retail_Price as Value_Sold format=dollar12.,
			(f.CostPrice_Per_Unit*f.Quantity) as Value_Cost format=dollar12., 
			f.order_date as Year_Month format=monyy7.
		from orstar.order_fact as f, 
			orstar.customer_dim as c,
			orstar.product_dim as p,
			orstar.time_dim as t
		where c.customer_id=f.customer_id 
			and p.product_id=f.product_id
			and t.date_id=f.order_date
	;
	create table orion.saleshistory as 
	        select F.Customer_ID as customerid, F.Employee_ID as employeeid, F.Street_ID as streetid, 
F.Order_Date as OrderDate, F.Delivery_Date as DeliveryDate, 
F.Order_ID as OrderID, F.Order_Type as OrderType, F.Product_ID as ProductID, F.Quantity, 
F.Total_Retail_Price as TotalRetailPrice, F.CostPrice_Per_Unit as CostPricePerUnit, 
F.Discount, C.Customer_Country as CustomerCountry, P.Product_Group as ProductGroup, 
P.Product_Category as ProductCategory, T.Year_ID as YearID, T.Month_Num as MonthNum, 
T.Weekday_EU as WeekdayEU, T.Week_Name as WeekName, F.Total_Retail_Price as Value_Sold label='Total Retail Price for 
This Product' format=DOLLAR12.0, F.CostPrice_Per_Unit * F.Quantity as Value_Cost 
format=DOLLAR12.0, F.Order_Date as Year_Month label='Date Order was placed by Customer' 
format=MONYY7.0
          from ORSTAR.ORDER_FACT F, ORSTAR.CUSTOMER_DIM C, ORSTAR.PRODUCT_DIM P, 
ORSTAR.TIME_DIM T
         where (C.Customer_ID = F.Customer_ID) and (P.Product_ID = F.Product_ID) and (T.Date_ID 
= F.Order_Date);
quit;

proc contents data=orion.saleshistory;
run;

proc print data=orion.sales_history (obs=25);
run;
