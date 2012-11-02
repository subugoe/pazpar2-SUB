<?xml version="1.0" encoding="UTF-8"?>
<!--
	Applies the template »iso-639-1-converter« from »iso-639-1-to-639-2b.xsl«
	to pz:metadata fields of type language.
	Copies all other fields unchanged.

	2011-2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
		version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:import href="iso-639-1-to-639-2b.xsl"/>

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>


	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="pz:metadata[@type='language']">
		<pz:metadata type="language">
			<xsl:call-template name="iso-639-1-converter">
				<xsl:with-param name="languageCode" select="."/>
			</xsl:call-template>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>

