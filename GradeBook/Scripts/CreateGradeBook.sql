USE [GradeBook]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[student_id] [int] IDENTITY(1,1) NOT NULL,
	[f_name] [varchar](35) NOT NULL,
	[l_name] [varchar](35) NOT NULL,
	[birthdate] [date] NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[student_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Instructor]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Instructor](
	[instructor_id] [int] IDENTITY(1,1) NOT NULL,
	[f_name] [varchar](35) NULL,
	[l_name] [varchar](35) NULL,
	[login] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Instructor] PRIMARY KEY CLUSTERED 
(
	[instructor_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Course]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Course](
	[course_id] [int] IDENTITY(1,1) NOT NULL,
	[course_name] [varchar](35) NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NOT NULL,
	[instructor_id] [int] NULL,
	[roster_finalized] [bit] NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[course_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[CollectSessionInfoInstructor]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CollectSessionInfoInstructor] 

      -- Add the parameters for the stored procedure here

      @username VARCHAR(20)

AS

BEGIN

      -- SET NOCOUNT ON added to prevent extra result sets from

      -- interfering with SELECT statements.

      SET NOCOUNT ON;

 

    -- Insert statements for procedure here

      

      SELECT [instructor_id], [f_name], [l_name] FROM [Instructor] WHERE [login] = @username     

END
GO
/****** Object:  StoredProcedure [dbo].[Login]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:        Edward Radau

-- Create date: 6/3/2013

-- Description:   Login procedure

-- =============================================

CREATE PROCEDURE [dbo].[Login] 

      -- Add the parameters for the stored procedure here

      @username VARCHAR(20), 

      @password VARCHAR(20)

AS

BEGIN

      DECLARE @count INT

 

      -- SET NOCOUNT ON added to prevent extra result sets from

      -- interfering with SELECT statements.

      SET NOCOUNT ON;

 

    -- Insert statements for procedure here

      SELECT @count = count(DISTINCT [instructor_id]) FROM [dbo].[Instructor]

                  WHERE [login] = @username AND

                          [password] = @password    

                                          

      RETURN @count           

END
GO
/****** Object:  StoredProcedure [dbo].[UserExists]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:        Edward Radau

-- Create date: 6/21/2013

-- Description:   This script will determine if a user already exists and will return an indicator

-- =============================================

CREATE PROCEDURE [dbo].[UserExists] 
      -- Add the parameters for the stored procedure here

      @username VARCHAR(20)
AS

BEGIN
      DECLARE @count INT 

      -- SET NOCOUNT ON added to prevent extra result sets from
      -- interfering with SELECT statements.

      SET NOCOUNT ON; 

    -- Insert statements for procedure here

      SELECT @count = COUNT(DISTINCT [instructor_id]) FROM [dbo].[Instructor]
                              WHERE [login] = @username
      RETURN @count           

END
GO
/****** Object:  Table [dbo].[Tag]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tag](
	[tag_id] [int] IDENTITY(1,1) NOT NULL,
	[tag_type] [varchar](35) NULL,
	[tag_weight] [float] NULL,
	[course_id] [int] NOT NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[tag_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Student_has_Courses]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student_has_Courses](
	[student_id] [int] NULL,
	[course_id] [int] NULL,
	[final_grade] [float] NULL,
	[instructor_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[FinalizeRoster]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: 11/6/13
-- Description: Finalizes the roster of a particular course
-- =============================================
CREATE PROCEDURE [dbo].[FinalizeRoster] 
	-- Add the parameters for the stored procedure here
	@course_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    UPDATE [Course] SET roster_finalized = 1 WHERE course_id = @course_id
END
GO
/****** Object:  StoredProcedure [dbo].[CheckFinalized]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: 11/6/13
-- Description:	Checks if course is finalized
-- =============================================
CREATE PROCEDURE [dbo].[CheckFinalized]
	-- Add the parameters for the stored procedure here
	@course_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @result BIT

    -- Insert statements for procedure here
	SELECT @result = roster_finalized
	FROM [Course]
	WHERE course_id = @course_id
	
	RETURN @result
END
GO
/****** Object:  StoredProcedure [dbo].[CheckTagSystem]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: 10/7/2013
-- Description:	Checks to see if grading system scale is balanced
-- =============================================
CREATE PROCEDURE [dbo].[CheckTagSystem] 
	-- Add the parameters for the stored procedure here
	@course_id INT
AS
BEGIN
	DECLARE @result INT
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT @result = SUM(tag_weight)
    FROM [Tag]
    WHERE course_id = @course_id
    
    IF @result <> 1
		RETURN 0
	ELSE
		RETURN 1        
END
GO
/****** Object:  Table [dbo].[Assignments]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Assignments](
	[assignment_id] [int] IDENTITY(1,1) NOT NULL,
	[assignment_name] [varchar](50) NULL,
	[tag_id] [int] NULL,
 CONSTRAINT [PK_Assignments] PRIMARY KEY CLUSTERED 
(
	[assignment_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[AddNewStudent]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AddNewStudent]

	@f_name AS VARCHAR(30),
	@l_name AS VARCHAR(30),
	@instructor_id AS INT,
	@course_id AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [dbo].[Student] ([f_name],[l_name]) VALUES (@f_name, @l_name)
    
    DECLARE @id INT
    
    SET @id = SCOPE_IDENTITY()
    
    INSERT INTO [dbo].[Student_has_Courses] ([course_id], [student_id], [instructor_id]) VALUES (@course_id, @id, @instructor_id)
END
GO
/****** Object:  StoredProcedure [dbo].[ReturnInstructorCourses]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ReturnInstructorCourses] 

      -- Add the parameters for the stored procedure here

      @instructor_id INT

AS

BEGIN

      DECLARE @id INT

 

      -- SET NOCOUNT ON added to prevent extra result sets from

      -- interfering with SELECT statements.

      SET NOCOUNT ON;

 

    -- Insert statements for procedure here      

        SELECT	c.course_id AS c_id,
                course_name AS c_course_name,
                COUNT(Students.student_id) AS c_num_students,
                start_date AS c_start_date,
                end_date AS c_end_date

                FROM [Course] c
                LEFT JOIN [Student_has_Courses] Students 
                   ON Students.course_id = c.course_id AND Students.[instructor_id] = @instructor_id
                WHERE c.[instructor_id] = @instructor_id
                GROUP BY c.course_id, course_name, start_date, end_date

END
GO
/****** Object:  StoredProcedure [dbo].[ListStudentsForCourse]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Edward Radau
-- Create date: 6/27/2013
-- Description:   Returns all students for the Course ID
-- =============================================
CREATE PROCEDURE [dbo].[ListStudentsForCourse] 

      -- Add the parameters for the stored procedure here

      @course_id INT

AS

BEGIN

      -- SET NOCOUNT ON added to prevent extra result sets from

      -- interfering with SELECT statements.

      SET NOCOUNT ON;

 

    -- Insert statements for procedure here

      SELECT

            s.student_id,

            s.f_name,

            s.l_name,

            sp.final_grade

      FROM

            [dbo].[Student] s INNER JOIN
           (

                  SELECT final_grade, student_id

                  FROM [dbo].[Student_has_Courses]

                  WHERE course_id = @course_id            

            ) AS sp

            ON s.student_id = sp.student_id
END
GO
/****** Object:  StoredProcedure [dbo].[DisplayStudentFinalGrades]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: 11/13/2013
-- Description:	Displays the final grades of students, if they exist
-- =============================================
CREATE PROCEDURE [dbo].[DisplayStudentFinalGrades]
	-- Add the parameters for the stored procedure here
	@course_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT f_name As First,
		   l_name As Last,
		   final_grade As Final
		   FROM [Student],[Student_has_Courses]
		   WHERE [Student_has_Courses].student_id = [Student].student_id AND	
			     [Student_has_Courses].course_id = @course_id
    
    
END
GO
/****** Object:  Table [dbo].[Students_has_Assignments]    Script Date: 11/16/2013 13:12:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Students_has_Assignments](
	[student_id] [int] NULL,
	[assignment_id] [int] NULL,
	[assignment_grade] [float] NULL,
	[instructor_id] [int] NULL,
	[course_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[CreateNewAssignment]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: 10/9/2013
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CreateNewAssignment]
	@course_id INT,
	@assignment_name VARCHAR(30),
	@tag_id INT,
	@instructor_id INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @assignment_id INT
	DECLARE @student_id INT

    -- Insert statements for procedure here
    INSERT INTO [Assignments] (assignment_name, tag_id) VALUES (@assignment_name, @tag_id)
    
    SET @assignment_id = SCOPE_IDENTITY()
    
    -- I am using an iterative approach using this cursor to assign this particular assignment ID to ALL currently enrolled students
    DECLARE c Cursor FOR SELECT student_id FROM [Student] WHERE [Student].student_id IN ( SELECT student_id FROM [Student_has_Courses] WHERE [Student_has_Courses].course_id = @course_id )
    
    OPEN c
    
    FETCH NEXT FROM c INTO @student_id
		
    WHILE @@FETCH_STATUS=0 BEGIN
			INSERT INTO [Students_has_Assignments] (student_id, assignment_id, instructor_id, course_id) VALUES (@student_id, @assignment_id, @instructor_id, @course_id)
		FETCH NEXT FROM c INTO @student_id
    END
    
    CLOSE c
    DEALLOCATE c
    
END
GO
/****** Object:  StoredProcedure [dbo].[ListCourseAssignments]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ListCourseAssignments]
	@course_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT
		[Assignments].assignment_id,
		assignment_name,
		tag_type,
		AVG(assignment_grade) as average
	FROM [Assignments], [Tag]
			RIGHT JOIN [Students_has_Assignments]
		ON assignment_id = [Students_has_Assignments].assignment_id
	WHERE [Students_has_Assignments].course_id = @course_id AND [Assignments].tag_id = [Tag].tag_id AND [Assignments].assignment_id = [Students_has_Assignments].assignment_id
	GROUP BY [Assignments].[assignment_id], [assignment_name], [tag_type]
    
END
GO
/****** Object:  StoredProcedure [dbo].[ListAssignmentsByID]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ListAssignmentsByID]
	-- Add the parameters for the stored procedure here
	@assignment_id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  [Assignments].assignment_id,
			[Student].student_id,
			assignment_name,
			[Student].f_name,
			[Student].l_name,
			[Students_has_Assignments].assignment_grade
		FROM [Assignments], [Student]
			RIGHT JOIN [Students_has_Assignments]
		ON assignment_id = [Students_has_Assignments].assignment_id AND [Student].student_id = [Students_has_Assignments].student_id
		WHERE [Assignments].assignment_id = @assignment_id AND [Students_has_Assignments].assignment_id = @assignment_id
END
GO
/****** Object:  StoredProcedure [dbo].[FinalizeGrades]    Script Date: 11/16/2013 13:12:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Edward Radau
-- Create date: 11/14/13
-- Description:	Finalizes the grades of all courses that have ended.
-- =============================================
CREATE PROCEDURE [dbo].[FinalizeGrades] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- AUTHOR NOTE:
	-- I realize I'm taking a very procedural approach to this and that Set-based operations
	-- are better performance-wise, however I cannot think of any other way based on how I've
	-- setup the grading system based on it's tag system.
	
	-- If I can think of a faster way to solve this, I will update this script


	-- DECLARE @ClosedCourses TABLE(ID INT)
	DECLARE @Tags TABLE(ID INT)
	
	
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	
    -- First I want a list of all the IDs of courses that have concluded
    SELECT course_id INTO #ClosedCourses
		FROM [Course]
		WHERE [end_date] >= DATEADD(DAY,
									DATEDIFF(DAY,0,GETDATE() ), 
									0) AND
			  [end_date] < DATEADD(DAY,
								   1, 
								   DATEADD(DAY, DATEDIFF(DAY,0,GETDATE()),0))
								   
	-- I will begin finalizing the grades of each course
	DECLARE @CourseId INT
	DECLARE @TagId INT
	DECLARE @StudentId INT
	
	WHILE (SELECT COUNT(*) FROM #ClosedCourses) > 0
	BEGIN
		SELECT TOP 1 @CourseId = course_id FROM #ClosedCourses
		
		-- First let's focus on processing the grades of each student
		SELECT student_id INTO #AllStudentsInCourse
		FROM [Student_has_Courses]
		WHERE course_id = @CourseId
		
		WHILE (SELECT COUNT(*) FROM #AllStudentsInCourse) > 0
		BEGIN
			DECLARE @FINAL FLOAT = 0.0 -- The student's final
			
			SELECT TOP 1 @StudentId = student_id FROM #AllStudentsInCourse		
				
				SELECT tag_id, tag_weight INTO #ListTags
				FROM [Tag]
				WHERE course_id = @CourseId
				
				-- Now let's process each TYPE of assignment
				
				WHILE (SELECT COUNT(*) FROM #ListTags) > 0
				BEGIN
					DECLARE @TagWeight FLOAT
					DECLARE @TagAverage FLOAT									
					
					SELECT TOP 1 @TagId = tag_id FROM #ListTags
					
					SELECT @TagWeight = tag_weight
					FROM [Tag]
					WHERE tag_id = @TagId
					
					-- This query averages the section of a certain assignment type, eg "HomeWork"
					SELECT @TagAverage = AVG(assignment_grade)
					FROM [Students_has_Assignments], [Assignments]
					WHERE student_id = @StudentId AND course_id = @CourseId AND [Assignments].tag_id = @TagId AND [Students_has_Assignments].assignment_id = [Assignments].assignment_id
					
					SET @FINAL += (@TagAverage * @TagWeight)	-- Append what we have to the final grade			
					
					DELETE #ListTags WHERE tag_id = @TagId
				END
				--End tags
			
			UPDATE [Student_has_Courses] SET final_grade = @FINAL WHERE student_id = @StudentId AND course_id = @CourseId				
			
			-- I'm dropping it here since it complains of it already existing when I try to put more stuff into it
			DROP TABLE #ListTags												
			DELETE #AllStudentsInCourse WHERE student_id = @StudentId
		END
		--End students
		
		-- I'll need to do the same for Students since it's going to complain at a second iteration of Courses
		DROP TABLE #AllStudentsInCourse
		DELETE #ClosedCourses WHERE course_id = @CourseId
	END    
    -- End courses
    
END
GO
/****** Object:  Default [DF_Course_roster_finalized]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_roster_finalized]  DEFAULT ((0)) FOR [roster_finalized]
GO
/****** Object:  ForeignKey [FK_Assignments_Tag]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Assignments]  WITH CHECK ADD  CONSTRAINT [FK_Assignments_Tag] FOREIGN KEY([tag_id])
REFERENCES [dbo].[Tag] ([tag_id])
GO
ALTER TABLE [dbo].[Assignments] CHECK CONSTRAINT [FK_Assignments_Tag]
GO
/****** Object:  ForeignKey [FK_Instructor]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [FK_Instructor] FOREIGN KEY([instructor_id])
REFERENCES [dbo].[Instructor] ([instructor_id])
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK_Instructor]
GO
/****** Object:  ForeignKey [FK_Course_Courses]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Student_has_Courses]  WITH CHECK ADD  CONSTRAINT [FK_Course_Courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[Course] ([course_id])
GO
ALTER TABLE [dbo].[Student_has_Courses] CHECK CONSTRAINT [FK_Course_Courses]
GO
/****** Object:  ForeignKey [FK_Student_Courses]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Student_has_Courses]  WITH CHECK ADD  CONSTRAINT [FK_Student_Courses] FOREIGN KEY([student_id])
REFERENCES [dbo].[Student] ([student_id])
GO
ALTER TABLE [dbo].[Student_has_Courses] CHECK CONSTRAINT [FK_Student_Courses]
GO
/****** Object:  ForeignKey [FK_Course_Assignment]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Students_has_Assignments]  WITH CHECK ADD  CONSTRAINT [FK_Course_Assignment] FOREIGN KEY([course_id])
REFERENCES [dbo].[Course] ([course_id])
GO
ALTER TABLE [dbo].[Students_has_Assignments] CHECK CONSTRAINT [FK_Course_Assignment]
GO
/****** Object:  ForeignKey [FK_Student]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Students_has_Assignments]  WITH CHECK ADD  CONSTRAINT [FK_Student] FOREIGN KEY([student_id])
REFERENCES [dbo].[Student] ([student_id])
GO
ALTER TABLE [dbo].[Students_has_Assignments] CHECK CONSTRAINT [FK_Student]
GO
/****** Object:  ForeignKey [FK_Student_Assignment]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Students_has_Assignments]  WITH CHECK ADD  CONSTRAINT [FK_Student_Assignment] FOREIGN KEY([assignment_id])
REFERENCES [dbo].[Assignments] ([assignment_id])
GO
ALTER TABLE [dbo].[Students_has_Assignments] CHECK CONSTRAINT [FK_Student_Assignment]
GO
/****** Object:  ForeignKey [FK_Tag_Course]    Script Date: 11/16/2013 13:12:29 ******/
ALTER TABLE [dbo].[Tag]  WITH CHECK ADD  CONSTRAINT [FK_Tag_Course] FOREIGN KEY([course_id])
REFERENCES [dbo].[Course] ([course_id])
GO
ALTER TABLE [dbo].[Tag] CHECK CONSTRAINT [FK_Tag_Course]
GO
