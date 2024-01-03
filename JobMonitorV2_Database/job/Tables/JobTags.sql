CREATE TABLE [job].[JobTags] (
    [ID]     INT              IDENTITY (1, 1) NOT NULL,
    [Job_id] UNIQUEIDENTIFIER NOT NULL,
    [Tag]    NVARCHAR (50)    NOT NULL,
    CONSTRAINT [PK_JobTags] PRIMARY KEY CLUSTERED ([ID] ASC)
);

