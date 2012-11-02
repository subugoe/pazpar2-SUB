<?xml version="1.0" encoding="UTF-8"?>
<!--
	Assume that the electronic-url fields point to fulltexts and enrich the record accordingly:
		1. add a note="Document" attribute to the electronic-url field
		2. add has-fulltext field with value »yes«

	June 2012
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<!-- Copy all remaining nodes. -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<!-- Add note="fulltext" attribute to electronic-url fields without an existing note. -->
	<xsl:template match="pz:metadata[@type='electronic-url']">
		<xsl:copy>
			<xsl:if test="not(./@note)">
				<xsl:attribute name="note">Document</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<!-- Add a has-fulltext field with value »yes«. -->
	<xsl:template match="pz:record">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<pz:metadata type="has-fulltext">yes</pz:metadata>
		</xsl:copy>
	</xsl:template>


	<!-- remove existing has-fulltext fields. -->
	<xsl:template match="pz:metadata[@type='has-fulltext']">
	</xsl:template>

</xsl:stylesheet>
