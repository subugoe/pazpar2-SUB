<?xml version="1.0" encoding="UTF-8"?>
<!--
	Maps the URL in Marc 856 $u to the catalogue link.
	
	September 2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tmarc="http://www.indexdata.com/turbomarc"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>


	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tmarc:d856">
		<xsl:if test="tmarc:su">
			<pz:metadata type="catalogue-url">
				<xsl:value-of select="normalize-space(.)"/>
			</pz:metadata>
		</xsl:if>
	</xsl:template>


</xsl:stylesheet>
