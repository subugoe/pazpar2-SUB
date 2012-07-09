<?xml version="1.0" encoding="UTF-8"?>
<!--
	For records from the JfM Solr index we want to use the field 'Zbl-Nr.'
	as the record ID, rather than the ID used by Solr.
	This is needed for building the correct links to the records.

	July 2012
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<xsl:param name="catalogueURLHintPrefix"/>
	<xsl:param name="catalogueURLHintPostfix"/>


	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>



	<!-- Delete existing ID -->
	<xsl:template match="pz:metadata[@type='id']"></xsl:template>

	<!-- Use content of field 'Zbl-Nr.' as the ID -->
	<xsl:template match="pz:metadata[@type='Zbl-Nr.']">
		<pz:metadata type="id">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
