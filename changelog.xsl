<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
    xmlns:exsl="http://exslt.org/common"
    xmlns:func="http://exslt.org/functions"
    xmlns:fn="http://xml.apache.org/xalan/java/xsl.lib.XSLUtil"
    extension-element-prefixes="fn exsl func">

 <xsl:output
   method="html"
   encoding="utf-8"
   media-type="text/html"
   omit-xml-declaration="yes"
   standalone="yes"
doctype-system="about:legacy-compat"
   indent="yes"/>

 <xsl:param name="title" select="'ChangeLog'" />
 <xsl:param name="revision-link" select="'#r'" />
 <xsl:param name="ticket-link" select="''" />
 <xsl:param name="ticket-prefix" select="'#'" />

 <!-- match toplevel element -->
 <xsl:template match="log">
  <html>
   <head>
    <title><xsl:value-of select="string($title)" /></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"/>
    <script
        src="https://code.jquery.com/jquery-3.2.1.min.js"
        integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
        crossorigin="anonymous"></script>
    <style type="text/css">
      .line {
        border-bottom: 1px solid #d0d0d0;
      }

      .no-tags {
        color: red;
      }
      .tag-internal {
        color: #a0a0a0;
      }

      table td {
        padding-left: 4px;
      }
      table th {
        padding-top: 8px;
        padding-bottom: 8px;
      }

      .header {
        padding-bottom: 0.5em;  
      }
    </style>
    <script><![CDATA[
$(document).ready(function () {
      $("#filter-internal").click(function () {
        $(".tag-internal").each(function (idx, el) { 
          $(el).css("display", "none");
        });
      })

      $("#filter-no-tags").click(function () {
        $(".no-tags").each(function (idx, el) { 
          $(el).css("display", "none");
        });
      })

      $("#filter-date").click(function () {
        $(".cell-date").each(function (idx, el) { 
          $(el).css("display", "none");
        });
      })

      $("#filter-author").click(function () {
        $(".cell-author").each(function (idx, el) { 
          $(el).css("display", "none");
        });
      })

      $("#filter-merge").click(function () {
        $(".cell-merge").each(function (idx, el) { 
          $(el).css("display", "none");
        });
      })

       $("#filter-tag").click(function () {
        $(".cell-tag").each(function (idx, el) { 
          $(el).css("display", "none");
        });
      })
});
      ]]>
    </script>
   </head>
   <body>
    <div class="container-fluid">
    <xsl:if test="$title">
      <div class="header">
     <h1><xsl:value-of select="string($title)" /></h1>
     <button id="filter-internal" class="btn btn-xs btn-default">Hide internal</button>
     <xsl:text> </xsl:text>
     <button id="filter-no-tags" class="btn btn-xs btn-default">Hide without tags</button>
     <xsl:text> </xsl:text>
     <button id="filter-date" class="btn btn-xs btn-default">Hide date</button>
     <xsl:text> </xsl:text>
     <button id="filter-tag" class="btn btn-xs btn-default">Hide tag column</button>
     <xsl:text> </xsl:text>
     <button id="filter-author" class="btn btn-xs btn-default">Hide author</button>
     <xsl:text> </xsl:text>
     <button id="filter-merge" class="btn btn-xs btn-default">Hide merge</button>
      </div>
    </xsl:if>
    <table class="changelog_entries">
       <xsl:apply-templates select="logentry" />
    </table>
    <p class="footer">     
    </p>
  </div>
   </body>
  </html>
 </xsl:template>


 <xsl:template name="lines">
  <xsl:param name="pText" select="."/>

  <xsl:if test="string-length($pText)">
   <div class="line"><xsl:text/>
      <xsl:call-template name="strip-tags">
        <xsl:with-param name="str" select="substring-before(concat($pText, '&#xA;'), '&#xA;')"/>
      </xsl:call-template>

  </div>
   <xsl:call-template name="lines">
    <xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

  <xsl:template name="tag-lines">
  <xsl:param name="pText" select="."/>

  <xsl:if test="string-length($pText)">
   <div class="line"><xsl:text/>
      <xsl:call-template name="only-tags">
        <xsl:with-param name="str" select="substring-before(concat($pText, '&#xA;'), '&#xA;')"/>
      </xsl:call-template>
