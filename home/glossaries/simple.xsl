<?xml version="1.0"?>
<html xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <body STYLE="font-family:Arial, helvetica, sans-serif; font-size:12pt;
        background-color:#EEEEEE">
    <xsl:for-each select="menus">
    <!--xsl:for-each select="breakfast_menu/food"-->
    <!--xsl:for-each select="*/food"-->
      <xsl:for-each select="*">
        <!--xsl:node-name/-->
        <xsl:value-of select="@name"/> <hr/>
        <xsl:for-each select="food">
          <DIV STYLE="margin-left:20px; background-color:teal; color:white; padding:4px">
            <SPAN STYLE="font-weight:bold; color:white"><xsl:value-of select="name"/></SPAN>
            - <xsl:value-of select="price"/>
          </DIV>
          <DIV STYLE="margin-left:25px; margin-bottom:1em; font-size:10pt">
            <xsl:value-of select="description"/>
            <SPAN STYLE="font-style:italic">
              (<xsl:value-of select="calories"/> calories per serving)
            </SPAN>
          </DIV>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </body>
</html>
