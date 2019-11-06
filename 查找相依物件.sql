SELECT OBJECT_NAME(referencing_id) AS referencing_entity_name,
    o.type_desc AS referencing_desciption,
    COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,
    referencing_class_desc, referenced_class_desc,
    referenced_server_name, referenced_database_name, referenced_schema_name,
    referenced_entity_name, o2.type_desc as referenced_desciption,
    COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,
    is_caller_dependent, is_ambiguous
FROM sys.sql_expression_dependencies AS sed
    left outer JOIN sys.objects AS o ON sed.referencing_id = o.object_id
    left outer join sys.objects AS o2 on sed.referenced_id = o2.object_id 
WHERE
--referenced_entity_name like 'FGS_STOCK' --列出所有相依XXX的物件
/*
and referenced_entity_name not like 'FLM_V%'
and OBJECT_NAME(referencing_id) like 'PDM%'
*/
--referencing_id = OBJECT_ID(N'FMEdIssueExamDo') --列出所有XXX相依的物件
referencing_id in (select OBJECT_ID(name) from sys.sysobjects where name like 'FME%')
and referenced_entity_name not like 'FME%' and referenced_class_desc = 'OBJECT_OR_COLUMN'
order by referenced_entity_name
