<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <head>
    <title>Bookstore</title>
    <style type="text/css">
      table.bookstore { border: 1px groove black; }
      table.bookstore th,td { border: 1px groove black; }
      table.bookstore th { background-color: #9acd32; }
    </style>
  </head>
  <body>
    <h2>Bookstore</h2>
    <table class="bookstore">
      <tr>
        <th>Title</th>
        <th>Author</th>
      </tr>
      <xsl:for-each select="bookstore/book">
        <tr>
          <td><xsl:value-of select="title"/></td>
          <td><xsl:value-of select="author"/></td>
        </tr>
      </xsl:for-each>
    </table>
    <img src="circle.svg" />
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>

