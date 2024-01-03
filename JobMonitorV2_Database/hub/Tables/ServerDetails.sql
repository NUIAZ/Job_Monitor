CREATE TABLE [hub].[ServerDetails] (
    [PK_ID]          INT           IDENTITY (1, 1) NOT NULL,
    [ServerName]     VARCHAR (50)  NOT NULL,
    [DataCenterName] VARCHAR (50)  NOT NULL,
    [DateAdded]      DATETIME      CONSTRAINT [DF_JM_ServerInformation_DateAdded] DEFAULT (getdate()) NOT NULL,
    [ModifiedByDate] DATETIME      CONSTRAINT [DF_JM_ServerInformation_LastUpdated] DEFAULT (getdate()) NULL,
    [ModifiedByUser] VARCHAR (100) NULL,
    [CreatedByUser]  VARCHAR (100) CONSTRAINT [DF_ServerDetails_CreatedByUser] DEFAULT ('system') NOT NULL,
    [GetThreshold]   BIT           CONSTRAINT [DF_ServerDetails_GetThreshold] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_JM_ServerInformation] PRIMARY KEY CLUSTERED ([PK_ID] ASC)
);

