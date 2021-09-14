*p306d04;

data country;
   length ContinentName $ 30;
   if _n_=1 then do;
      call missing(ContinentName);
      declare hash ContName(dataset:'orion.continent');
      ContName.definekey('ContinentID');
      ContName.definedata('ContinentName');
      ContName.definedone();
   end;
   set orion.country(keep=ContinentID Country CountryName);
   if ContName.find()=0;
run;


