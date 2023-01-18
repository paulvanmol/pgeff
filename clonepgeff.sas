options dlcreatedir;
%let path = s:/workshop/pgeff;
libname repo "&path.";
libname repo clear;

data _null_;
rc = gitfn_clone("https://github.com/paulvanmol/pgeff/", "&path.");
put rc=; 
run;

%include "&path./cre8data.sas"; 