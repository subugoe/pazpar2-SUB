<?xml version="1.0" encoding="UTF-8"?>
<!--
	Marc records occasionally contain multiple concatenated ISO 639-2/B
		codes in Marc 041 subfields (apparently this was the way to do it
		in an previous versions of the standard.
		
	This transformation splits them up into separate subfields.
	
	Example records:
	* http://opac.nebis.ch/F/?func=full-set-set&set_number=037300&set_entry=000001&format=001
	* http://agricola.nal.usda.gov/cgi-bin/Pwebrecon.cgi?v3=1&ti=1,1&SEQ=20120113073747&CNT=10&Search_Arg=1739398&Search_Code=CMD&PID=oxtPZ6JdNCF6WHljt6zOEnC91cTar&SID=1

	January 2012
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
		version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tmarc="http://www.indexdata.com/turbomarc">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>


	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="tmarc:d041">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:for-each select="*">
				<xsl:call-template name="nChars">
					<xsl:with-param name="content" select="."/>
					<xsl:with-param name="charCount" select="3"/>
					<xsl:with-param name="elementName" select="name(.)"/>
					<xsl:with-param name="elementNamespace" select="namespace-uri(.)"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="nChars">
		<xsl:param name="content"/>
		<xsl:param name="charCount"/>
		<xsl:param name="elementName"/>
		<xsl:param name="elementNamespace"/>

		<xsl:element namespace="{$elementNamespace}" name="{$elementName}">
			<xsl:value-of select="substring($content, 1, $charCount)"/>
		</xsl:element>
		
		<xsl:if test="string-length($content) &gt; $charCount">
			<xsl:call-template name="nChars">
				<xsl:with-param name="content" select="substring($content, $charCount + 1)"/>
				<xsl:with-param name="charCount" select="$charCount"/>
				<xsl:with-param name="elementName" select="$elementName"/>
				<xsl:with-param name="elementNamespace" select="$elementNamespace"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>


</xsl:stylesheet>
