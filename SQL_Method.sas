libname orstar "c:\workshop\orionstar\orstar"; 
libname library "c:\sas\config\lev1\sasapp\sasenvironment\sasformats"; 
options fullstimer;
proc contents data=orstar.customer_dim; 
run; 

/*Two datasets are combined of which one fits in memory, a hash join is used*/
proc sql  _method _tree;
create table custorders as
select * 
from orstar.customer_dim c, orstar.order_fact as o
where c.customer_id=o.customer_id; 
quit; 
/*Fact is sorted, customer_dim is not sorted  are combined 
	a sort is done on customer_dim, 
		then a merge join is used*/
proc sort data=orstar.order_fact out=order_fact;
by customer_id;
run; 
proc sql  _method ;
create table custorders as
select * 
from orstar.customer_dim c, order_fact as o
where c.customer_id=o.customer_id; 
quit; 

/*Two sorted datasets are combined a merge join is used*/
proc sort data=orstar.order_fact out=order_fact;
by customer_id;
run; 
proc sort data=orstar.customer_dim out=customer_dim presorted;
by customer_id;
run; 
proc sql  _method _tree;
create table custorders as
select * 
from customer_dim c, order_fact as o
where c.customer_id=o.customer_id; 
quit; 
/*Two sorted datasets are combined a merge join is used*/

proc sort data=orstar.customer_dim out=customer_dim presorted;
by customer_id;
run; 
proc sql  _method _tree;
create table custorders as
select * 
from customer_dim c, orstar.order_fact as o
where c.customer_id=o.customer_id; 
quit; 
