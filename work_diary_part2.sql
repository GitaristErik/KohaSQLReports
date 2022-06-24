CREATE OR REPLACE VIEW copies_issued as 
SELECT
    CAST(s.datetime as DATE) as `Дата`,
    i.homebranch,
    i.location,
    br.branchname AS `Підрозділ`,
    av.lib AS `Розташування`,
    -- Книги
    COUNT(*) as `Всього видано`,
    COUNT(IF(bi.itemtype LIKE "BK", 1, NULL)) as `Книги`,
    COUNT(IF(bi.itemtype LIKE "BH", 1, NULL)) as `Брошури`,
    COUNT(IF(bi.itemtype LIKE "PER", 1, NULL)) as `Періодичні видання`,
    COUNT(IF(bi.itemtype LIKE "EB", 1, NULL)) as `Електронні видання`,
    COUNT(IF(bi.itemtype LIKE "AV", 1, NULL)) as `Аудіовізуальні`,
    -- UDC
    COUNT(IF(PARSE_UDC(bm.metadata) = 1, 1, NULL)) as `Суспільно-політична література`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 2, 1, NULL)) as `Пр-тво, математика, медицина`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 3, 1, NULL)) as `Техніка`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 4, 1, NULL)) as `С/Г`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 5, 1, NULL)) as `Мистецтво і спорт`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 6, 1, NULL)) as `Художня література`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 7, 1, NULL)) as `Л-ра для дошкільнят, казки`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 8, 1, NULL)) as `Мовознавство, літ-тво`,
    COUNT(IF(PARSE_UDC(bm.metadata) = 0, 1, NULL)) as `Інші`,
    -- Мови
    COUNT(CHECK_LANGUAGE(bm.metadata, "ukr")) as `Українською`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "rus")) as `Російською`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "eng")) as `Англійською`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "hun")) as `Угорською`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "rum")) as `Румунською`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "slo")) as `Словацькою`,
    -- Іноземною
    COUNT(
        IF(
            not ExtractValue(
                bm.metadata,
                '//datafield[@tag="041"]/subfield[@code="a"]'
            ) in ("rus", "ukr", "eng", "hun", "rum", "slo"),
            1,
            NULL
        )
    ) as `Іноземною`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "")) as `Без мови`
FROM
    statistics as s
    LEFT JOIN items AS i USING(itemnumber)
    LEFT JOIN biblioitems AS bi USING(biblionumber)
    LEFT JOIN biblio_metadata bm ON (bi.biblionumber = bm.biblionumber)
    LEFT JOIN branches AS br ON(i.homebranch = br.branchcode)
    LEFT JOIN authorised_values av ON (av.authorised_value = i.location)
WHERE 
    s.type = "issue" AND not s.borrowernumber is null
GROUP BY
    `Дата` ASC,
    i.homebranch ASC,
    `Розташування` ASC
ORDER BY
    `Дата` ASC,
    i.homebranch ASC,
    `Розташування` ASC