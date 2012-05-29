<?xml version="1.0" encoding="UTF-8"?>
<!--
	Slight cleanup for SWB Marc Data.

	2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
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
		SWB use field 689 for local keywords (Pica field 044K).
		https://wiki.bsz-bw.de/doku.php?id=v-team:daten:datendienste:marc21
		Map those to 690.
	-->
	<xsl:template match="tmarc:d689">
		<tmarc:d690>
			<xsl:apply-templates select="@*|node()"/>
		</tmarc:d690>
	</xsl:template>


	<!--
		SWB article records seem to contain the name of the containing
		journal in 773 $a. tmarc.xsl expects it in 773 $t: rewrite the
		information to that field.
	-->
	<xsl:template match="tmarc:d773/tmarc:sa">
		<tmarc:st>
			<xsl:apply-templates select="@*|node()"/>
		</tmarc:st>
	</xsl:template>


</xsl:stylesheet>
