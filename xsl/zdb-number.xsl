<?xml version="1.0" encoding="UTF-8"?>
<!--
	Create a the metadata field »zdb-number« with the record-control-number
		coming from MARC field 016 if its source id »DE-600«.

	2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
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


	<!--
		If the record-control-number field has the source attribute »DE-600«
			it contains a ZDB number. Rewrite it to the »zdb-number« field.
	-->
	<xsl:template match="pz:metadata[@type='record-control-number' and @source='DE-600']">
		<pz:metadata type="zdb-number">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
