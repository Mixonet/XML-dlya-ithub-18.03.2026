<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" encoding="utf-8" indent="yes"/>

    <!-- Ключ для группировки по городам -->
    <xsl:key name="city-group" match="item" use="@city" />
    
    <!-- Ключ для группировки компаний внутри городов (учитываем связку : Город + Компания) -->
    <xsl:key name="org-group" match="item" use="concat(@city, '|', @org)" />

    <xsl:template match="/orgs">
        <html>
            <head>
                <title>Города и компании</title>
            </head>
            <body>
                <h1>Города и компании</h1>
                <ul>
                    <!-- Группируем по городам -->
                    <xsl:for-each select="item[generate-id() = generate-id(key('city-group', @city)[1])]">
                        <xsl:variable name="currentCity" select="@city" />
                        
                        <li>
                            <strong><xsl:value-of select="$currentCity"/></strong>
                            <br/>Всего товаров: <xsl:value-of select="count(../item[@city=$currentCity])"/>
                            
                            <ul>
                                <!-- группируем по организациям внутрт текущего города -->
                                <xsl:for-each select="../item[@city=$currentCity][generate-id() = generate-id(key('org-group', concat($currentCity, '|', @org))[1])]">
                                    <xsl:variable name="currentOrg" select="@org" />
                                    
                                    <li>
                                        <xsl:value-of select="$currentOrg"/>
                                        <br/>Всего товаров: <xsl:value-of select="count(../item[@city=$currentCity and @org=$currentOrg])"/>
                                        
                                        <ul>
                                            <!-- Выводим товары конкретной компании в конкретном городе -->
                                            <xsl:for-each select="../item[@city=$currentCity and @org=$currentOrg]">
                                                <li><xsl:value-of select="@title"/></li>
                                            </xsl:for-each>
                                        </ul>
                                    </li>
                                </xsl:for-each>
                            </ul>
                            <br/>
                        </li>
                    </xsl:for-each>
                </ul>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>