<?xml version="1.0" encoding="UTF-8"?>
<!--
	Maps the corporate and meeting-related fields in a pazpar2 record to
	the author or person-other fields.
	This way they can be handled by the same display logic.

	March 2013 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0"
	version="1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="pz:metadata[@type='corporate-name'] | pz:metadata[@type='meeting-name']">
		<xsl:variable name="destinationField">
			<xsl:choose>
				<xsl:when test="not(../pz:metadata[@type='author']) and position()=1">author</xsl:when>
				<xsl:otherwise>other-person</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<pz:metadata type="{$destinationField}" original-field="{@type}">
			<xsl:apply-templates select="@*[local-name!='type']|node()"/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
