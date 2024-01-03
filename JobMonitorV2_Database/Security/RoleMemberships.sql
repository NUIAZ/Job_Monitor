ALTER ROLE [db_datawriter] ADD MEMBER [CORP\SqlAgentSvc];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [kochjobmonitor];


GO
ALTER ROLE [db_datareader] ADD MEMBER [CORP\SqlAgentSvc];


GO
ALTER ROLE [db_datareader] ADD MEMBER [kochjobmonitor];

