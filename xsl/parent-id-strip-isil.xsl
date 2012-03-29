<?xml version="1.0" encoding="UTF-8"?>
<!--
	The parent-id field may have the form
		(ISIL)recordID
	This stylesheet strips the (ISIL) part.

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


	<xsl:template match="pz:metadata[@type='parent-id']">

		<xsl:copy>
			<xsl:copy-of select="@type"/>
			<xsl:value-of select="substring-after(., ')')"/>
		</xsl:copy>

	</xsl:template>

</xsl:stylesheet>
