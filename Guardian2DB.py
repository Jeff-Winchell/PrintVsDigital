def Get_Data(fromdate,todate,apikey):
    import json,urllib.request
    from bs4 import BeautifulSoup
    import pyodbc
    pyodbc.pooling=False
    with pyodbc.connect('Driver={SQL Server};Server=localhost;Database=Newspaper;Trusted_Connection=yes;').cursor() as Newspaper:
        currentPage,pages=1,1
        year='0000'
        while currentPage<=pages:
            APIURL='https://content.guardianapis.com/search?from-date='+fromdate+'&to-date='+todate+'&show-fields=body,byline,publication,lastModified&page-size=200&order-by=oldest&page='+str(currentPage)+'&api-key='+apikey
            data=json.load(urllib.request.urlopen(APIURL))["response"]
            articles,pages=data['results'],data['pages']
            for article in articles:
                URL=article['webUrl']
                Section=article['sectionName']
                Published_On=article['webPublicationDate']
                if Published_On[:4]!=year:
                    year=Published_On[:4]
                Title=article['webTitle']
                Publisher=article['fields']['publication']
                Content=article['fields']['body']
                Byline=article['fields']['byline'] if 'byline' in article['fields'] and len(article['fields']['byline'])<=8000 else None
                Last_Modified_On=article['fields']['lastModified']
                try:
                    Newspaper.execute('Insert Into Article (URL,Publisher,Published_On,Last_Modified_On,Byline,Title,Section) Values(?,?,?,?,?,?,?)',(URL,Publisher,Published_On,Last_Modified_On,Byline,Title,Section))
                    Newspaper.execute('Select @@Identity')
                    Article_Id=Newspaper.fetchone()[0]
                    Newspaper.commit()
                except pyodbc.Error as err:
                    print(err)
                    print(APIURL)
                    print(URL)
                    print(Section)
                    print(Published_On)
                    print(Title)
                    print(Publisher)
                    if Byline!= None:
                        print(Byline)
                    print(Last_Modified_On)
                    quit()
                if len(article)!=0:
                    Paragraph_Number=0
                    for paragraph in BeautifulSoup(Content,features='html.parser').find_all('p'):
                        if not paragraph.getText().strip().startswith('Related: '):
                            Paragraph_Number+=1
                            Paragraph=paragraph.getText()
                            Newspaper.execute('Insert Into Content(Article_Id,Paragraph_Number,Paragraph) Values (?,?,?)',(Article_Id,Paragraph_Number,Paragraph)).commit()
            currentPage+=1

with open('apikey.txt') as key:
    apikey=key.read()
Get_Data('1800-01-01','1998-12-31',apikey)
years,chars_per_paragraph=list(range(1999,2022)),list()
for year in years:
    Paragraph_Lengths=list()
    for month in range(1,13):
        print(year,month)
        fromdate=str(year)+'-'+('0'+str(month))[-2:]+'-01'
        if month in [9,4,6,11]:
            todate=str(year)+'-'+('0'+str(month))[-2:]+'-30'
        elif month == 2 and (year%4!=0 or year%400==0):
            todate=str(year)+'-'+('0'+str(month))[-2:]+'-28'
        elif month == 2 and year%4==0:
            todate=str(year)+'-'+('0'+str(month))[-2:]+'-29'
        else:
            todate=str(year)+'-'+('0'+str(month))[-2:]+'-31'
        Get_Data(fromdate,todate,apikey)