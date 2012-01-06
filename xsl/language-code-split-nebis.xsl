<?xml version="1.0" encoding="UTF-8"?>
<!--
	Records in NEBIS can have multiple concatenated language ISO 639-2/B
		codes in Marc 041 subfields. This style sheet splits them up into 
		separate subfields.
	
	Example record: 
		http://opac.nebis.ch/F/?func=full-set-set&set_number=037300&set_entry=000001&format=001

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
			<xsl:for-each select="*">
				<xsl:call-template name="nChars">
					<xsl:with-param name="content" select="."/>
					<xsl:with-param name="charCount" select="3"/>
					<xsl:with-param name="elementName" select="name(.)"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="nChars">
		<xsl:param name="content"/>
		<xsl:param name="charCount"/>
		<xsl:param name="elementName"/>

		<xsl:element name="{$elementName}">
			<xsl:value-of select="substring($content, 1, $charCount)"/>
		</xsl:element>
		
		<xsl:if test="string-length($content) &gt; $charCount">
			<xsl:call-template name="nChars">
				<xsl:with-param name="content" select="substring($content, $charCount + 1)"/>
				<xsl:with-param name="charCount" select="$charCount"/>
				<xsl:with-param name="elementName" select="$elementName"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:template>


</xsl:stylesheet>