<xsl:text> </xsl:text>
  </div>
   <xsl:call-template name="tag-lines">
    <xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
   </xsl:call-template>
  </xsl:if>
 </xsl:template>

<xsl:template match="logentry">
  <xsl:variable name="omsg" select="normalize-space(msg)"/>
  <xsl:choose>
      <xsl:when test="starts-with($omsg, 'Merge ')">
        <tr><th colspan="4" class="cell-merge">
          <xsl:value-of select="substring-before(date, '+')"/>
          <xsl:value-of select="$omsg"/></th></tr>
      </xsl:when>
      <xsl:otherwise>


<xsl:variable name="tags"><xsl:choose>
              <xsl:when test="starts-with($omsg, '* ')">
                <xsl:call-template name="tag-lines">
                  <xsl:with-param name="pText" select="msg" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="only-tags">
                  <xsl:with-param name="str" select="$omsg"/>
                </xsl:call-template>
              </xsl:otherwise>
          </xsl:choose></xsl:variable>
<xsl:variable name="ttags" select="translate(translate(normalize-space($tags), ' ', ','), ';', ',')"/>
<tr>
    <xsl:attribute name="class">
      <xsl:choose>
      <xsl:when test="$ttags = ''">no-tags</xsl:when>
      <xsl:otherwise>
          <xsl:value-of select="'tag-'"/>
          <xsl:variable name="ttags2">
            <xsl:call-template name="replace-string">
              <xsl:with-param name="text" select="$ttags" />
              <xsl:with-param name="replace" select="',,'" />
              <xsl:with-param name="by" select="','" />
            </xsl:call-template>            
          </xsl:variable>
          <xsl:call-template name="replace-string">
            <xsl:with-param name="text" select="$ttags2" />
            <xsl:with-param name="replace" select="','" />
            <xsl:with-param name="by" select="' tag-'" />
          </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:attribute>

    <td nowrap="nowrap" valign="top" class="cell-date"><xsl:value-of select="substring-before(date, '+')"/></td>
    <td nowrap="nowrap" valign="top" class="cell-author"><xsl:value-of select="author"/></td>
      
    <td>
      <xsl:variable name="msg">
          <xsl:choose>
              <xsl:when test="starts-with($omsg, '* ')"><div class="wrapped">
                <xsl:call-template name="lines">
                  <xsl:with-param name="pText" select="msg" />
                </xsl:call-template>
              </div>
              </xsl:when>
              <xsl:otherwise>* 
                <xsl:call-template name="strip-tags">
                  <xsl:with-param name="str" select="$omsg"/>
                </xsl:call-template>
              </xsl:otherwise>
          </xsl:choose>
      </xsl:variable>
      <xsl:copy-of select="$msg"/>
    </td>
    <td class="cell-tag">
        <xsl:choose>
              <xsl:when test="starts-with($omsg, '* ')">
                <xsl:call-template name="tag-lines">
                  <xsl:with-param name="pText" select="msg" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="only-tags">
                  <xsl:with-param name="str" select="$omsg"/>
                </xsl:call-template>
              </xsl:otherwise>
          </xsl:choose>
    </td>
  </tr>

      </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="strip-tags">
    <xsl:param name="str"/>
    <xsl:choose>
        <xsl:when test="contains($str, '[')">
          <xsl:value-of select="substring-before($str, '[')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$str"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="only-tags">
    <xsl:param name="str"/>
    <xsl:choose>
        <xsl:when test="contains($str, '[')">
          <xsl:value-of select="normalize-space(translate(substring-after($str, '['), ']', ''))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="def-value">
    <xsl:param name="element"/>
    <xsl:param name="def"/>
    <xsl:choose>
    <xsl:when test="count($element) and string-length(normalize-space($element)) != 0">
      <xsl:apply-templates select="$element"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$def"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="replace-string">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
        <xsl:when test="$text = '' or $replace = ''or not($replace)" >
            <!-- Prevent this routine from hanging -->
            <xsl:value-of select="$text" />
        </xsl:when>
        <xsl:when test="contains($text, $replace)">
            <xsl:value-of select="substring-before($text,$replace)" />
            <xsl:value-of select="$by" />
            <xsl:call-template name="replace-string">
                <xsl:with-param name="text" select="substring-after($text,$replace)" />
                <xsl:with-param name="replace" select="$replace" />
                <xsl:with-param name="by" select="$by" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
