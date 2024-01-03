CREATE TABLE [job].[Tier] (
    [PK_ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Description]    VARCHAR (250) NULL,
    [Interval]       VARCHAR (40)  NOT NULL,
    [DateAdded]      DATETIME      CONSTRAINT [DF_Tier_DateAdded] DEFAULT (getdate()) NOT NULL,
    [ModifiedByDate] DATETIME      NULL,
    [ModifiedByUser] VARCHAR (40)  NULL,
    [Tier]           INT           NULL,
    CONSTRAINT [PK_Tier] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

