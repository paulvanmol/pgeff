/*create big Sales_history*/
libname orstar "D:\workshop\winsas\orstar";
libname library "D:\workshop\winsas\orfmt";
options nofmterr;
proc sql; 
create table orion.sales_historyb as
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
quit;


	 
