# PrintVsDigital
 Comparing how newspaper articles have changed from print to digital.
 
run make_main_env.bat to create the python environment required to run this code (assumes you have anaconda or miniconda already installed)

Then run the short python program Paragraph_Stat.py to create a graph (Guardian_Paragraph_Charters_By_Year.png) of typical paragraph size for each year in the Guardian's 20+ year online history (sampling ~1/30 of the paper's articles). Run time is expected to be 1-2 hours

Run DDL.sql in SQL Server to create empty database
Run Guardian2DB.py in python to download all the newspaper articles and store them in the database

There are 2 more SQL scripts to explore the duplicate URL issue (Guardian has more than 1 article pointing to the same public URL - obviously only one of those articles shows at the URL - There Can Be Only One!)
