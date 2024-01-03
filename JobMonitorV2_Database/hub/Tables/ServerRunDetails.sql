CREATE TABLE [hub].[ServerRunDetails] (
    [PK_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [ServerName]  VARCHAR (50)  NOT NULL,
    [Information] VARCHAR (500) NOT NULL,
    [LastRun]     DATETIME      CONSTRAINT [DF_Table_1_DateAdded] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_Hub_ServerRunDetails] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

