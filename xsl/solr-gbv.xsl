<?xml version="1.0" encoding="UTF-8"?>
<!--
	Post-processes solr records coming from GBV’s findex Solr server.
	Many aspects of this are dodgy or incomplete (media types, non-coded languages, journal info, …)
	
	2011 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
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


	<xsl:template match="pz:metadata[@type='format_se']">
		<pz:metadata type="medium">
			<xsl:choose>
				<xsl:when test=".='Aufsätze'">article</xsl:when>
				<xsl:when test=".='Bücher'">book</xsl:when>
				<xsl:when test=".='Datenträger'">electronic</xsl:when>
				<xsl:when test=".='Elektronische Aufsätze'">electronic</xsl:when>
				<xsl:when test=".='Elektronische Bücher'">electronic</xsl:when>
				<xsl:when test=".='Filme'">audio-visual</xsl:when>
				<xsl:when test=".='Karten'">map</xsl:when>
				<xsl:when test=".='Noten'">music-score</xsl:when>
				<xsl:when test=".='Tonträger'">recording</xsl:when>
				<xsl:when test=".='Zeitschriften'">journal</xsl:when>
				<!-- unclean: keep original media type string -->
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='url']">
		<pz:metadata type="electronic-url">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>

</xsl:stylesheet>
