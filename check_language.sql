DELIMITER || 
CREATE FUNCTION CHECK_LANGUAGE (xml_metadata LONGTEXT, lang VARCHAR(80)) 
RETURNS BOOLEAN DETERMINISTIC 
BEGIN
    RETURN CASE 
        WHEN ExtractValue(
                xml_metadata,
                '//datafield[@tag="041"]/subfield[@code="a"]'
            ) LIKE lang THEN TRUE
        ELSE NULL
    END;
END; ||
DELIMITER ;