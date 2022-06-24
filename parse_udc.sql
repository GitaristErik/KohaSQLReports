DELIMITER || 
CREATE FUNCTION PARSE_UDC (xml_metadata LONGTEXT) RETURNS INT DETERMINISTIC 
BEGIN

    DECLARE udc VARCHAR(200);
    SET udc = REPLACE(
            REGEXP_SUBSTR(
                ExtractValue(
                    xml_metadata,
                    '//datafield[@tag="080"]/subfield[@code="a"]'
                ),
                "[0-9].*"
            ),
            ' ',
            ''
        );

    RETURN CASE
        WHEN udc RLIKE "^(1|2|3[0-6]|93|94).*$" THEN 1
        WHEN udc RLIKE "^(5[1-9]|6[0-1]|91).*$" THEN 2
        WHEN udc RLIKE "^(62|6[4-6]).*$" THEN 3
        WHEN udc RLIKE "^(63).*$" THEN 4
        WHEN udc RLIKE "^(7[0-9]).*$" THEN 5
        WHEN udc RLIKE "^(821).*$" THEN 6
        WHEN udc RLIKE "^(087|50|398.2).*$" THEN 7
        WHEN udc RLIKE "^(80|81|82[02-9]).*$" THEN 8
        ELSE 0
    END;
END; ||
DELIMITER ;