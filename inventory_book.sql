SELECT
    -- Інвентарний номер
    CONCAT(
        '<a href=\"/cgi-bin/koha/catalogue/detail.pl?biblionumber=',
        b.biblionumber,
        '\">',
        i.stocknumber,
        '</a>'
    ) AS `Інвертарний номер`,
    -- № КСО
    ExtractValue(i.more_subfields_xml,'//datafield[@tag="999"]/subfield[@code="X"]') as `КСО`,
    -- Автор, назва
    CONCAT(
        b.author,
        ': ',
        b.title
    ) AS `Автор: назва`,
    -- Місце і рік видання
    CONCAT(
        bi.place,
        '::',
	    b.copyrightdate
    ) as `Місце::рік видання`,
    -- Ціна
    ExtractValue(bm.metadata,'//datafield[@tag="020"]/subfield[@code="c"]') as `Ціна`,
    -- Позначка про перевірку (Службова примітка)
    i.itemnotes_nonpublic as `Позначка про перевірку`,
    -- № акту списання
    ExtractValue(i.more_subfields_xml,'//datafield[@tag="999"]/subfield[@code="C"]') as `№ акту списання`,
    -- Примітка
    b.notes AS `Примітка`
FROM
    items AS i
    LEFT JOIN biblio AS b USING(biblionumber)
    LEFT JOIN biblioitems AS bi USING(biblioitemnumber)
    LEFT JOIN biblio_metadata bm ON (i.biblionumber=bm.biblionumber) 
WHERE 
    i.homebranch = <<Виберіть бібліотеку|branches>> 
ORDER BY
    i.stocknumber ASC