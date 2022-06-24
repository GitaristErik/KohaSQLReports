SELECT
    -- Дата запису
    i.dateaccessioned AS `Дата запису`,
    -- № запису
    ExtractValue(
        i.more_subfields_xml,
        '//datafield[@tag="999"]/subfield[@code="X"]'
    ) as `№ запису`,
    -- Звідки надійшли
    i.booksellerid as `Звідки надійшли`,
    -- № або дата супровідного документу (№ акту прибуття)
    ExtractValue(
        i.more_subfields_xml,
        '//datafield[@tag="999"]/subfield[@code="A"]'
    ) as `№ або дата супровідного документу`,
    -- Всього надійшло
    COUNT(*) as `Всього надійшло`,
    -- Підлягають запису в інвентар
    COUNT(IF(bi.itemtype LIKE "BK", 1, NULL)) as `Підлягають запису в інвентар`,
    -- Загальна сума
    SUM(PARSE_PRICE(bm.metadata)) as `Загальна сума`,
    -- 
    -- Брошури
    COUNT(IF(bi.itemtype LIKE "BH", 1, NULL)) as `Брошури`,
    -- Періодичні видання
    COUNT(IF(bi.itemtype LIKE "PER", 1, NULL)) as `Періодичні видання`,
    -- Електронні видання
    COUNT(IF(bi.itemtype LIKE "EB", 1, NULL)) as `Електронні видання`,
    -- Аудіовізуальні
    COUNT(IF(bi.itemtype LIKE "AV", 1, NULL)) as `Аудіовізуальні`,
    -- 
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
    COUNT(CHECK_LANGUAGE(bm.metadata, "ukr")) as `Українська мова`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "rus")) as `Російська мова`,
    COUNT(CHECK_LANGUAGE(bm.metadata, "eng")) as `Англійська мова`,
    -- Іноземними мовами
    COUNT(
        IF(
            not ExtractValue(
                bm.metadata,
                '//datafield[@tag="041"]/subfield[@code="a"]'
            ) in ("rus", "ukr", "eng"),
            1,
            NULL
        )
    ) as `Іноземними мовами`,
    -- 
    -- Назв
    COUNT(DISTINCT b.title) as `Назв`
FROM
    items AS i
    LEFT JOIN biblio AS b USING(biblionumber)
    LEFT JOIN biblioitems AS bi USING(biblioitemnumber)
    LEFT JOIN biblio_metadata bm ON (i.biblionumber = bm.biblionumber)
WHERE
    i.homebranch = <<Виберіть бібліотеку|branches>>
GROUP BY
    `Дата запису` ASC,
    `№ запису` ASC,
    `Звідки надійшли` ASC,
    `№ або дата супровідного документу` ASC
ORDER BY
    `Дата запису` ASC,
    `№ запису` ASC,
    `Звідки надійшли` ASC,
    `№ або дата супровідного документу` ASC