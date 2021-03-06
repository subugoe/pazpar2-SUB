<?xml version="1.0" encoding="UTF-8"?>
<!--
	Post-processes solr records coming out of solr-pz2.xsl to make
	their metadata field names match those used by tmarc.xsl.

	Maps:

	abstract -> description
	citation -> journal-subpart
	subject -> classification
	issued -> date
	keyword -> subject-long
	origlanguage -> language
	pissn -> issn
	eissn -> issn
	url -> electronic-url

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

	<xsl:template match="pz:record">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
		<!-- Right now, all data we have are articles. -->
		<pz:metadata type="medium">article</pz:metadata>
	</xsl:template>


	<xsl:template match="pz:metadata[@type='citation']">
		<pz:metadata type="journal-subpart">
			<xsl:value-of select="." />
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='classification']">
		<pz:metadata type="subject">
			<xsl:value-of select="." />
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='issued']">
		<pz:metadata type="date">
			<xsl:value-of select="." />
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='keyword']">
		<pz:metadata type="subject-long">
			<xsl:value-of select="." />
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='pissn']">
		<pz:metadata type="issn">
			<xsl:value-of select="." />
		</pz:metadata>
	</xsl:template>

	<xsl:template match="pz:metadata[@type='url']">
		<pz:metadata type="electronic-url">
			<xsl:value-of select="." />
		</pz:metadata>
	</xsl:template>



	<!--
		call iso-639-1-converter template from iso-639-1-to-639-2b.xsl
		use the first two characters of the field content only
	-->
	<xsl:template match="pz:metadata[@type='origlanguage']">
		<pz:metadata type="language">
			<xsl:call-template name="iso-639-1-converter">
				<xsl:with-param name="languageCode" select="substring(., 1, 2)"/>
			</xsl:call-template>
		</pz:metadata>
	</xsl:template>


</xsl:stylesheet>
