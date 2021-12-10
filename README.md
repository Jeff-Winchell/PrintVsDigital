# PrintVsDigital
 Comparing how newspaper articles have changed from print to digital.
 
run make_main_env.bat to create the python environment required to run this code (assumes you have anaconda or miniconda already installed)

Then run the short python program Paragraph_Stat.py to create a graph (Guardian_Paragraph_Charters_By_Year.png) of typical paragraph size for each year in the Guardian's 20+ year 
online history (sampling ~1/30 of the paper's articles). Run time is expected to be 1-2 hours

Alternatively, download the entire dataset into a database for further (and faster) analysis using make_db.bat

After downloading the dataset into a database, there are 2 more SQL scripts to explore the duplicate URL issue (Guardian has more than 1 article pointing to the same public URL - obviously only one of those articles shows at the URL - There Can Be Only One!)
