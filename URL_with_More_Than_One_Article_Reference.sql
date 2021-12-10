With Dupe As (
Select Article_Id,
		Max(URL) As URL,
		Count(*) As Paragraphs,
		Sum(Len(Paragraph)) As Characters
	From Newspaper..Article 
			Inner Join 
		Newspaper..Content 
				On Article.Id=Content.Article_Id
	Where URL In (Select URL 
					From Newspaper..Article 
					Group By URL 
					Having Count(*)>1)
	Group By Article_Id)
Select A1.Article_Id,A2.Article_Id,A1.Characters,A2.Characters,1 As Same_Paragraph_Count,Abs(A1.Characters-A2.Characters) As Char_Cnt_Diff
	From Dupe As A1
			Inner Join
		Dupe As A2
				On A1.URL=A2.URL
					And A1.Paragraphs=A2.Paragraphs
					And A1.Article_Id<A2.Article_Id
Union All
Select A1.Article_Id,A2.Article_Id,A1.Characters,A2.Characters,0 As Same_Paragraph_Count,Abs(A1.Characters-A2.Characters) As Char_Cnt_Diff
	From Dupe As A1
			Inner Join
		Dupe As A2
				On A1.URL=A2.URL
					And A1.Paragraphs<>A2.Paragraphs
					And A1.Article_Id<A2.Article_Id
	Order By 6 desc,1,2
--	select * from Newspaper..Article where id in (18872,18878)
--	Select Article_Id,Paragraph_Number,Paragraph from Newspaper..Content Where Article_Id In (18872,188780) Order By Article_Id,Paragraph_Number