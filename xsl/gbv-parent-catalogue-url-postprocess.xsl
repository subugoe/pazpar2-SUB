<?xml version="1.0" encoding="UTF-8"?>
<!--
	Rewrites the address in the parent-catalogue-url pz:metadata field by:
		* replacing PPNSET by FAM
		* removing an ID prefix in brackets for the the PPN

	Example:
	https://opac.sub.uni-goettingen.de/DB=1/PPNSET?PPN=(DE-601)16276040X
	becomes: https://opac.sub.uni-goettingen.de/DB=1/FAM?PPN=16276040X

	March 2012
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="pz:metadata[@type='parent-catalogue-url']">

		<xsl:copy>
			<xsl:copy-of select="@type"/>
			<xsl:value-of select="substring-before(., 'PPNSET')"/>
			<xsl:text>FAM?PPN=</xsl:text>
			<xsl:choose>
				<xsl:when test="contains(., '(') and contains(., ')')">
					<xsl:value-of select="substring-after(., ')')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-after(., 'PPN=')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>

	</xsl:template>

</xsl:stylesheet>
