### Tips to make sure your SqlToHtml script works:

- Test your query outside of the script before trying to put it through the SqlToHtml procedure
- Make sure you have a RowColor column in your query
- Make sure any aggregate columns have an alias
- You can only Order By a column that is in your select list. If you do not want one of your order by columns to be visible in the html table, you can prefix its alias with an underscore

### Useful notes:
- OrderBy is an optional parameter, you can pass a null value if you don't want to have a particular sort order
- If RowColor is left empty, default color is used
- You can alias any column to change the Header of that column on the html table
- A CASE statement for the RowColor column works very well for conditional formatting
- The RowColor field works with both words (e.g. 'Red', 'Green') and hex colors (e.g. '#32a852')
- You can run multiple queries through the SqlToHtml procedure in one prescript and concatenate the outputs together to display a list of tables

``` SQL
CREATE PROCEDURE [dbo].[ExamplePrescript] (
   @input dbo.ScriptInputParameters READONLY --List of [Name, Value]
)
AS
--##START dont modify
--Return table. Table containing stepnames and values.
--NOTE: also include variable @valid, @message and @stepInput, with there values.
--The Output table is same structure as the ScriptInputParameters the @input
DECLARE @Output TABLE(
  Name varchar(max),  --Name represents the stepname
  Value varchar(max)  --Value the value of the step
  )

SET NOCOUNT ON;

--declare standard variables to be set in return table
DECLARE @valid bit
DECLARE @message varchar(MAX)
DECLARE @stepInput varchar(MAX) 
SELECT @stepInput = Value FROM @input WHERE Name = 'StepInput' --set your variable to the incoming step input value 
--##END

--##your logic goes here

DECLARE @sql varchar(max)
DECLARE @OrderBy varchar(max)
DECLARE @html varchar(max)

SELECT @sql = CONCAT('SELECT Barcode, Qty, '''' as RowColor 
						FROM TrackingEntity 
						WHERE Barcode = ''', @stepInput, '''')

SELECT @OrderBy = 'ORDER BY Barcode DESC, Qty ASC'

EXEC dbo.SqlToHtml @sql, @OrderBy @html OUTPUT

INSERT INTO @Output
SELECT 'Instruction', @html

SELECT @valid = 1

--##your logic ends here

--DONT MODIFY - these values are not optional and should always be in your @Output table
----set standard output values for @message, @valid and @stepInput
	INSERT INTO @Output
	SELECT 'Message', @message
	INSERT INTO @Output
	SELECT 'Valid', @valid
	INSERT INTO @Output
	SELECT 'StepInput', @stepInput

----return values Output
	SELECT * FROM @Output
GO
```