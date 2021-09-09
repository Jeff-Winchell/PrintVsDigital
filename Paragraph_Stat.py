import json,urllib.request, pandas
from bs4 import BeautifulSoup
with open('apikey.txt') as key:
    apikey=key.read()
years,chars_per_paragraph=list(range(1999,2022)),list()
for year in years:
    Paragraph_Lengths=list()
    for month in range(1,13):
        articledate=str(year)+'-'+('0'+str(month))[-2:]+'-01'
        currentPage,pages=1,1
        while currentPage<=pages:
            data=json.load(urllib.request.urlopen('https://content.guardianapis.com/search?from-date='+articledate+'&to-date='+articledate+'&show-blocks=all&page-size=50&currentPage='+str(currentPage)+'&api-key='+apikey))["response"]
            articles,pages=data['results'],data['pages']
            for article in articles:
                article=article['blocks']['body']
                if len(article)!=0:
                    Paragraph_Lengths.extend([len(paragraph.getText()) for paragraph in BeautifulSoup(article[0]['bodyHtml'],features='html.parser').find_all('p') if not paragraph.getText().startswith('Related: ')])
            currentPage+=1
        chars_per_paragraph.append(round(sum(Paragraph_Lengths)/len(Paragraph_Lengths)))
data=pandas.DataFrame(list(zip([str(year)[-2:] for year in years],chars_per_paragraph)),columns=['Year','Characters Per Paragraph'])
data.plot.bar(x='Year',y='Characters Per Paragraph',legend=False,title="The Guardian's Paragraphs over Time",ylabel='Characters Per Paragraph').figure.savefig('Guardian_Paragraph_Characters_By_Year.png')