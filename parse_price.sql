DELIMITER || 
CREATE FUNCTION PARSE_PRICE (xml_metadata LONGTEXT) RETURNS DECIMAL(20, 2) DETERMINISTIC 
BEGIN

    DECLARE price VARCHAR(200);
    DECLARE price_num DECIMAL(20, 2) DEFAULT 0;

    SET price := ExtractValue(
            xml_metadata,
            '//datafield[@tag="020"]/subfield[@code="c"]'
        );

    IF price RLIKE "^[^[:alpha:]]*(грн[^[:alpha:]]*коп|грн)[[:space:][:punct:]]*$" != 1 
        THEN RETURN price_num;
    END IF;

    SET price := REGEXP_REPLACE(
            price,
            "грн|коп|hrn|[[:space:][:punct:]]",
            "."
        );

    IF price RLIKE "^[0-9.]*$" = 1 
        THEN SET price := REGEXP_SUBSTR(
            REGEXP_REPLACE(price, "[.]{2,}", "."),
            "[0-9]+.[0-9]+|[0-9]*"
        );

        IF price != "" AND (NOT price IS NULL) 
            THEN SET price_num := CAST(price as DECIMAL(20, 2));
        END IF;
    END IF;

    RETURN price_num;

END; ||
DELIMITER ;