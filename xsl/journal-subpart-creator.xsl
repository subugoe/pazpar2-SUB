<?xml version="1.0" encoding="UTF-8"?>
<!--
	Adds the journal-subpart field for easy display if it does not exist
	but the underlying information in volume/issue/pages-number is present.

	June 2012
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:pz="http://www.indexdata.com/pazpar2/1.0">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8"/>

	<!-- Copy all remaining nodes. -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="pz:record">
		<xsl:copy>
			<!-- Copy everything. -->
			<xsl:apply-templates select="@*|node()"/>

			<!-- If there is journal information but no journal-subpart field, create it. -->
			<xsl:if test="not(pz:metadata[@type='journal-subpart'])
							and (pz:metadata[@type='volume-number']
								or pz:metadata[@type='issue-number']
								or pz:metadata[@type='pages-number'])">
				<xsl:variable name="journal-subpart">
					<xsl:if test="string-length(pz:metadata[@type='volume-number']) &gt; 0">
						<xsl:text>Vol. </xsl:text>
						<xsl:value-of select="pz:metadata[@type='volume-number']"/>
					</xsl:if>
					<xsl:if test="string-length(pz:metadata[@type='issue-number']) &gt; 0">
						<xsl:text> No. </xsl:text>
						<xsl:value-of select="pz:metadata[@type='issue-number']"/>
					</xsl:if>
					<xsl:if test="string-length(pz:metadata[@type='date']) &gt; 0">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="pz:metadata[@type='date']"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
					<xsl:if test="string-length(pz:metadata[@type='pages-number']) &gt; 0">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="pz:metadata[@type='pages-number']"/>
					</xsl:if>
				</xsl:variable>

				<xsl:if test="string-length($journal-subpart) &gt; 0">
					<pz:metadata type="journal-subpart">
						<xsl:value-of select="$journal-subpart"/>
					</pz:metadata>
				</xsl:if>
			</xsl:if>

		</xsl:copy>

	</xsl:template>

</xsl:stylesheet>
