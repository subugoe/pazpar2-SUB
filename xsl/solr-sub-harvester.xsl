<?xml version="1.0" encoding="UTF-8"?>
<!--
	Post-processes solr records coming from the SUB Harvesting Solr server.
	
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



	<xsl:template match="pz:metadata[@type='publisher']">
		<pz:metadata type="publication-name">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='publishDate']">
		<pz:metadata type="date">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='publishPlace']">
		<pz:metadata type="publication-place">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='physical']">
		<pz:metadata type="physical-extent">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

	<!-- dodgy: this is formatted journal information, we’d prefer proper journal information -->
	<xsl:template match="pz:metadata[@type='source']">
		<pz:metadata type="journal-title">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>


	<xsl:template match="pz:metadata[@type='type']">
		<pz:metadata type="medium">
			<xsl:choose>
				<xsl:when test=".='text'">article</xsl:when>
				<xsl:when test=".='journal'">journal</xsl:when>
				<xsl:when test=".='book'">book</xsl:when>
				<xsl:when test=".='proceeding'">book</xsl:when>
				<xsl:when test=".='monograph'">book</xsl:when>
				<!-- unclean: keep original media type string -->
				<xsl:otherwise>electronic</xsl:otherwise>
			</xsl:choose>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='url']">
		<pz:metadata type="electronic-url">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
