<?xml version="1.0" encoding="UTF-8"?>
<!--
	Massage records harvested from arxiv.org:
		- turn electronic-url into catalogue-url
		- make all records medium electronic
		- move MSCs to classification-msc field

	2012-2013 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
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
		Turn electronic-url field into catalogue-url if it points to the
		arXiv server.
	-->
	<xsl:template match="pz:metadata[@type='electronic-url']">
		<xsl:choose>
			<xsl:when test="substring(., 1, 21) = 'http://arxiv.org/abs/'">
				<pz:metadata type="catalogue-url">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:when>
			<xsl:otherwise>
				<pz:metadata type="electronic-url">
					<xsl:value-of select="."/>
				</pz:metadata>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- All records are of type 'electronic' -->
	<xsl:template match="pz:metadata[@type='medium']">
		<pz:metadata type="medium">electronic</pz:metadata>
	</xsl:template>


	<!--
		Extract MSCs:
		Solr field subject_msc to pz:metadata of type 'classification-msc'
	-->
	<xsl:template match="pz:metadata[@type='subject_msc']">
		<pz:metadata type="classification-msc">
			<xsl:value-of select="."/>
		</pz:metadata>
	</xsl:template>


</xsl:stylesheet>
