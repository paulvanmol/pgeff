options dlcreatedir;
%let repoPath = s:/workshop/pgeff;
libname repo "&repoPath.";
libname repo clear;

data _null_;
rc = gitfn_clone("https://github.com/paulvanmol/pgeff/", "&repoPath.");
put rc=; 
run;

%include "&repoPath./cre8data.sas"; 