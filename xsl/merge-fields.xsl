<?xml version="1.0" encoding="UTF-8"?>
<!--
	Create special fields used for merging.
	These should provide more control over the merging process.
	The strategy is:
		* create a single merge-title field containing all title fields
			as different catalogues use different techniques to split up
			titles (e.g. using MARC 245 $a and $b vs putting everything
			in a single field)
		* only use the first author
			as other authors are notoriously hard to find reliably /
			poorly catalogued (frequently because of a missing $e aut
			in MARC 700), this prevents obvious deduplication
		* try to only use the surname of the author
			as different catalogueging standards seem to describe different
			rules here (one first name vs. first name plus initials vs.
			initials only) which prevent deduplication

	May 2012 Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->

<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>
	<xsl:strip-space elements="*" />

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>



	<xsl:template match="pz:record">
		<xsl:copy>
			<!-- preserve all existing nodes -->
			<xsl:apply-templates select="@*|node()"/>

			<!--
			title: join the content of
				* title
				* title-remainder
				* title-number-section
			-->
			<pz:metadata type="merge-title">
				<xsl:value-of select="pz:metadata[@type='title'][1]"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="pz:metadata[@type='title-remainder'][1]"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="pz:metadata[@type='title-number-section'][1]"/>
			</pz:metadata>

			<!--
				first author:
					* preserve the field
					* only use the part of the field content before the comma
			-->
			<pz:metadata type="merge-author">
				<xsl:value-of select="substring-before(pz:metadata[@type='author'][1], ',')"/>
			</pz:metadata>

		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
