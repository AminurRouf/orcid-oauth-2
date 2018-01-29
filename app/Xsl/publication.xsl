<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:a="http://www.w3.org/2005/Atom"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"
	xmlns:ns1="http://webservices.elsevier.com/schemas/search/fast/types/v4"
	xmlns:ns2="http://webservices.elsevier.com/schemas/search/fast/types/v4"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
	xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
	xmlns:sa="http://www.elsevier.com/xml/common/struct-aff/dtd"
	xmlns:sb="http://www.elsevier.com/xml/common/struct-bib/dtd"
	xmlns:tb="http://www.elsevier.com/xml/common/table/dtd"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xocs="http://www.elsevier.com/xml/xocs/dtd"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="a xhtml dc mml ns1 ns2 opensearch prism sa sb tb xlink xocs">

  <xsl:param name="apikey" select="'b3a71de2bde04544495881ed9d2f9c5b'"/>

  <xsl:output method="html" encoding="utf-8"
		omit-xml-declaration="yes"
		indent="no"
		doctype-public="-//W3C//DTD XHTML 1.1//EN"
		doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
						select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" />
  <!-- Ignore unknown elements -->

  <xsl:template match="a:search-results">

    <xsl:variable name="query1" select="opensearch:Query/@searchTerms" />
    <xsl:variable name="query2">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$query1" />
        <xsl:with-param name="replace" select="'%28'" />
        <xsl:with-param name="by" select="'('" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="query3">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$query2" />
        <xsl:with-param name="replace" select="'%29'" />
        <xsl:with-param name="by" select="')'" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="query">
      <xsl:call-template name="string-replace-all">
        <xsl:with-param name="text" select="$query3" />
        <xsl:with-param name="replace" select="'+'" />
        <xsl:with-param name="by" select="' '" />
      </xsl:call-template>
    </xsl:variable>

    <div>
      <b>
        Total Results: <xsl:value-of select="opensearch:totalResults" disable-output-escaping="no" />
      </b>
      <br/>
      <xsl:for-each select="a:link">
        <xsl:if test="./@ref='first'">
          <button type="button" onclick="displayPage(&apos;{./@href}&apos;);return false;">
            &#171;
          </button>&#160;
        </xsl:if>
        <xsl:if test="./@ref='prev'">
          <button type="button" onclick="displayPage(&apos;{./@href}&apos;);return false;">
            &#8249;
          </button>&#160;
        </xsl:if>
        <xsl:if test="./@ref='next'">
          <button type="button" onclick="displayPage(&apos;{./@href}&apos;);return false;">
            &#8250;
          </button>&#160;
        </xsl:if>
        <xsl:if test="./@ref='last'">
          <button type="button" onclick="displayPage(&apos;{./@href}&apos;);return false;">
            &#187;
          </button>&#160;
        </xsl:if>
      </xsl:for-each>
      <br/>
      <br/>
    </div>

    <div>
      <table border="0" width="100%" rules="rows" style="color:#001825">
        <tr bgcolor="#33828D">
          <th></th>
          <th>
            Scopus Search for:
            <xsl:value-of select="$query" />
          </th>
          <th></th>
        </tr>
        <xsl:for-each select="a:entry">
          <tr>
            <td>
            </td>
            <td>
              <b>
                <xsl:text disable-output-escaping="no">Scopus ID: </xsl:text>
              </b>
              <xsl:value-of select="dc:identifier" />
              <br/>
              <b>
                <xsl:text disable-output-escaping="no">Title: </xsl:text>
              </b>
              <xsl:value-of select="dc:title" />
              <br/>
              <b>
                <xsl:text disable-output-escaping="no">Publication Name: </xsl:text>
              </b>
              <xsl:value-of select="prism:publicationName" />
              <br/>
              <xsl:if test="prism:issn">
                <b>
                  <xsl:text disable-output-escaping="yes">ISSN: </xsl:text>
                </b>
                <xsl:value-of select="prism:issn" />
              </xsl:if>
              <xsl:if test="prism:isbn">
                <b>
                  <xsl:text disable-output-escaping="yes">ISBN: </xsl:text>
                </b>
                <xsl:value-of select="prism:isbn" />
              </xsl:if>
              <br/>
              <b>
                <xsl:text disable-output-escaping="no">Publication Date: </xsl:text>
              </b>
              <xsl:value-of select="prism:coverDisplayDate" />
              <br/>
              <b>
                <xsl:text disable-output-escaping="no">First Author: </xsl:text>
              </b>
              <xsl:value-of select="dc:creator" />
              <br/>
              <xsl:if test="a:author">
                <b>
                  <xsl:text disable-output-escaping="no">Additional Authors: </xsl:text>
                </b>
                <xsl:for-each select="a:author">
                  <xsl:value-of select="a:authname" />
                  <xsl:text disable-output-escaping="yes"> | </xsl:text>
                </xsl:for-each>
                <br/>
              </xsl:if>
              <xsl:if test="a:authkeywords">
                <b>
                  <xsl:text disable-output-escaping="yes">Author Keywords: </xsl:text>
                </b>
                <xsl:value-of select="a:authkeywords" />
                <br/>
              </xsl:if>
              <xsl:if test="prism:doi">
                <b>
                  <xsl:text disable-output-escaping="yes">DOI: </xsl:text>
                </b>
                <xsl:value-of select="prism:doi" />
                <br/>
              </xsl:if>
              <xsl:if test="prism:volume">
                <b>
                  <xsl:text disable-output-escaping="yes">Volume:</xsl:text>
                </b>
                <xsl:value-of select="prism:volume" />
                <br/>
              </xsl:if>
              <xsl:if test="prism:issueIdentifier">
                <b>
                  <xsl:text disable-output-escaping="yes">Issue:</xsl:text>
                </b>
                <xsl:value-of select="prism:issueIdentifier" />
                <br/>
              </xsl:if>
              <xsl:if test="prism:pageRage">
                <b>
                  <xsl:text disable-output-escaping="yes">Page Range:</xsl:text>
                </b>
                <xsl:value-of select="prism:pageRange" />
                <br/>
              </xsl:if>
              <xsl:if test="prism:coverDate">
                <b>
                  <xsl:text disable-output-escaping="yes">Cover Date:</xsl:text>
                </b>
                <xsl:value-of select="prism:coverDate" />
                <br/>
              </xsl:if>
              <xsl:if test="prism:coverDisplayDate">
                <b>
                  <xsl:text disable-output-escaping="yes">Cover Display Date:</xsl:text>
                </b>
                <xsl:value-of select="prism:coverDisplayDate" />
                <br/>
              </xsl:if>
              <!--								<xsl:text disable-output-escaping="yes">Abstract: </xsl:text><font size="-1em">-->
              <!--								<xsl:value-of select="dc:description" /></font>-->
              <!--								<br/>-->
              <b>
                <xsl:text disable-output-escaping="yes">Link: </xsl:text>
              </b>
              <xsl:for-each select="a:link">
                <xsl:if test="@ref='scopus'">
                  <a href="{@href}" target="_blank">
                    <xsl:value-of select="@href" />
                  </a>
                </xsl:if>
              </xsl:for-each>
              <br/>
              <b>
                <xsl:text disable-output-escaping="yes">Cited by count: </xsl:text>
              </b>
              <xsl:value-of select="a:citedby-count" />
              <xsl:choose>
                <xsl:when test="prism:teaser">
                  <b>
                    <xsl:text disable-output-escaping="yes">Abstract snippet: </xsl:text>
                  </b>
                  <xsl:value-of select="prism:teaser" disable-output-escaping="no" />
                </xsl:when>
              </xsl:choose>
              <br/>
              <xsl:element name="input">

                <xsl:attribute name="type">Button</xsl:attribute>

                <xsl:attribute name = "value">Claim</xsl:attribute>

              </xsl:element>
            </td>
            <td>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </div>

  </xsl:template>
</xsl:stylesheet>