Select Id,URL
	Into #Article
	From Newspaper..Article
	Where URL In (Select URL 
					From Newspaper..Article 
					Group By URL 
					Having Count(*)>1)
Alter Table #Article Add Constraint Article_PK Primary Key(Id)
Select A1.URL,A1.Id As A1_Id,A2.Id As A2_Id
	Into #URL_Match
	From #Article A1
			Inner Join
		#Article A2
				On A1.URL=A2.URL
					And A1.Id<A2.Id
Alter Table #URL_Match Add Constraint URL_Match_PK Primary Key(URL,A1_Id,A2_Id)

Select Content.Id As Paragraph_Id,#Article.Id As Article_Id
	Into #Content
	From #Article 
			Inner Join 
		Newspaper..Content 
				On #Article.Id=Content.Article_Id
Alter Table #Content Add Constraint Content_PK Primary Key(Paragraph_Id)

Select Distinct #Content.Article_Id,Cast(value As NVarchar(448)) As Word
	Into #Article_Unique_Word
	From #Content
			Inner Join
		Newspaper..Content Words
				On #Content.Paragraph_Id=Words.Id
			Cross Apply
		String_Split(Words.Paragraph,' ')

Alter Table #Article_Unique_Word Alter Column Word NVarChar(448) Not Null
Alter Table #Article_Unique_Word Add Constraint Article_Unique_Word_PK Primary Key(Article_Id,Word)
--
Select Article_Id,Count(*) As Unique_Word_Count
	Into #Unique_Word_Count
	From #Article_Unique_Word
	Group By Article_Id
Alter Table #Unique_Word_Count Add Constraint Unique_Word_Count_PK Primary Key(Article_Id)

Select #URL_Match.URL,#URL_Match.A1_Id,#URL_Match.A2_Id,Count(*) As Common_Word_Count
	Into #Common_Word
	From #URL_Match
			Inner Join 
		#Article_Unique_Word UW1
				On #URL_Match.A1_Id=UW1.Article_Id
			Inner Join
		#Article_Unique_Word UW2
				On #URL_Match.A2_Id=UW2.Article_Id
	Where UW1.Word=UW2.Word
	Group By #URL_Match.URL,#URL_Match.A1_Id,#URL_Match.A2_Id
Alter Table #Common_Word Add Constraint Common_Word_PK Primary Key(URL,A1_Id,A2_Id)

Select #URL_Match.*,#Common_Word.URL,1.0*Coalesce(#Common_Word.Common_Word_Count,0)/(UW1.Unique_Word_Count+UW2.Unique_Word_Count-Coalesce(#Common_Word.Common_Word_Count,0)) As Jaccard_Similarity
	From #URL_Match
			Inner Join
		#Unique_Word_Count UW1
				On #URL_Match.A1_Id = UW1.Article_Id
			Inner Join
		#Unique_Word_Count UW2
				On #URL_Match.A2_Id=UW2.Article_Id
			Left Outer Join
		#Common_Word
				On #URL_Match.URL=#Common_Word.URL 
					And #URL_Match.A1_Id=#Common_Word.A1_Id
					And #URL_Match.A2_Id=#Common_Word.A2_Id
	Where 1.0*Coalesce(#Common_Word.Common_Word_Count,0)/(UW1.Unique_Word_Count+UW2.Unique_Word_Count-Coalesce(#Common_Word.Common_Word_Count,0)) <>1.0
Order By 5 Desc

--Select * From Newspaper..Content Where Article_Id In (2173385,2173387) Order By Article_Id,Paragraph_Number
