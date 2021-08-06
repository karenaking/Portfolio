--Happiness Scores by Country

Select [Country name], [Ladder score]
From HappinessProject..WorldHappinessReport2021
Group by [Country name], [Ladder score]
Order by 1,2

--Happiness Scores by Region
Select [Regional indicator], [Ladder score]
From HappinessProject..WorldHappinessReport2021
Group by [Regional indicator], [Ladder score]
Order by 1,2

--Happiness Scores Correlated with Freedom to Make Life Choices
Select [Country name], [Ladder score], [Freedom to make life choices]
From HappinessProject..WorldHappinessReport2021
Order by 1,2,3