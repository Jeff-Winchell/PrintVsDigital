Use Master
Go
Drop Database If Exists Newspaper 
Go
Create Database Newspaper
Go
Alter Database Newspaper Set Recovery Simple
Use Newspaper
Go
Create FullText Catalog Newspaper As Default
Go
Create Table Article (
	Id Int Identity Not Null Constraint Article_PK Primary Key,
	URL VarChar(400) Not Null,-- Constraint Article_AK Unique,
	Publisher VarChar(25) Not Null,-- Constraint Publisher_Domain Check (Publisher In ('theguardian.com','The Guardian','The Observer','Guardian Weekly')),
	Published_On DateTimeOffSet Not Null,
	Last_Modified_On DateTimeOffSet Not Null,
	Byline VarChar(800) Null,
	Title VarChar(400) Not Null,
	Section VarChar(100) Not Null
	)
Go
Create Table Content (
	Article_Id Int Not Null Constraint Content__Article_FK Foreign Key References Article On Delete Cascade On Update No Action,
	Paragraph_Number SmallInt Not Null,
	Id Int Identity Not Null Constraint Content_AK Unique,
	Paragraph VarChar(Max) Not Null,
	Constraint Content_PK Primary Key (Article_Id,Paragraph_Number)
	)
Go
Create FullText Index On Content(Paragraph) Key Index Content_AK With StopList=Off
Go
