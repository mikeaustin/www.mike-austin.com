<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">

<html xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <style>
    td { font-family:Arial, helvetica, sans-serif; font-size:10pt; }
  </style>
  <body STYLE="font-family:Arial, helvetica, sans-serif; font-size:14pt; font-weight: bold;
   background-color:#FFFFFF">
    <xsl:for-each select="/glossary/categs/categ" order-by="+@name">
      <xsl:value-of select="@name"/><br/>
      <table border="0" xbgcolor="#AAAAAA" cellpadding="5" cellspacing="0">
        <xsl:for-each select="/glossary/node[categ/@name=context(-1)/@name]" order-by="+@name">
          <tr><td xbgcolor="#FFFFFF">
            <b><xsl:value-of select="@name"/> &#183; </b>
            <xsl:value-of select="desc"/>
            <xsl:for-each select="categ" order-by="+@name">
              <i><xsl:value-of select="@name"/></i>
            </xsl:for-each>
          </td></tr>
        </xsl:for-each>
      </table>
    </xsl:for-each>
  </body>
</html>

  </xsl:template>
</xsl:stylesheet>

<!--
<html xmlns:xsl="http://www.w3.org/TR/WD-xsl">
      <xsl:for-each select="/glossary/node[categ/@name='memory']" order-by="+@name">
<html xmlns:xsl="http://www.w3.org/1999/Transform">
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/Transform">

<xsl:variable name="x">x
</xsl:variable>

<?xml version="1.0"?>
<html xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <body STYLE="font-family:Arial, helvetica, sans-serif; font-size:12pt;
        background-color:#EEEEEE">
    <xsl:for-each select="glossary">
    <xsl:node-name/>
    <xsl:value-of select="@name"/> <hr/>

    <xsl:for-each select="glossarynode">
      [<xsl:value-of select="@name"/>]
      <xsl:value-of/>
      <xsl:value-of select="name"/>
    </xsl:for-each>
  </body>
</html>
-->
