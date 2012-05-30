<?xml version="1.0" encoding="UTF-8"?>
<!--
	Takes 'urn' metadata fields and converts them to 'electronic-url'
	fields by prepending the address of DNB’s resolver.

	May 2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
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


	<xsl:template match="pz:metadata[@type='urn']">
		<pz:metadata type="electronic-url" name="URN">
			<xsl:text>http://nbn-resolving.de/</xsl:text>
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
