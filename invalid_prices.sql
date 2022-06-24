SELECT
    -- Автор, назва
    CONCAT(
        '<a href=\"/cgi-bin/koha/catalogue/detail.pl?biblionumber=',
        b.biblionumber,
        '\">',
        CONCAT(b.author, ': ', b.title),
        '</a>'
    ) AS `Автор: назва`,
    -- Місце і рік видання
    CONCAT(
        bi.place,
        '::',
        b.copyrightdate
    ) as `Місце::рік видання`,
    -- Ціна
    ExtractValue(
        bm.metadata,
        '//datafield[@tag="020"]/subfield[@code="c"]'
    ) as `Ціна`
FROM
    items AS i
    LEFT JOIN biblio AS b USING(biblionumber)
    LEFT JOIN biblioitems AS bi USING(biblioitemnumber)
    LEFT JOIN biblio_metadata bm ON (i.biblionumber = bm.biblionumber)
WHERE
    PARSE_PRICE(bm.metadata) = 0 || PARSE_PRICE(bm.metadata) >= 600
ORDER BY
    i.stocknumber ASC