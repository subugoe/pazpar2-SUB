<?xml version="1.0" encoding="UTF-8"?>
<!--
	Slight cleanup for FU Berlin MARC Data.

	2013 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tmarc="http://www.indexdata.com/turbomarc">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:strip-space elements="*" />


	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>



	<!--
		Articles in titles can have << >> around them (non-sorting).
		Remove those characters to get more readable strings.
	-->
	<xsl:template match="tmarc:d245/tmarc:sa">
		<xsl:copy>
			<xsl:variable name="string1">
				<xsl:call-template name="string-replace">
					<xsl:with-param name="string" select="."/>
					<xsl:with-param name="search" select="'&lt;&lt;'"/>
					<xsl:with-param name="replace" select="''"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="string2">
				<xsl:call-template name="string-replace">
					<xsl:with-param name="string" select="$string1"/>
					<xsl:with-param name="search" select="'&gt;&gt;'"/>
					<xsl:with-param name="replace" select="''"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$string2"/>
		</xsl:copy>
	</xsl:template>



	<!--
		Remove 500 field if it contains »(a/Z)«.
		This seems to be quite frequent and does not look like a helpful comment.
	-->
	<xsl:template match="tmarc:d500">
		<xsl:if test="not(contains(., '(a/Z)'))">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>



	<!--
		Kill 900 fields with issue information.
		There tend to be many of those and we don't use them.
	-->
	<xsl:template match="tmarc:d900"></xsl:template>



	<!--
		Template to Search & Replace in a string.
	-->
	<xsl:template name="string-replace">
		<xsl:param name="string"/>
		<xsl:param name="search"/>
		<xsl:param name="replace"/>

		<xsl:choose>
			<xsl:when test="contains($string, $search)">
				<xsl:value-of select="substring-before($string, $search)"/>
				<xsl:value-of select="$replace"/>
				<xsl:call-template name="string-replace">
					<xsl:with-param name="string" select="substring-after($string, $search)"/>
					<xsl:with-param name="search" select="$search"/>
					<xsl:with-param name="replace" select="$replace"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
