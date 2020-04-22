USE [Mittsure]
GO

ALTER PROCEDURE [mittrans].[GetDashBoardGraphData] 
@SchoolId int=null,
@Filter int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--Day
if(@Filter = 1)
begin
SELECT    DATEPART(HH,ScanDate) as t, Ltrim(Left(Right(CONVERT(nvarchar(30),ScanDate,100),7),2) + ' ' + Right(Right(CONVERT(nvarchar(30),ScanDate,100),7),2)) as Date, Count(*) as CountNo FROM mittrans.Scanlog
where     ScanDate between DATEADD(DAY, DATEDIFF(DAY, 0, Getdate()), 0) and GETDATE() and (@SchoolId=0 or SchoolID=@SchoolId)
GROUP BY  Ltrim(Left(Right(CONVERT(nvarchar(30),ScanDate,100),7),2) + ' ' + Right(Right(CONVERT(nvarchar(30),ScanDate,100),7),2)),DATEPART(HH,ScanDate)
order by  DATEPART(HH,ScanDate)
end
--Week
else if(@Filter =2)
begin
Select DATEPART(W,ScanDate) as t,CONVERT(nvarchar(6),ScanDate,107) as Date, Count(*) as CountNo from mittrans.Scanlog 
where ScanDate between DATEADD(week, DATEDIFF(week, 0, Getdate()), 0) and GETDATE() and (@SchoolId=0 or SchoolID=@SchoolId)
group by CONVERT(nvarchar(6),ScanDate,107),DATEPART(W,ScanDate) 
order by DATEPART(W,ScanDate) 
end
--month
else if(@Filter = 3)
begin
Select DATEPART(MM,ScanDate) as t, CONVERT(nvarchar(6),ScanDate,107) as Date, Count(*) as CountNo from mittrans.Scanlog 
where ScanDate between DATEADD(MONTH, DATEDIFF(MONTH, 0, Getdate()), 0) and GETDATE() and (@SchoolId=0 or SchoolID=@SchoolId)
group by CONVERT(nvarchar(6),ScanDate,107),DATEPART(MM,ScanDate)
order by DATEPART(MM,ScanDate)
end
--year
else  
begin
Select DATEPART(YYYY,ScanDate) as t, cast(datename(MONTH,cast(ScanDate as Date)) as nvarchar) + ' ' +  cast(datename(YEAR,cast(ScanDate as Date)) as nvarchar) as Date, Count(*) as CountNo from mittrans.Scanlog 
where ScanDate between DATEADD(YEAR, DATEDIFF(YEAR, 0, Getdate()), 0) and GETDATE() and (@SchoolId=0 or SchoolID=@SchoolId)
group by  cast(datename(MONTH,cast(ScanDate as Date)) as nvarchar) + ' ' +  cast(datename(YEAR,cast(ScanDate as Date)) as nvarchar),DATEPART(YYYY,ScanDate) 
order by DATEPART(YYYY,ScanDate)  
end
END
