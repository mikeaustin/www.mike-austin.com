<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template match="/">

<html xmlns:xsl="http://www.w3.org/TR/WD-xsl">
  <style>
    td { font-family: Arial,helvetica,sans-serif; font-size: 10pt; }
  </style>
  <body STYLE="font-family:Arial,helvetica,sans-serif;font-size:10pt; background-color:#FFFFFF">
    <xsl:for-each select="/glossary/categs/categ" order-by="+@name">
      <h3><xsl:value-of select="@name"/></h3>
      <table border="0" width="100%" bgcolor="#D0D0D0" cellpadding="5" cellspacing="0">
        <tr><td height="1"></td></tr>
        <xsl:for-each select="/glossary/node[categ/@name=context(-1)/@name]" order-by="+@name">
          <tr><td bgcolor="#E8F0FF">
            <b><xsl:value-of select="@name"/> • </b>
            <!--xsl:value-of select="desc"/-->
            <xsl:value-of/>
            <xsl:for-each select="categ" order-by="+@name">
              <i><xsl:value-of select="@name"/></i>
            </xsl:for-each>
          </td></tr>
          <tr><td height="1"></td></tr>
        </xsl:for-each>
      </table>
    </xsl:for-each>
    <br/><h5>References:</h5>
    <xsl:for-each select="/glossary/refs/node">
      <a>
        <xsl:attribute name="href">
          http://<xsl:value-of/>
        </xsl:attribute>
        <xsl:value-of/>
      </a><br/>
    </xsl:for-each>
  </body>
</html>

</xsl:template>
</xsl:stylesheet>

<!--
          <tr><td bgcolor="#F4F4F4">

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
